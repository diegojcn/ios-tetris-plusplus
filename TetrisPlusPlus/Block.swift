//
//  File.swift
//  TetrisPlusPlus
//
//  Created by Diego Neves on 26/08/18.
//  Copyright © 2018 dj. All rights reserved.
//

import SpriteKit

let NumberOfColors: UInt32 = 6

enum BlockColor: Int, CustomStringConvertible {
    
    case Blue = 0, Orange = 1, Purple = 2, Red = 3, Teal = 4, Yellow = 5
    

    var spriteName: String {
        switch self {
        case .Blue:
            return "blue"
        case .Orange:
            return "orange"
        case .Purple:
            return "purple"
        case .Red:
            return "red"
        case .Teal:
            return "teal"
        case .Yellow:
            return "yellow"
        }
    }
    
    var description: String {
        return self.spriteName
    }
    
    static func random() -> BlockColor {
        return BlockColor(rawValue:Int(arc4random_uniform(NumberOfColors)))!
    }
}

class Block: Hashable, CustomStringConvertible  {
    // #8
    // Constants
    let color: BlockColor
    
    // #9
    // Properties
    var column: Int
    var row: Int
    var sprite: SKSpriteNode?
    
    // #10
    var spriteName: String {
        return color.spriteName
    }
    
    // #11
    var hashValue: Int {
        return self.column ^ self.row
    }
    
    // #12
    var description: String {
        return "\(color): [\(column), \(row)]"
    }
    
    init(column:Int, row:Int, color:BlockColor) {
        self.column = column
        self.row = row
        self.color = color
    }
}

// #13
func ==(lhs: Block, rhs: Block) -> Bool {
    return lhs.column == rhs.column && lhs.row == rhs.row && lhs.color.rawValue == rhs.color.rawValue
}
