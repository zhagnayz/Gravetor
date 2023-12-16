//
//  Extension.swift
//  GravetonDriver
//
//  Created by Daniel Zhagany Zamora on 10/24/23.
//

import Foundation
import UIKit

class GetRootView {
    
    static let shared = GetRootView()
    
    func getRootView() -> UIView {
        
        let firstScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        
        let firstWindow = firstScene?.windows.first
        
        guard let superView = firstWindow?.rootViewController?.view else {return UIView()}
        
        return superView
    }
}

extension UILabel {
    
    func setDifferentColor(string: String, location: Int, length: Int){
        
        let attText = NSMutableAttributedString(string: string)
        attText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: NSRange(location:location,length:length))
        attributedText = attText
    }
}
