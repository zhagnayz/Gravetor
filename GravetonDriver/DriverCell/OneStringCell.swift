//
//  OneStringCell.swift
//  GravetonDriver
//
//  Created by Daniel Zhagany Zamora on 9/28/23.
//

import UIKit

class OneStringCell: UICollectionViewCell {
    
    static let reuseIdentifier:String = "OneStringCell"
    
    var titleLabel:  UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
  
    override init(frame:CGRect){
        super.init(frame: frame)
        

        let stackView = UIStackView(arrangedSubviews: [titleLabel])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
