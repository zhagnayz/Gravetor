//
//  ProfilePersonInfoCell.swift
//  GravetonDriver
//
//  Created by Daniel Zhagany Zamora on 4/3/23.
//

import UIKit

class ProfilePersonInfoCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = "AccountHeaderCell"
    
    let subHeaderLabel: UILabel = {
        let headerLabel = UILabel()
        headerLabel.font = UIFont.systemFont(ofSize: 14)
        headerLabel.numberOfLines = 0
        headerLabel.textColor = .red
        return headerLabel
    }()
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.layer.masksToBounds = true
        image.layer.borderWidth = 0.3
        image.layer.borderColor = UIColor.lightGray.cgColor
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 50
        return image
    }()
    
    let cameraButton: UIButton = {
        let button = UIButton()
        button.setTitle("Edit", for: .normal)
        button.setTitleColor(.label, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        let stackView = UIStackView(arrangedSubviews: [subHeaderLabel,imageView,cameraButton])
        stackView.spacing = 10
        stackView.axis = .vertical
        stackView.alignment = .center
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 100),
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
