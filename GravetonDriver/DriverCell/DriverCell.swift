//
//  DriverCell.swift
//  GravetonDriver
//
//  Created by Daniel Zhagany Zamora on 2/26/23.
//

import UIKit

class DriverCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = "DriverCell"
    
    var LogoView: TestingSpinnerView!
    
    let logoLabel: UILabel = {

        let logoLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 150))
        logoLabel.font = UIFont.systemFont(ofSize: 40, weight: .semibold)
        logoLabel.text = "Graveton"
        logoLabel.textAlignment = .center
        return logoLabel
    }()
    
    let titleLabel: UILabel = {
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        titleLabel.numberOfLines = 0
        
        return titleLabel
    }()
    
    let SubTitleLabel: UILabel = {
        
        let SubTitleLabel = UILabel()
        SubTitleLabel.numberOfLines = 0
        SubTitleLabel.textColor = .gray
        return SubTitleLabel
    }()
    
    let textField: UITextField = {
        
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 18)
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    let horizontalSeparator = UIView(frame: .zero)
    let verticalSeparator = UIView(frame: .zero)
    
    let countryCodeLabel: UILabel = {
        let countryCodeLabel = UILabel()
        countryCodeLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return countryCodeLabel
    }()
    
    let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.red, for: .normal)
        return button
    }()
    
    
    override init(frame:CGRect){
        super.init(frame: frame)
        
        LogoView = TestingSpinnerView(frame: CGRect(x: contentView.frame.size.width/5, y: 5, width: 250, height: 100))
        
        horizontalSeparator.backgroundColor = .quaternaryLabel
        verticalSeparator.backgroundColor = .quaternaryLabel
        
        LogoView.addSubview(logoLabel)
        
        contentView.addSubview(LogoView)
        
        let stackViewOne = UIStackView(arrangedSubviews: [countryCodeLabel,verticalSeparator,textField])
        stackViewOne.distribution = .fillProportionally
        stackViewOne.spacing = 6
        
        let stackViewTwo = UIStackView(arrangedSubviews: [stackViewOne,horizontalSeparator])
        stackViewTwo.axis = .vertical
        stackViewTwo.spacing = 5
        
        let stackViewThree = UIStackView(arrangedSubviews: [SubTitleLabel,registerButton])
        stackViewThree.axis = .vertical
        stackViewThree.alignment = .leading
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel,stackViewThree,stackViewTwo])
        stackView.axis = .vertical
        stackView.spacing = 30
        
       // LogoView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
        
            verticalSeparator.widthAnchor.constraint(equalToConstant: 3),
            horizontalSeparator.heightAnchor.constraint(equalToConstant: 1),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
        ])
        
        stackView.setCustomSpacing(40, after: LogoView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
