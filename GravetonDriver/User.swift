//
//  User.swift
//  GravetonDriver
//
//  Created by Daniel Zhagany Zamora on 3/28/23.
//

import Foundation


struct User:Codable, Hashable{
    var orderId:String?
    var toId:String?
    var fromId:String?
    var orderStatus:String?
    var orderNum:String?
    var timestamp:Double?
    
    var driverInfo: DriverInfo?
    var personInfo = PersonInfo()
    var order = Order()
}



