//
//  AppDataManager.swift
//  GravetonDriver
//
//  Created by Daniel Zhagany Zamora on 10/19/23.
//

import Foundation
import UIKit
import FirebaseDatabase

class AppDataManager {
    
    static let shared = AppDataManager()
    
    var uid:String?
    
    var RestNameAndID = Policy(title: nil, subTitle: nil, policy: "")
    
    var users : [User] = [] {
        
        didSet{
            NotificationCenter.default.post(name: AppDataManager.orderUpdateNotification, object: nil)
        }
    }
    
    
    static let orderUpdateNotification = Notification.Name("orderUpdated")
    
    func removeUser(_ user:User){
        
        if let index = users.firstIndex(where: { item -> Bool in
            
            return item.fromId == user.fromId
            }){
            
            users.remove(at: index)
        }   
    }
    
    func driverAvailable(_ uid:String?){
        self.uid = uid
        if let uid = uid {
            
            let dict = ["status":"green"]
            Database.database().reference().child(uid).updateChildValues(dict)
        }
    }
    
    func driverNotAvailable(){
        
        if let uid = uid {
            
            let dict = ["status":"red"]
            Database.database().reference().child(uid).updateChildValues(dict)
        }
    }
}
