//
//  TaskHistoryViewController.swift
//  GravetonDriver
//
//  Created by Daniel Zhagany Zamora on 2/26/23.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class TaskHistoryViewController: UIViewController {
    
    var policyString:String?
    
    private var totalEarn = TotalEarn()
    
    enum Section: Int{
        case section
    }
    
    var collectionView: UICollectionView!
    
    var dataSource: UICollectionViewDiffableDataSource<Section,AnyHashable>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getTotalEarns()
        
        if policyString  == nil{
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward")?.withTintColor(.label, renderingMode: .alwaysOriginal), style: .done, target: self, action: #selector(didTapBackButton))
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "p.circle.fill",withConfiguration: UIImage.SymbolConfiguration(pointSize: 50)), style: .done, target: self, action: #selector(didTapClearHistoryButton))
        }
        
        collectionView = UICollectionView(frame: view.bounds,collectionViewLayout: createCompositionalLayout())
        collectionView.backgroundColor = .systemBackground
        
        view.addSubview(collectionView)
        
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseIdentifier)
        
        collectionView.register(TaskHistoryCell.self, forCellWithReuseIdentifier: TaskHistoryCell.reuseIdentifier)
        
        collectionView.register(SideMenuCell.self, forCellWithReuseIdentifier: SideMenuCell.reuseIdentifier)
        
        createData()
    }
    
    func createData(){
        
        dataSource = UICollectionViewDiffableDataSource<Section,AnyHashable>(collectionView:collectionView){
            collectionView,indexPath, item in
            
            if let earn = item as? Earn {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TaskHistoryCell.reuseIdentifier, for: indexPath) as? TaskHistoryCell else {fatalError()}
                
                cell.configureCell(earn)
                
                return cell
            }else if let policyString = item as? String {
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SideMenuCell.reuseIdentifier, for: indexPath) as? SideMenuCell else {fatalError()}
                
                cell.titleLabel.text = policyString
                
                return cell
            }else{
                return UICollectionViewCell()
            }
        }
        
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseIdentifier, for: indexPath) as? SectionHeader else {fatalError()}
            
            sectionHeader.titleLabel.text = "This week \(self.totalEarn.dateThough ?? "")"
            sectionHeader.tipLabel.text = self.totalEarn.formattedtotalEar
            sectionHeader.tipLabel.textColor = .systemGreen
            return sectionHeader
        }
    }
    
    func reloadData(){
        
        var snapShot = NSDiffableDataSourceSnapshot<Section,AnyHashable>()
        
        snapShot.appendSections([Section.section])
        
        defer{dataSource?.apply(snapShot)}
        
        guard let policyString = policyString else {
            snapShot.appendItems(totalEarn.earns,toSection: Section.section)
            
            return}
        
        snapShot.appendItems([policyString],toSection: Section.section)
    }
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { sectionIndex,layoutEnvironment in
            
            if let _ = self.policyString {
                return self.createPolicySection()
            }else{
                return self.createSectionDriver()
            }
            
        }
        return layout
    }
    
    func createSectionDriver() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        let layoutSectionHeader = createSectionHeader()
        layoutSection.boundarySupplementaryItems = [layoutSectionHeader]
        layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 40, leading:0, bottom:0, trailing:0)
        
        return layoutSection
    }
    
    func createPolicySection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(5.8))
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        
        return layoutSection
    }
    
    func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.85), heightDimension: .estimated(80))
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        return layoutSectionHeader
    }

    func getTotalEarns(){
        let t:String? = "8b8"
        if let uid = t {
            let ref = Database.database().reference().child(uid).child("earns")
            var earns = [Earn]()
            
            ref.observeSingleEvent(of: .value) { snapshot,error  in
                
                for child in snapshot.children {
                    
                    let snap = child as! DataSnapshot
                    let dictionary = snap.value as! [String: Any]
                    
                    let total = dictionary["total"] as? Double
                    let timestamp = dictionary["timestamp"] as? NSNumber
                    
                    let earn = Earn(timestamp: timestamp ?? 0.0, total: total ?? 0.0)
                    earns.append(earn)
                }
                
                self.totalEarn.earns = earns
                self.reloadData()
            }
        }

    }
    
    @objc func didTapBackButton(){
        navigationController?.popViewController(animated: false)
    }
    
    @objc func didTapClearHistoryButton(){
        createAlernController("Request Depositing", "pay is weekly basis for all deliveries completed between Monday - Sunday total earned is \(totalEarn.formattedtotalEar)", "Ok", "Ok")
    }
    
    func createAlernController(_ title:String,_ message:String,_ bttonTitle:String,_ sdBttTitle:String){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
//        let yesAction = UIAlertAction(title: bttonTitle, style: .destructive) { (action:UIAlertAction!) in
//           // self.promptForAnswer()
//        }
//
       // alertController.addAction(yesAction)
        
        let cancelAction = UIAlertAction(title:sdBttTitle, style: .cancel)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion:nil)
    }
}
