//
//  HeaderInfoView.swift
//  GravetonDriver
//
//  Created by Daniel Zhagany Zamora on 7/8/23.
//

import UIKit

class HeaderInfoView: UICollectionReusableView {
       
    static let reuseIdentifier:String = "HeaderInfoView"
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 30
        return image
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16,weight: .semibold)
        return label
    }()
    
    let detailsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let phoneButton:UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "phone.fill"), for: .normal)
        return button
    }()
    
    let messageButton:UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "message.fill"), for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let stackViewOne = UIStackView(arrangedSubviews: [titleLabel,detailsLabel])
        stackViewOne.axis = .vertical
        stackViewOne.alignment = .leading
        
        let stackViewTwo = UIStackView(arrangedSubviews: [phoneButton,messageButton])
        stackViewTwo.spacing = 15
        
        let stackViewThree = UIStackView(arrangedSubviews: [imageView,stackViewOne])
        stackViewThree.spacing = 10
        stackViewThree.alignment = .center
        
        let stackView = UIStackView(arrangedSubviews: [stackViewThree,stackViewTwo])
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -10),
            imageView.heightAnchor.constraint(equalToConstant: 60),
            imageView.widthAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
