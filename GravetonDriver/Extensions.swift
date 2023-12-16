//
//  Extensions.swift
//  GravetonDriver
//
//  Created by Daniel Zhagany Zamora on 11/28/23.
//

import Foundation
import UIKit

extension UIImageView {
    
    func setImageTintColor(_ color: UIColor) {
        let tintedImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = tintedImage
        self.tintColor = color
    }
}
