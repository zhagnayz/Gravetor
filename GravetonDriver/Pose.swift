//
//  Pose.swift
//  GravetonDriver
//
//  Created by Daniel Zhagany Zamora on 2/26/23.
//

import Foundation


struct Pose {
    
    let secondsSincePriorPose: CFTimeInterval
    let start: CGFloat
    let length: CGFloat
    
    init(_ secondsSincePriorPose: CFTimeInterval, _ start: CGFloat, _ length: CGFloat) {
        
        self.secondsSincePriorPose = secondsSincePriorPose
        self.start = start
        self.length = length
    }
}
