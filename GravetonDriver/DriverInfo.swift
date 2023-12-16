//
//  DriverInfo.swift
//  GravetonDriver
//
//  Created by Daniel Zhagany Zamora on 10/17/23.
//

import Foundation

struct DriverInfo:Codable,Hashable {
    
    var PickUpaddress: String?
    var Deliveryaddress: String?
    var pickUpOrDrop: String?
    var restName:String?
    
    var date: String?{
        
        let dateFormatter = DateFormatter()

        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.setLocalizedDateFormatFromTemplate("MM-dd-yyyy HH:mm")
         return dateFormatter.string(from: Date())
    }
}
