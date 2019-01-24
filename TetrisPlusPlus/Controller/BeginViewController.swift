//
//  BeginViewController.swift
//  ios-tetrisPlusPlus
//
//  Created by Diego Neves on 20/01/19.
//  Copyright © 2019 dj. All rights reserved.
//

import Foundation
import UIKit

class BeginViewController : UIViewController {
    
    @IBOutlet var beginView: BeginView!
    
    var dataController: DataController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.beginView.initView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.hideNavigationController(animated: animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return getDefaulStatusBarStyle()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newGameSegue" {
            
            if let gameController = segue.destination as? GameViewController {
                
                gameController.dataController = self.dataController
                
            }
            
        } else  if segue.identifier == "historySegue" {
            
            if let gameController = segue.destination as? HistoryTableViewController {
                
                gameController.dataController = self.dataController
                
            }
            
        }
    }
    
}

extension BeginViewController {
    
    @IBAction func newGame(_ sender: Any) {
        
        performSegue(withIdentifier: "newGameSegue", sender: sender)
        
    }
    
    @IBAction func history(_ sender: Any) {
        performSegue(withIdentifier: "historySegue", sender: sender)
    }
    
    
}


