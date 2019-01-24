//
//  ViewControllerExtensions.swift
//  ios-tetrisPlusPlus
//
//  Created by Diego Neves on 24/01/19.
//  Copyright © 2019 dj. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    
    func getDefaulStatusBarStyle() -> UIStatusBarStyle {
        return .lightContent
    }
    
    func hideNavigationController(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func showNavigationController(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
}
