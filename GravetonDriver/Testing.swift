//
//  Testing.swift
//  GravetonDriver
//
//  Created by Daniel Zhagany Zamora on 6/5/23.
//

import Foundation
import UIKit

struct Testing: Hashable {
    
    let title: String
    let date: String
    let pickUpOrDrop: String
    let image: UIImage
    
    init(title: String, date: String?, pickUpOrDrop: String, image: UIImage) {
        
        self.title = title
        
        if let orderDate = date {
            
            self.date = orderDate
        }else{
            
            let dateFormatter = DateFormatter()
            
            dateFormatter.locale = Locale(identifier: "en_US")
            dateFormatter.setLocalizedDateFormatFromTemplate("MM-dd-yyyy HH:mm")
            
            self.date = dateFormatter.string(from: Date())
        }
        
        self.pickUpOrDrop = pickUpOrDrop
        self.image = image
    }
    
}
