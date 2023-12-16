//
//  SideMenuCell.swift
//  GravetonDriver
//
//  Created by Daniel Zhagany Zamora on 2/26/23.
//

import UIKit

class SideMenuCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = "SideMenuCell"
    
    let imageLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 50)
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    let subTitle: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.numberOfLines = 0
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
    
                
        let stackView = UIStackView(arrangedSubviews: [imageLabel,titleLabel,subTitle])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    func configure(_ iconMenu: [IconMenu],indexPath: IndexPath){
        
        titleLabel.text = iconMenu[indexPath.item].title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

