//
//  Notification.swift
//  GravetonDriver
//
//  Created by Daniel Zhagany Zamora on 10/24/23.
//

import Foundation

struct NotificationData{
    let orderId:String
    let name:String
    let restAddress:String
    let userAddress:String
    let distance:Double
    let money:Double
    
    var formattedMoney: String {
        return String(format: "$%.2f", money)
    }
    
    var formattedDistance: String {
        return String(format: "%.2f mi.", distance)
    }

    
    init(orderId: String, name: String, restAddress: String, userAddress: String, distance: Double, money: Double) {
        self.orderId = orderId
        self.name = name
        self.restAddress = restAddress
        self.userAddress = userAddress
        self.distance = distance
        self.money = money
    }
    
    init?(dictionary source:[String:Any]){
     
        guard let name = source["name"] as? String, let userAddress = source["userAddress"] as? String, let orderId = source["orderId"] as? String, let money = source["money"] as? Double, let restAddress = source["restAddress"] as? String, let distance = source["distance"] as? Double else {return nil}
        
        self.init(orderId: orderId, name: name, restAddress: restAddress, userAddress: userAddress, distance: distance, money: money)
    }
}
