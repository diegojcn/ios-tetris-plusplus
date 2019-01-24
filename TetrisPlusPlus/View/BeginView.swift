//
//  BeginView.swift
//  ios-tetrisPlusPlus
//
//  Created by Diego Neves on 21/01/19.
//  Copyright © 2019 dj. All rights reserved.
//

import Foundation
import UIKit

class BeginView : UIView {
    
    @IBOutlet weak var newGameBtn: UIButton!
    
    @IBOutlet weak var historyBtn: UIButton!
    
    @IBOutlet weak var titleView: UIView!
    
    func initView(){
        
        self.newGameBtn.frame = CGRect(x: 160, y: 100, width: 50, height: 50)
        self.newGameBtn.layer.cornerRadius = 0.5 * self.newGameBtn.bounds.size.width
        self.newGameBtn.clipsToBounds = true
        
        self.historyBtn.frame = CGRect(x: 160, y: 100, width: 50, height: 50)
        self.historyBtn.layer.cornerRadius = 0.5 * self.historyBtn.bounds.size.width
        self.historyBtn.clipsToBounds = true
        
    }
    
}
