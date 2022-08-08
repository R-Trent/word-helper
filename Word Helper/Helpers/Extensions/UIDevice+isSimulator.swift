//
//  UIDevice+isSimulator.swift
//  WordleHelper
//
//  Created by Ryan Trent on 7/23/22.
//

import SwiftUI

extension UIDevice {
    var isSimulator: Bool {
        #if targetEnvironment(simulator)
            return true
        #else
            return false
        #endif
    }
}
