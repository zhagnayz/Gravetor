//
//  PickOrDeliveryButton.swift
//  GravetonDriver
//
//  Created by Daniel Zhagany Zamora on 10/18/23.
//

import UIKit

class PickOrDeliveryButton: UIButton {

    let addressLabel: UILabel = {
        let addressLabel = UILabel()
        addressLabel.font = UIFont.systemFont(ofSize: 16)
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        return addressLabel
    }()

    let clockImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "clock")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let BoxLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.textAlignment = .center
       dateLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        return dateLabel
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = .tertiarySystemGroupedBackground
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 0.8
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 6

            self.enterLabel()
    }

    func enterLabel(){

        addSubview(addressLabel)
        addSubview(clockImage)
        addSubview(BoxLabel)
        addSubview(dateLabel)

        NSLayoutConstraint.activate([
            addressLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            clockImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            clockImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            BoxLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
