//
//  BorderedButton.swift
//  StringToHiraganaiOS
//
//  Created by murakami Taichi on 2019/09/12.
//  Copyright © 2019 murakammm. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class BorderedButton: UIButton {
    @IBInspectable var cornerRadius: CGFloat = 0.0
    @IBInspectable var borderColor: UIColor = .black
    @IBInspectable var borderWidth: CGFloat = 0.0
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
    }
    
}
