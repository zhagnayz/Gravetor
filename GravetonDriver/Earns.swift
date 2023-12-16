//
//  Earns.swift
//  GravetonDriver
//
//  Created by Daniel Zhagany Zamora on 8/5/23.
//

import Foundation

struct Earn:Hashable {
    
    var timestamp:NSNumber?
    var total:Double?
    
    var formattedSubtotalEar: String {
        return String(format: "$%.2f", total ?? 0.0)
    }
    
    init(timestamp:NSNumber,total:Double){
        
        self.timestamp = timestamp
        self.total = total
    }
    
    var leftDate:String?{
        
        if let seconds = timestamp?.doubleValue {
            let timestamp_date = Date(timeIntervalSince1970: seconds)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "E, d MMM yyyy HH:mm"
            let format = dateFormatter.string(from: timestamp_date)
            return format
        }
        return ""
    }
    
    
    init?(dictionary source:[String: Any]) {
        
        guard let timestamp = source["timestamp"] as? NSNumber, let total = source["total"] as? Double else {return nil}
        
        self.init(timestamp: timestamp, total: total)
    }
}

struct TotalEarn:Hashable{
    
    var earns = [Earn]()
    
    var totalEarn:Double?{
        
        var total: Double = 0.0
        
        for earn in earns {
            
            total += earn.total ?? 0.0
        }
        return total
    }
    
    var formattedtotalEar: String {
        return String(format: "$%.2f", totalEarn ?? 0.0)
    }
    
    var dateThough: String? {
        
        let timestamps = [earns.first?.timestamp,earns.last?.timestamp]
        
        var dateformat:String = ""
        var isTrue:Bool = true
        
        for time in timestamps {
            
            if let seconds = time?.doubleValue {
                let timestamp_date = Date(timeIntervalSince1970: seconds)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM d"
                let format = dateFormatter.string(from: timestamp_date)
                dateformat += format
            }
            
            if isTrue {
                
                dateformat += " - "
            }
            isTrue = false
        }
        
        return dateformat
    }
}
