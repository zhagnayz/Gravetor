//
//  DropCell.swift
//  GravetonDriver
//
//  Created by Daniel Zhagany Zamora on 2/26/23.
//

import UIKit

class DropCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = "DropCell"

    var buttonPanelView = ButtonPanelView()

    override init(frame:CGRect){
        super.init(frame: frame)
        
        contentView.backgroundColor = .quaternarySystemFill
        let stackView = UIStackView(arrangedSubviews: [buttonPanelView])

        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 4),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 5),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -4),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -5),
        ])
    }
    
    
    func configureCell(_ driverInfo: DriverInfo?){
                
        buttonPanelView.minuButton.addressLabel.text = driverInfo?.PickUpaddress
        buttonPanelView.plusButton.addressLabel.text = driverInfo?.Deliveryaddress
        buttonPanelView.minuButton.dateLabel.text = driverInfo?.date
        buttonPanelView.plusButton.dateLabel.text = driverInfo?.date
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
