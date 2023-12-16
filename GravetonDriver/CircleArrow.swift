//
//  CircleArrow.swift
//  GravetonDriver
//
//  Created by Daniel Zhagany Zamora on 3/27/23.
//

import UIKit

class CircleArrow: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    func setupView(){
        
        let path: UIBezierPath = getPath()
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        shape.lineWidth = 2
        shape.strokeColor = UIColor.red.cgColor
        shape.fillColor = UIColor.clear.cgColor
        
        self.layer.addSublayer(shape)
    }
    
    func getPath() -> UIBezierPath {
        
        let path: UIBezierPath = UIBezierPath()
        
        path.move(to: CGPoint(x: 24, y: 0))
        path.addArc(withCenter: CGPoint(x: 24, y: 20), radius: 20, startAngle: CGFloat(Double.pi*3/2), endAngle: CGFloat(Double.pi/2), clockwise: false)
        path.move(to: CGPoint(x: 25, y: 35))
        path.addLine(to: CGPoint(x: 30, y: 40))
        path.addLine(to: CGPoint(x: 25, y: 45))
        
        return path
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

