//
//  GameViewController.swift
//  TetrisPlusPlus
//
//  Created by Diego Neves on 25/08/18.
//  Copyright © 2018 dj. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController, TetrisPlusPlusDelegate, UIGestureRecognizerDelegate {
    
    var scene: GameScene!
    var tetrisPlusPlus: TetrisPlusPlus!
    var panPointReference:CGPoint?
    
    @IBOutlet weak var skView: SKView!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var levelLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the view.
        skView.isMultipleTouchEnabled = false
        
        // Create and configure the scene.
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .aspectFill
        scene.tick = didTick
        
        tetrisPlusPlus = TetrisPlusPlus()
        tetrisPlusPlus.delegate = self
        tetrisPlusPlus.beginGame()
        
        // Present the scene.
        skView.presentScene(scene)
    }
    
    override var prefersStatusBarHidden: Bool{
        return false
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
        print("swipe")
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailByGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
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
        scene.animateCollapsingLines(linesToRemove: tetris.removeAllBlocks(), fallenBlocks: tetris.removeAllBlocks()) {
            tetris.beginGame()
        }
        print("gameover")
    }
    
    func gameDidLevelUp(tetris: TetrisPlusPlus) {
        levelLabel.text = "\(tetris.level)"
        if scene.tickLengthMillis >= 100 {
            scene.tickLengthMillis -= 100
        } else if scene.tickLengthMillis > 50 {
            scene.tickLengthMillis -= 50
        }
        scene.playSound(sound: "levelup.mp3")
        print("levelup")
    }
    
    func gameShapeDidDrop(tetris: TetrisPlusPlus) {
        scene.stopTicking()
        scene.redrawShape(shape: tetris.fallingShape!) {
            tetris.letShapeFall()
        }
       scene.playSound(sound: "drop.mp3")
          print("drop")
    }
    
    func gameShapeDidLand(tetris: TetrisPlusPlus) {
        scene.stopTicking()
        self.view.isUserInteractionEnabled = false
        let removedLines = tetris.removeCompletedLines()
        if removedLines.linesRemoved.count > 0 {
            self.scoreLabel.text = "\(tetris.score)"
            scene.animateCollapsingLines(linesToRemove: removedLines.linesRemoved, fallenBlocks:removedLines.fallenBlocks) {
                self.gameShapeDidLand(tetris: tetris)
            }
            scene.playSound(sound: "bomb.mp3")
        } else {
            nextShape()
        }
    }
    
    func gameShapeDidMove(tetris: TetrisPlusPlus) {
        scene.redrawShape(shape: tetris.fallingShape!) {}
    }
}
