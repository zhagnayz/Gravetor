//
//  ReceiptToCell.swift
//  GravetonDriver
//
//  Created by Daniel Zhagany Zamora on 2/27/23.
//

import UIKit

class ReceiptTopCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = "ReceiptTopCell"
    
    let orderDetailStrLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18,weight: .semibold)
        label.textColor = .systemRed
        return label
    }()
    
    let statuStrLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16,weight: .semibold)
        return label
    }()
    
    let statuLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16,weight: .semibold)
        return label
    }()
    
    let dateStrLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    let orderNumStrLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    let orderNumLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    let totalItemStrLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    let totalItemLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    let restNameStrLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18,weight: .semibold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 4
        contentView.backgroundColor = .tertiarySystemGroupedBackground
        
        let stackViewOne = UIStackView(arrangedSubviews: [statuStrLabel,statuLabel])
        stackViewOne.distribution = .equalSpacing
        
        let stackViewTwo = UIStackView(arrangedSubviews: [dateStrLabel,dateLabel])
        stackViewTwo.distribution = .equalSpacing
        
        let stackViewThree = UIStackView(arrangedSubviews: [orderNumStrLabel,orderNumLabel])
        stackViewThree.distribution = .equalSpacing
        
        let stackViewFour = UIStackView(arrangedSubviews: [totalItemStrLabel,totalItemLabel])
        stackViewFour.distribution = .equalSpacing
        
        let stackViewFive = UIStackView(arrangedSubviews: [stackViewOne,stackViewTwo,stackViewThree,stackViewFour])
        stackViewFive.axis = .vertical
        stackViewFive.spacing = 5
        
        let stackView = UIStackView(arrangedSubviews: [orderDetailStrLabel,stackViewFive,restNameStrLabel])
        stackView.axis = .vertical
        stackView.spacing = 15
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 5),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -5),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    func configureReceipt(_ user: User?,indexPath:IndexPath){
        
        guard let user = user else {return}
        
        orderDetailStrLabel.text = "Order Details"
        statuStrLabel.text = "Status"
        statuLabel.text = "Placed"
        dateStrLabel.text = "Date"
        orderNumStrLabel.text = "Order Num"
        totalItemStrLabel.text = "item(s)"
        
        dateLabel.text = user.driverInfo?.date
        orderNumLabel.text = user.orderNum
        totalItemLabel.text = "\(user.order.orderItem.count)"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

