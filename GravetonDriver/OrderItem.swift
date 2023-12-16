//
//  OrderItem.swift
//  GravetonDriver
//
//  Created by Daniel Zhagany Zamora on 2/27/23.
//

import Foundation

struct OrderItem:Codable, Hashable {
    
    var name:String?
    var protein:[String]?
    var spiceLevel:String?
    var addItems:[String]?
    var quantity: Int?
    var price:Double?
    
    var formattedSubTotal: String {
        return String(format: "$%.2f", price ?? 0.0)
    }
    
    var formattedQuantity: String {
        
        return String(format: "x %d", quantity ?? 0)
    }
}
