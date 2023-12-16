//
//  TaskHistoryCell.swift
//  GravetonDriver
//
//  Created by Daniel Zhagany Zamora on 2/26/23.
//

import UIKit

class TaskHistoryCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = "TaskHistoryCell"
    
    let checkButton: UIButton = {
        let button = UIButton()
        button.setTitle("check", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.isHidden = true
        return button
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        return label
    }()
    
    let totalLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .systemOrange
        return label
    }()
    
    let lineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .quaternaryLabel
        return view
    }()
    
    override init(frame:CGRect){
        super.init(frame: frame)
        
        let stackViewTwo = UIStackView(arrangedSubviews: [titleLabel,totalLabel,checkButton])
        stackViewTwo.distribution = .equalSpacing
        
        stackViewTwo.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        stackViewTwo.isLayoutMarginsRelativeArrangement = true
        
        let stackView = UIStackView(arrangedSubviews: [lineView,stackViewTwo])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            lineView.heightAnchor.constraint(equalToConstant: 1),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    func configureCell(_ totalEarn:Earn){
        
        titleLabel.text = totalEarn.leftDate
        totalLabel.text = "\(totalEarn.formattedSubtotalEar)"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
