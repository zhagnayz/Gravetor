//
//  ButtonCell.swift
//  GravetonDriver
//
//  Created by Daniel Zhagany Zamora on 2/26/23.
//

import UIKit

class ButtonCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = "ButtonCell"
    
    var name:  UILabel = {
        let label = UILabel()
        return label
    }()
    
    let subName: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let imageIcon: UIImageView = {
        let image = UIImageView()
        image.setImageTintColor(.gray)
        return image
    }()
    
    override init(frame:CGRect){
        super.init(frame: frame)
        
        let stackViewOne = UIStackView(arrangedSubviews: [imageIcon,name,subName])
        stackViewOne.alignment = .center
        stackViewOne.spacing = 10
        
        let stackView = UIStackView(arrangedSubviews: [stackViewOne])
        stackView.axis = .vertical
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 5),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    
    func configureCell(_ iconMenu: IconMenu?){
        
        imageIcon.image = UIImage(systemName: iconMenu?.icon ?? "")
        name.text = iconMenu?.title
        subName.text = iconMenu?.subTitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
