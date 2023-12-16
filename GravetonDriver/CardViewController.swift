//
//  CardViewController.swift
//  GravetonDriver
//
//  Created by Daniel Zhagany Zamora on 2/26/23.
//

import UIKit
import Firebase

struct Admin:Hashable{
    
    var restId:String?
    var childId:String?
    var timestamp:String?
    var name:String?
}

class CardViewController: UIViewController{
    
    var indexPath:IndexPath?
    var admins = [Admin]()
    var ordersDictionary = [String : Admin]()
    
    enum Sections: Int {
        case sectionOne
    }
    
    var collectionView: UICollectionView!
    
    var dataSource: UICollectionViewDiffableDataSource<Sections,AnyHashable>?
    
    private lazy var SendButton: UIButton = {
        let button = UIButton()
        button.setTitle("Send Order", for: .normal)
        button.layer.masksToBounds = true
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(didTapSendOrderButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var refreshButton: UIButton = {
        let button = UIButton()
        button.setTitle("refresh", for: .normal)
        button.addTarget(self, action: #selector(didTapRefreshButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var DeleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Delete", for: .normal)
        button.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward")?.withTintColor(.label, renderingMode: .alwaysOriginal), style: .done, target: self, action: #selector(didTapMainButton))
                    observeUserMessages()
        
        collectionView = UICollectionView(frame: view.bounds,collectionViewLayout: createCompositionalLayout())
        
        collectionView.register(TaskHistoryCell.self, forCellWithReuseIdentifier: TaskHistoryCell.reuseIdentifier)
        
        collectionView.backgroundColor = .tertiarySystemGroupedBackground
        collectionView.delegate = self
        
        view.addSubview(collectionView)
        
        let stackView = UIStackView(arrangedSubviews: [DeleteButton,refreshButton,SendButton])
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .red
        
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -10),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        stackView.layer.cornerRadius = 25
        
        createDataSource()
        reloadData()
    }
    
    func createDataSource(){
        
        dataSource = UICollectionViewDiffableDataSource<Sections,AnyHashable>(collectionView:collectionView){collectionView,indexPath, item in
            
            switch indexPath.section{
                
            case Sections.sectionOne.rawValue:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TaskHistoryCell.reuseIdentifier, for: indexPath) as? TaskHistoryCell else {fatalError()}
                
                let message = self.admins[indexPath.item]
                cell.checkButton.isHidden = false
                cell.checkButton.tag = indexPath.item
                cell.checkButton.addTarget(self, action: #selector(self.didTapCheckButton(_:)), for: .touchUpInside)
                cell.titleLabel.text = message.timestamp
//                if let seconds = message.timestamp?.doubleValue {
//                    let timestamp_date = Date(timeIntervalSince1970: seconds)
//                    let dateFormatter = DateFormatter()
//                    dateFormatter.dateFormat = "EEEE, MMM d, yyyy hh:mm a"
//                    cell.titleLabel.text = dateFormatter.string(from: timestamp_date)
//                }
                cell.totalLabel.text = message.name
                
                return cell
                
            default:  return UICollectionViewCell()
            }
        }
    }
    
    func reloadData(){
        
        var snapShot = NSDiffableDataSourceSnapshot<Sections,AnyHashable>()
        
        snapShot.appendSections([.sectionOne])
        snapShot.appendItems(admins,toSection: .sectionOne)
        
        dataSource?.apply(snapShot)
    }
    
    func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        
        return UICollectionViewCompositionalLayout {(sectionNumber,env) -> NSCollectionLayoutSection? in
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(45))
            
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 10
            
            return section
        }
    }
    
    @objc func didTapCheckButton(_ sender: UIButton){
        
        if let orderId = admins[sender.tag].childId {
            
            Database.database().reference().child("status").child(orderId).observeSingleEvent(of: .value) { snapshot in
     
                if let snap = snapshot.value as? [String:Any]{
                    let status = snap["current"] as? String

                    if status == "" {
                        let indexPath = IndexPath(item: sender.tag, section:0)
                        
                        let cell = self.collectionView.cellForItem(at: indexPath) as! TaskHistoryCell
                        cell.checkButton.setTitle("not done", for: .normal)
                    }else{
                        
                        let indexPath = IndexPath(item: sender.tag, section:0)
                        
                        let cell = self.collectionView.cellForItem(at: indexPath) as! TaskHistoryCell
                        cell.checkButton.setTitle("done", for: .normal)
                    }
                }
            }
        }
    }
    
    @objc func didTapMainButton(){
        navigationController?.popViewController(animated: false)
    }
    
    @objc func didTapRefreshButton(){
        observeUserMessages()
    }
    
    @objc func didTapSendOrderButton(){
        
        let ref = Database.database().reference().child("user-orders").child("8b8")
        
        if let indexPath = indexPath {
            
            let orderId = admins[indexPath.item].childId
            ref.setValue([orderId:1])
            ref.updateChildValues([orderId:1])
        }
    }
    
    @objc func didTapDeleteButton(){
        
        if let indexPath = indexPath {
            
            ordersDictionary = [:]
            let usernameRef =  Database.database().reference().child("admin")
            let reft = usernameRef.child(admins[indexPath.item].childId!)
            reft.removeValue()
            
            admins.remove(at: indexPath.item)
            reloadData()
        }
    }
    
    func observeUserMessages() {
                
        let postsRef = Database.database().reference().child("admin")
        
        postsRef.observeSingleEvent(of: .value, with: { snapshot in
            
            for child in snapshot.children {
                
                let snap = child as! DataSnapshot
                let dictionary = snap.value as! [String: Any]
                var message = Admin()
                
                message.restId = dictionary["restId"] as? String
                message.timestamp = dictionary["timestamp"] as? String
                message.name = dictionary["restName"] as? String
                message.childId = snap.key
                
                AppDataManager.shared.RestNameAndID = Policy(title: message.name, subTitle: message.childId, policy: "")
                      
                if let toId = message.childId{
                    self.ordersDictionary[toId] = message
                    self.admins = Array(self.ordersDictionary.values)
//                    self.admins.sort(by: { (order1, order2) -> Bool in
//                        return (order1.timestamp?.intValue)! > (order2.timestamp?.intValue)!
//                    })
                }
                
                DispatchQueue.global(qos: .userInteractive).async {
                    DispatchQueue.main.async {
                        self.reloadData()
                    }
                }
            }
        })
    }
}

extension CardViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.cellForItem(at: indexPath)?.contentView.backgroundColor = .systemRed
        
        self.indexPath = indexPath
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)?.contentView.backgroundColor = .clear
    }
}
