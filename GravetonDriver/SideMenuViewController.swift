//
//  SideMenuViewController.swift
//  GravetonDriver
//
//  Created by Daniel Zhagany Zamora on 2/26/23.
//

import UIKit

protocol SideMenuViewControllerDelegate: AnyObject {
    func selectedCell(_ item: Int)
}


class AccountViewController: UIViewController {
    
    var iconMenu: [IconMenu] = [
        IconMenu(icon: "folder.circle", title: "Task", subTitle: nil),
        IconMenu(icon: "person.circle", title: "Profile", subTitle: nil),
        IconMenu(icon: "dollarsign.circle", title: "Earnings", subTitle: nil),
        IconMenu(icon: "gear.circle", title: "Settings", subTitle: nil),
        IconMenu(icon: "hand.thumbsup.fill", title: "Like us on facebook", subTitle: nil)]

    var logout: [IconMenu] = [IconMenu(icon: nil, title: "logout", subTitle: nil)]
    
    var collectionView: UICollectionView!
    
    enum Sections: Int {
        case sectionOne
        case sectionTwo
    }
    
    weak var delegate: SideMenuViewControllerDelegate?
    
    var dataSource: UICollectionViewDiffableDataSource<Sections,AnyHashable>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Account"
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: compositinLayout())
        collectionView.backgroundColor = .tertiarySystemGroupedBackground
        
        view.addSubview(collectionView)
        
        collectionView.register(AccountCell.self, forCellWithReuseIdentifier: AccountCell.reuseIdentifier)
        
        collectionView.register(ButtonCell.self, forCellWithReuseIdentifier: ButtonCell.reuseIdentifier)
        
        createDataSource()
        reloadData()
        
        collectionView.delegate = self
    }
    
    func createDataSource(){
        
        dataSource = UICollectionViewDiffableDataSource<Sections,AnyHashable>(collectionView:collectionView){ collectionView, indexPath, item in
            
            switch indexPath.section {
                
            case Sections.sectionOne.rawValue:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AccountCell.reuseIdentifier, for: indexPath) as? AccountCell else {fatalError()}
                
                cell.configureCell(iconMenu: self.iconMenu, indexPath: indexPath)
                
                return cell
                
            case Sections.sectionTwo.rawValue:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ButtonCell.reuseIdentifier, for: indexPath) as? ButtonCell else {fatalError()}
                
                cell.configureCell(item as? IconMenu)
                cell.backgroundColor = .systemBackground
                return cell
                
            default: return UICollectionViewCell()
            }
        }
    }
    
    func reloadData(){
        
        var snapShot = NSDiffableDataSourceSnapshot<Sections,AnyHashable>()
        
        snapShot.appendSections([Sections.sectionOne,Sections.sectionTwo])
        snapShot.appendItems(iconMenu, toSection: Sections.sectionOne)
        snapShot.appendItems(logout, toSection: Sections.sectionTwo)
        
        dataSource?.apply(snapShot)
    }
    
    func compositinLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            
            guard let section = Sections(rawValue: sectionIndex) else {fatalError()}
            
            switch section {
            
            case .sectionOne: return self.iconMenuSecion()
            case .sectionTwo: return self.logOutSection()
                
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 100
        layout.configuration = config
        
        return layout
    }
    
    func iconMenuSecion() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 10, bottom: 0, trailing: 0)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.interGroupSpacing = 40
        
        return layoutSection
    }
    
    func logOutSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        
        return layoutSection
    }
    
    func didTapLogoutButton(){
        
        if AppDataManager.shared.users.count > 0 {
            
            createAlernController("Error", "Please complete the assigned tasks", "ok")
        }else{
         
            UserDefaults.standard.set(false, forKey: "isUserLogged")
            
            let loginNavController = UINavigationController(rootViewController: ViewController())
            
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginNavController)
        }
    }
    
    func createAlernController(_ title:String,_ message:String,_ bttonTitle:String){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: bttonTitle, style: .cancel)
            
        alertController.addAction(yesAction)
        
        self.present(alertController, animated: true, completion:nil)
    }
}

extension AccountViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        if indexPath.section == 0 {
            self.delegate?.selectedCell(indexPath.item)
        }else if indexPath.section == 1 {
            didTapLogoutButton()
        }
    }
}
