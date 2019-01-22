//
//  TetrisPlusPlusDelegate.swift
//  TetrisPlusPlus
//
//  Created by Diego Neves on 20/01/19.
//  Copyright © 2019 dj. All rights reserved.
//

import Foundation

protocol TetrisPlusPlusDelegate {
    
    func gameDidEnd(tetris: TetrisPlusPlus)
    
    func gameDidBegin(tetris: TetrisPlusPlus)
    
    func gameShapeDidLand(tetris: TetrisPlusPlus)
    
    func gameShapeDidMove(tetris: TetrisPlusPlus)
    
    func gameShapeDidDrop(tetris: TetrisPlusPlus)
    
    func gameDidLevelUp(tetris: TetrisPlusPlus)
    
}
