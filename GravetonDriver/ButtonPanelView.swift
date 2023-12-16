//
//  ButtonPanelView.swift
//  GravetonDriver
//
//  Created by Daniel Zhagany Zamora on 10/18/23.
//

import UIKit

class ButtonPanelView: UIView {
    
    private var isSelected: Bool = false

    lazy var minuButton: PickOrDeliveryButton = {
        let button = PickOrDeliveryButton(frame: .zero)
        button.BoxLabel.text = "PickUp"
        button.BoxLabel.textColor = .systemOrange
        button.tag = 0
        button.addTarget(self, action: #selector(didTapPanelButtons(_:)), for: .touchUpInside)
        return button
    }()

    lazy var plusButton: PickOrDeliveryButton = {
        let button = PickOrDeliveryButton(frame: .zero)
        button.BoxLabel.textColor = .systemRed
        button.BoxLabel.text = "Drop"
        button.isEnabled = false
        button.tag = 1
        button.addTarget(
            self, action: #selector(didTapPanelButtons(_:)), for: .touchUpInside)
        return button
    }()

    enum QuantityViewItems : Int{
        case minus
        case plus
    }

    var completion: ((QuantityViewItems)->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraints() {
                
        let stackView =  UIStackView(arrangedSubviews: [minuButton,plusButton])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        
        stackView.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.topAnchor.constraint(equalTo:self.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    @objc private func didTapPanelButtons(_ sender: UIButton) {

        if let selectedButton = QuantityViewItems(rawValue: sender.tag){
            switch selectedButton {
                
            case .minus: 
                minuButton.isHidden = true
                plusButton.isEnabled = true
            case .plus:
                minuButton.isHidden = false
                    isSelected = false
            }
            completion?(selectedButton)
        }
    }
}
