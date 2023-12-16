//
//  HeaderReusableView.swift
//  GravetonDriver
//
//  Created by Daniel Zhagany Zamora on 2/26/23.
//

import UIKit

class HeaderReusableView: UICollectionReusableView {
    
    static let reuseIdentifier: String = "HeaderReusableView"
    
    let headerLabel: UILabel = {
        let headerLabel = UILabel()
        headerLabel.font = UIFont.systemFont(ofSize: 16)
        headerLabel.numberOfLines = 0
        return headerLabel
    }()
    
    let subHeaderLabel: UILabel = {
        let headerLabel = UILabel()
        headerLabel.font = UIFont.systemFont(ofSize: 14)
        headerLabel.numberOfLines = 0
        headerLabel.textColor = .gray
        return headerLabel
    }()
    
    override init(frame:CGRect){
        super.init(frame: frame)
                
        let stackView = UIStackView(arrangedSubviews: [headerLabel,subHeaderLabel])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
