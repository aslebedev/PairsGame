//
//  Extensions.swift
//  PairsGame
//
//  Created by alexander on 05.03.2020.
//  Copyright © 2020 alexander. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    struct Holder {
        static var _imageName: String = ""
    }
    
    var imageName: String {
        get {
            return Holder._imageName
        }
        set(newValue) {
            Holder._imageName = newValue
            //self.setImage(UIImage(named: newValue), for: .normal)
        }
    }
}
