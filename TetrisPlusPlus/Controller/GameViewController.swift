//
//  GameViewController.swift
//  TetrisPlusPlus
//
//  Created by Diego Neves on 25/08/18.
//  Copyright © 2018 dj. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    var scene: GameScene!
    var tetrisPlusPlus: TetrisPlusPlus!
    var panPointReference:CGPoint?
    var dataController: DataController!
    
    @IBOutlet weak var skView: SKView!
    
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var levelLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        self.showNavigationController(animated: animated)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return getDefaulStatusBarStyle()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        // Configure the view.
        //        let skView = view as! SKView
        // Configure the view.
        skView.isMultipleTouchEnabled = false
        
        // Create and configure the scene.
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .aspectFill
        scene.tick = didTick
        
        tetrisPlusPlus = TetrisPlusPlus()
        tetrisPlusPlus.delegate = self
        tetrisPlusPlus.beginGame(playSound : false)
        
        // Present the scene.
        skView.presentScene(scene)
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    func didTick() {
        tetrisPlusPlus.letShapeFall()
    }
    
    func nextShape() {
        let newShapes = tetrisPlusPlus.newShape()
        guard let fallingShape = newShapes.fallingShape else {
            return
        }
        self.scene.addPreviewShapeToScene(shape: newShapes.nextShape!) {}
        self.scene.movePreviewShape(shape: fallingShape) {
            self.view.isUserInteractionEnabled = true
            self.scene.startTicking()
        }
    }
    
    
}

extension GameViewController {
    
    
    @IBAction func didTap(sender: UITapGestureRecognizer) {
        
        tetrisPlusPlus.rotateShape()
        
    }
    
    @IBAction func fallShape(_ sender: Any) {
        tetrisPlusPlus.letShapeFall()
    }
    
    @IBAction func rotate(_ sender: Any) {
        tetrisPlusPlus.rotateShape()
    }
    
    
    @IBAction func didPan(sender: UIPanGestureRecognizer) {
        let currentPoint = sender.translation(in: self.view)
        if let originalPoint = panPointReference {
            
            if abs(currentPoint.x - originalPoint.x) > (BlockSize * 0.9) {
                if sender.velocity(in: self.view).x > CGFloat(0) {
                    tetrisPlusPlus.moveShapeRight()
                    panPointReference = currentPoint
                } else {
                    tetrisPlusPlus.moveShapeLeft()
                    panPointReference = currentPoint
                }
                
            }
        } else if sender.state == .began {
            panPointReference = currentPoint
        }
        
    }
    
    @IBAction func didSwipe(sender: UISwipeGestureRecognizer) {
        tetrisPlusPlus.dropShape()
        
    }
    
}

extension GameViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "back" {
        
            if let navigationController = segue.destination as? UINavigationController {
                let gameController = navigationController.topViewController as! BeginViewController
                gameController.dataController = self.dataController
                
            }
            
        }
        
    }
}


extension GameViewController : TetrisPlusPlusDelegate {
    
    func gameDidBegin(tetris: TetrisPlusPlus) {
        levelLabel.text = "\(tetris.level)"
        scoreLabel.text = "\(tetris.score)"
        scene.tickLengthMillis = TickLengthLevelOne
        
        // The following is false when restarting a new game
        if tetris.nextShape != nil && tetris.nextShape!.blocks[0].sprite == nil {
            scene.addPreviewShapeToScene(shape: tetris.nextShape!) {
                self.nextShape()
            }
        } else {
            nextShape()
        }
    }
    
    func gameDidEnd(tetris: TetrisPlusPlus) {
        view.isUserInteractionEnabled = false
        scene.stopTicking()
        scene.playSound(sound: "gameover.mp3")
        scene.stopSound()
        scene.animateCollapsingLines(linesToRemove: tetris.removeAllBlocks(), fallenBlocks: tetris.removeAllBlocks()) {
            let alertController = UIAlertController(title: "Game Over", message:
                "You Lose!", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Play Again", style: UIAlertActionStyle.default,handler: { (action) -> Void in
                tetris.beginGame(playSound : false)
                
            }))
            alertController.addAction(UIAlertAction(title: "Exit", style: UIAlertActionStyle.default,handler: { (action) -> Void in
                
                self.performSegue(withIdentifier: "back", sender: nil)
                
            }))
            
            self.present(alertController, animated: true, completion: self.saveScore)
            
        }
        
    }
    
    func saveScore() -> Void {
        
        let score : String! = self.scoreLabel.text
        let level : String! = self.levelLabel.text
        
        self.dataController.saveScore(scoreValue: Double(score)!, level: Int16(level)!)
    }
    
    func gameDidLevelUp(tetris: TetrisPlusPlus) {
        self.levelLabel.text = "\(tetris.level)"
        if scene.tickLengthMillis >= 100 {
            self.scene.tickLengthMillis -= 100
        } else if scene.tickLengthMillis > 50 {
            self.scene.tickLengthMillis -= 50
        }
        scene.playSound(sound: "levelup.mp3")
        print("levelup")
    }
    
    func gameShapeDidDrop(tetris: TetrisPlusPlus) {
        self.scene.stopTicking()
        self.scene.redrawShape(shape: tetris.fallingShape!) {
            tetris.letShapeFall()
        }
        self.scene.playSound(sound: "drop.mp3")
        print("drop")
    }
    
    func gameShapeDidLand(tetris: TetrisPlusPlus) {
        self.scene.stopTicking()
        self.view.isUserInteractionEnabled = false
        let removedLines = tetris.removeCompletedLines()
        if removedLines.linesRemoved.count > 0 {
            self.scoreLabel.text = "\(tetris.score)"
            self.scene.animateCollapsingLines(linesToRemove: removedLines.linesRemoved, fallenBlocks:removedLines.fallenBlocks) {
                self.gameShapeDidLand(tetris: tetris)
            }
            self.scene.playSound(sound: "bomb.mp3")
        } else {
            nextShape()
        }
    }
    
    func gameShapeDidMove(tetris: TetrisPlusPlus) {
        self.scene.redrawShape(shape: tetris.fallingShape!) {}
    }
    
}

extension GameViewController : UIGestureRecognizerDelegate {
    
    private func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    private func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailByGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UISwipeGestureRecognizer {
            if otherGestureRecognizer is UIPanGestureRecognizer {
                return true
            }
        } else if gestureRecognizer is UIPanGestureRecognizer {
            if otherGestureRecognizer is UITapGestureRecognizer {
                return true
            }
        }
        return false
    }
    
}
