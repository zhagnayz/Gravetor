//
//  AccountCell.swift
//  GravetonDriver
//
//  Created by Daniel Zhagany Zamora on 2/26/23.
//

import UIKit

class AccountCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = "AccountCell"
    
    let imageIcon: UIImageView = {
        let label = UIImageView()
        label.setImageTintColor(.gray)
        return label
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let stackView = UIStackView(arrangedSubviews: [imageIcon,nameLabel])
        stackView.spacing = 30
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 3),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    func configureCell(iconMenu: [IconMenu], indexPath: IndexPath){
        
        imageIcon.image = UIImage(systemName: iconMenu[indexPath.item].icon ?? "")
        nameLabel.text = iconMenu[indexPath.item].title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
