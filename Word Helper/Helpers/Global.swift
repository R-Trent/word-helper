//
//  Global.swift
//  WordleHelper
//
//  Created by Ryan Trent on 7/20/22.
//

import UIKit

enum Global {
    
    static var minDimension: CGFloat {
        min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
    }
    
    static var keyboardScale: CGFloat {
        switch minDimension {
        case 0...430:
            return UIScreen.main.bounds.width / 390
        case 431...1000:
            return CGFloat(1.2)
        default:
            return CGFloat(1.6)
        }
    }
    
}
