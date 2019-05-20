//
//  CustomLabel.swift
//  Nano Challenge
//
//  Created by Evan Christian on 19/05/19.
//  Copyright © 2019 Evan Christian. All rights reserved.
//

import Foundation
@IBDesignable
class CustomUILabel: UILabel {
    
    @IBInspectable var label_Rotation: Double = 0 {
        didSet {
            rotateLabel(labelRotation: label_Rotation)
            self.layoutIfNeeded()
        }
    }
    
    func rotateLabel(labelRotation: Double)  {
        self.transform = CGAffineTransform(rotationAngle: CGFloat((Double.pi * 2) + labelRotation))
    }
}
