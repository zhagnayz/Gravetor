//
//  Order.swift
//  GravetonDriver
//
//  Created by Daniel Zhagany Zamora on 2/27/23.
//

import Foundation

struct Order:Codable, Hashable{
    
    var orderItem = [OrderItem]()
    
    var subTotal:Double = 0.0
    
    var tax: Double{
        
        return ((subTotal*0.0875))
    }
    
    mutating func getSubTotal(){
        
        for item in orderItem {
            
            subTotal += item.price ?? 0.0
        }
    }
    
    var formattedSubTotal: String {
        return String(format: "$%.2f", subTotal)
    }
    
    var formattedTax: String {
        return String(format: "$%.2f", tax)
    }
    
    var grandTotal: Double {
        return subTotal + tax
    }
    
    var formattedGrandTotal: String {
        return String(format: "$%.2f", grandTotal)
    }
}
