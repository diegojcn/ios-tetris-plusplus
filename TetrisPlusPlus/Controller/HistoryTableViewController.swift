//
//  HistoryTableViewController.swift
//  ios-tetrisPlusPlus
//
//  Created by Diego Neves on 24/01/19.
//  Copyright © 2019 dj. All rights reserved.
//

import Foundation
import UIKit

class HistoryTableViewController : UITableViewController {
    
    var dataController : DataController!
    
    var scores : [Score]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scores = dataController.findAllScores()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return getDefaulStatusBarStyle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.showNavigationController(animated: animated)
        self.navigationItem.title = "Games History"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "scoreCell", for: indexPath) as! ScoreTableViewCell
        
        let score : Score = scores[indexPath.row]
        
        cell.levelPointLbl.text = score.level.description
        cell.scorePointsLbl.text = score.score.description
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let count = scores?.count else {
            return 0
        }
        
        return count
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteButton = UITableViewRowAction(style: .default, title: "Exluir") { (_, indexPath) in
            
            let scoteToDelete = self.scores[indexPath.row]
            self.scores.remove(at: indexPath.row)
            self.dataController.delete(obj: scoteToDelete)
            self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            
        }
        deleteButton.backgroundColor = .red
        return [deleteButton]
    }
}
