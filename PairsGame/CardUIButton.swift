//
//  CardUIButton.swift
//  PairsGame
//
//  Created by alexander on 06.03.2020.
//  Copyright © 2020 alexander. All rights reserved.
//

import Foundation
import UIKit

class CardUIButton: UIButton {
    var imageName = String() {
        didSet {
            self.setImage(UIImage(named: imageName), for: .normal)
        }
    }
}
