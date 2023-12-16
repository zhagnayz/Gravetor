//
//  PersonInfo.swift
//  GravetonDriver
//
//  Created by Daniel Zhagany Zamora on 3/28/23.
//

import Foundation

struct PersonInfo:Codable, Hashable {
    
    var id:String?
    var firstName: String?
    var lastName: String?
    var email: String?
    var phone: String?
    var password: String?
    var fullName:String?
    var midName:String?
    
    func getFullName() -> String {
        
        if let fullName = fullName {
            return fullName
        }else{
            let fullName: String = (firstName ?? "") + " " + (lastName ?? "")
            return fullName
        }
    }
    
    func getNameInitials() -> String {
        
        var names:[String] = []
    
        return getFullName().components(separatedBy: " ").reduce("") {
            
            names.append($1)

            let firstLetter = names[0].prefix(1).capitalized
            
            let remainingLetters = names[0].dropFirst().lowercased()
            
            let firstNameCapit = firstLetter + remainingLetters

            return ($0.isEmpty ? "" : "\(firstNameCapit)") + " " +
            ($1.isEmpty ? "" : "\(($1.first?.uppercased() ?? "") + ".")")
        }
    }
}
