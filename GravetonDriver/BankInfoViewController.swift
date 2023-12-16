//
//  BankInfoViewController.swift
//  GravetonDriver
//
//  Created by Daniel Zhagany Zamora on 8/5/23.
//

import UIKit

class BankInfoViewController: UIViewController {
    
    private var dataString:[String] = ["Account Number","Routing Number","Legal Name","Date of Birth"]
    
    var iconMenu = [IconMenu(icon: "", title: "Register", subTitle: nil)]
    
    enum Sections: Int {
        case sectionOne
        case sectionTwo
    }
    
    var collectionView: UICollectionView!
    
    var dataSource: UICollectionViewDiffableDataSource<Sections,AnyHashable>?
    let config = UIImage.SymbolConfiguration(pointSize: 20)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward",withConfiguration: config)?.withTintColor(.label, renderingMode: .alwaysOriginal), style: .done, target: self, action: #selector(didTapBackButton))
        
        collectionView = UICollectionView(frame: view.bounds,collectionViewLayout: createCompositionalLayout())
        
        collectionView.backgroundColor = .tertiarySystemGroupedBackground
        
        view.addSubview(collectionView)
        
        collectionView.register(HeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderReusableView.reuseIdentifier)
        
        collectionView.register(TextFieldCell.self, forCellWithReuseIdentifier: TextFieldCell.reuseIdentifier)
        
        collectionView.register(ButtonCell.self, forCellWithReuseIdentifier: ButtonCell.reuseIdentifier)
        
        collectionView.delegate = self
        createDataSource()
        reloadData()
    }
    
    func createDataSource(){
        
        dataSource = UICollectionViewDiffableDataSource<Sections,AnyHashable>(collectionView:collectionView){collectionView,indexPath, item in
            
            switch indexPath.section{
                
            case Sections.sectionOne.rawValue:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextFieldCell.reuseIdentifier, for: indexPath) as? TextFieldCell else {fatalError()}
                
                cell.placeHolderr = self.dataString[indexPath.item]
                cell.textField.delegate = self
                return cell
                
            case Sections.sectionTwo.rawValue:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ButtonCell.reuseIdentifier, for: indexPath) as? ButtonCell else {fatalError()}
                
                cell.configureCell(item as? IconMenu)
                
                return cell
                
            default:
                return UICollectionViewCell()
            }
        }
        
        dataSource?.supplementaryViewProvider = {collectionView, kind, indexPath in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderReusableView.reuseIdentifier, for: indexPath) as? HeaderReusableView else {return nil}
            
            sectionHeader.headerLabel.text = "Add your bank account information so you can get paid"
            sectionHeader.subHeaderLabel.text = "This information is secure and we will never withdraw from this account."
            return sectionHeader
        }
    }
    
    func reloadData(){
        
        var snapShot = NSDiffableDataSourceSnapshot<Sections,AnyHashable>()
        
        snapShot.appendSections([Sections.sectionOne,Sections.sectionTwo])
        snapShot.appendItems(dataString,toSection: Sections.sectionOne)
        snapShot.appendItems(iconMenu,toSection: Sections.sectionTwo)
        
        dataSource?.apply(snapShot)
    }
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout{ sectionIndex, layoutEnvironment in
            
            guard let sectionType = Sections(rawValue: sectionIndex) else {fatalError()}
            
            switch sectionType {
                
            case .sectionOne: return self.createProteinSection()
            case .sectionTwo: return self.createButtonssSection()
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 30
        layout.configuration = config
        
        return layout
    }
    
    func createProteinSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(70))
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 50, leading: 0, bottom: 0, trailing: 0)
        let layoutHeaderSection = createCategoryHeaderSection()
        layoutSection.boundarySupplementaryItems = [layoutHeaderSection]
        
        return layoutSection
    }
    
    func createButtonssSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        
        return layoutSection
    }
    
    func createCategoryHeaderSection() -> NSCollectionLayoutBoundarySupplementaryItem {
        
        let layoutHeaderSectionSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.94), heightDimension: .estimated(80))
        
        let layoutHeaderSection = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutHeaderSectionSize,elementKind: UICollectionView.elementKindSectionHeader,alignment: .top)
        
        return layoutHeaderSection
    }
    
    @objc func readDataInfo(){
        
        var userAccountInfo = PersonInfo()
        
        for item in 0..<collectionView.numberOfItems(inSection: 0){
            
            let indexPath = NSIndexPath(item: item, section: 0)
            
            let cell = collectionView.cellForItem(at: indexPath as IndexPath) as! TextFieldCell
            
            switch item {
                
            case 0:userAccountInfo.firstName = cell.textField.text!
            case 1:userAccountInfo.lastName = cell.textField.text!
            case 2:userAccountInfo.email = cell.textField.text!
            case 3:userAccountInfo.phone = cell.textField.text!
            default:
                cell.backgroundColor = .red
            }
        }
        
        if let accountNum = userAccountInfo.firstName,let routingNum = userAccountInfo.lastName,let legalName = userAccountInfo.email,let dfb = userAccountInfo.phone{
            
            if accountNum.count > 0,routingNum.count > 0,legalName.count > 0,dfb.count > 0{
                
                var bankInfos:[String:String] = ["accountNum":accountNum,"routingNum":routingNum,"legalName":legalName,"dateOfBirth":dfb]
                
                userBankInfoIntoDatabase(values: bankInfos)
            }else{
                self.navigationItem.title = "Fill require fields"
            }
        }
    }
    
    func userBankInfoIntoDatabase(values:[String:String]){
        
        //        let dataToSave:[String:Any] = ["businInfo":businessInfo,"hourStatus":isAllSameHour,"storeHours":storeHours,"bankInfo":bankInfo]
        //
        //        if let uid = uid {
        //
        //            let business_ref = Database.database().reference().child("user-businessInfo")
        //            let childBusin_ref = business_ref.child(uid)
        //
        //            childBusin_ref.setValue(dataToSave)
        //        }
        
        let taskVC =  UINavigationController(rootViewController: ViewController())
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(taskVC)
        
    }
    
    @objc func didTapBackButton(){
        navigationController?.popViewController(animated: false)
    }
}

extension BankInfoViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == 1 && indexPath.item == 0 {
            
            readDataInfo()
        }
    }
}

extension BankInfoViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}
