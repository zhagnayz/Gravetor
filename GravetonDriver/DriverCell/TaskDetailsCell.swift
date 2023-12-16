//
//  TaskDetailsCell.swift
//  GravetonDriver
//
//  Created by Daniel Zhagany Zamora on 2/27/23.
//

import UIKit
import FirebaseDatabase

class TaskDetailsCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = "TaskDetailsCell"
    
    private var userPhoneNum:String?
    
    var taskDetailLabel:  UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .gray
        return label
    }()
    
    var nameLabel:  UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    let emailButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "person.fill")?.withTintColor(.systemGreen, renderingMode: .alwaysOriginal), for: .normal)
        return button
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16,weight: .semibold)
        label.textColor = .gray
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16,weight: .semibold)
        return label
    }()
    
    let taskLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16,weight: .semibold)
        return label
    }()
    
    let restLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16,weight: .semibold)
        return label
    }()
    
    let phonelButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "phone.fill")?.withTintColor(.systemGreen, renderingMode: .alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(didTaTestingButton), for: .touchDown)
        return button
    }()
    
    let phoneLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16,weight: .semibold)
        label.textColor = .gray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let stackViewOne = UIStackView(arrangedSubviews: [taskDetailLabel])
        let stackViewTwo = UIStackView(arrangedSubviews: [emailButton,emailLabel])
        let stackViewThree = UIStackView(arrangedSubviews: [phonelButton,phoneLabel])
        
        let stackViewFour = UIStackView(arrangedSubviews: [stackViewTwo,stackViewThree])
        stackViewFour.distribution = .equalSpacing
        
        let stackViewFive = UIStackView(arrangedSubviews: [dateLabel,taskLabel,restLabel])
        stackViewFive.axis = .vertical
        stackViewFive.spacing = 10
        
        let stackView = UIStackView(arrangedSubviews: [stackViewOne,stackViewFour,stackViewFive])
        stackView.axis = .vertical
        stackView.spacing = 15
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    func configureCell(_ user:User?){
        
        if let seconds = user?.timestamp {
            let timestamp_date = Date(timeIntervalSince1970: seconds)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yy hh:mm a"
            self.dateLabel.text = dateFormatter.string(from: timestamp_date)
        }
        
        if let chatPartnerId = user?.fromId {
            Database.database().reference().child("users").child(chatPartnerId).observeSingleEvent(of: .value) { snapshot,error  in
                if let dictionary = snapshot.value as? [String : Any] {
                    
                    var person = PersonInfo()
                    
                    person.fullName = dictionary["name"] as? String
                    person.phone = dictionary["phone"] as? String
                    self.userPhoneNum = person.phone
                    
                    self.emailLabel.text = person.getNameInitials()
                    self.phoneLabel.text = person.phone
                }
            }
        }
    }
    
    @objc func didTaTestingButton(){
        
        if let userPhoneNum = userPhoneNum {
         
            if let url = URL(string: "tel://\(userPhoneNum)"),UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
