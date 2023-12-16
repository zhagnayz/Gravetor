//
//  PriceDetailsCell.swift
//  GravetonDriver
//
//  Created by Daniel Zhagany Zamora on 2/27/23.
//

import UIKit

class PriceDetailsCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = "PriceDetailsCell"
    
    let priceDetailsLabelStr: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16,weight: .semibold)
        return label
    }()
    
    let subTotalLabelStr: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16,weight: .semibold)
        return label
    }()
    
    let subTotalLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16,weight: .semibold)
        return label
    }()
    
    
    let taxLabelStr: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    let taxLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let deliveryChargeLabelStr: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    let deliveryChargeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let tipLabelStr: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    let tipLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let grandTotalLabelStr: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16,weight: .semibold)
        return label
    }()
    
    let grandTotalLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16,weight: .semibold)
        return label
    }()
    
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .quaternaryLabel
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        let stackViewOne = UIStackView(arrangedSubviews: [priceDetailsLabelStr])
        
        let stackViewTwo = UIStackView(arrangedSubviews: [subTotalLabelStr,subTotalLabel])
        stackViewTwo.distribution = .equalSpacing
        
        let stackViewThree = UIStackView(arrangedSubviews: [deliveryChargeLabelStr,deliveryChargeLabel])
        stackViewThree.distribution = .equalSpacing
        
        let stackViewFour = UIStackView(arrangedSubviews: [tipLabelStr,tipLabel])
        stackViewFour.distribution = .equalSpacing
        
        let stackViewFive = UIStackView(arrangedSubviews: [taxLabelStr,taxLabel])
        stackViewFive.distribution = .equalSpacing
        
        let stackViewSix = UIStackView(arrangedSubviews: [grandTotalLabelStr,grandTotalLabel])
        stackViewSix.distribution = .equalSpacing
        
        let stackViewSeven = UIStackView(arrangedSubviews: [stackViewTwo,stackViewThree,stackViewFour,stackViewFive,stackViewSix])
        stackViewSeven.axis = .vertical
        stackViewSeven.spacing = 10
        
        let stackViewEight = UIStackView(arrangedSubviews: [stackViewOne,stackViewSeven])
        stackViewEight.axis = .vertical
        stackViewEight.spacing = 15
        
        let stackView = UIStackView(arrangedSubviews: [stackViewEight,lineView])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 5),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -5),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 1),
        ])
    }
    
    func configurePricceDetail(_ order: Order?){
        
        guard let order = order else {return}
        
        priceDetailsLabelStr.text = "Price Details"
        subTotalLabelStr.text = "SubTotal"
        deliveryChargeLabelStr.text = "Delivery Charge"
        tipLabelStr.text = "Tip Amount"
        taxLabelStr.text = "Tax"
        grandTotalLabelStr.text = "GrandTotal"
        
        subTotalLabel.text = order.formattedSubTotal
        taxLabel.text = order.formattedTax
        grandTotalLabel.text = order.formattedGrandTotal
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
