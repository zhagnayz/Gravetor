//
//  OrderDetailsViewController.swift
//  GravetonDriver
//
//  Created by Daniel Zhagany Zamora on 2/27/23.
//

import UIKit

class OrderDetailsViewController: UIViewController {
    
    enum Section: Int {
        case sectionOne
        case sectionTwo
        case sectionThree
    }
    
    var user: User?
    
    var collectionView: UICollectionView!
    
    var dataSource: UICollectionViewDiffableDataSource<Section,AnyHashable>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .tertiarySystemGroupedBackground
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward")?.withTintColor(.label, renderingMode: .alwaysOriginal), style: .done, target: self, action: #selector(didTapBackToHomeButton))
        
        collectionView = UICollectionView(frame: view.bounds,collectionViewLayout: createCompositionalLayout())
        collectionView.backgroundColor = .systemBackground
        
        view.addSubview(collectionView)
        
        collectionView.register(ReceiptTopCell.self, forCellWithReuseIdentifier: ReceiptTopCell.reuseIdentifier)
        
        collectionView.register(CartMenuItemCell.self, forCellWithReuseIdentifier: CartMenuItemCell.reuseIdentifier)
        
        collectionView.register(PriceDetailsCell.self, forCellWithReuseIdentifier: PriceDetailsCell.reuseIdentifier)
        
        createDataSource()
        reloadData()
    }
    
    func createDataSource() {
        
        dataSource = UICollectionViewDiffableDataSource<Section,AnyHashable>(collectionView: collectionView){collectionView,indexPath, item in
            
            switch indexPath.section{
                
            case Section.sectionOne.rawValue:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReceiptTopCell.reuseIdentifier, for: indexPath) as? ReceiptTopCell else {fatalError(ReceiptTopCell.reuseIdentifier)}
                
                cell.backgroundColor = .tertiarySystemGroupedBackground
                
                cell.configureReceipt(self.user, indexPath: indexPath)
                
                return cell
                
            case Section.sectionTwo.rawValue:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CartMenuItemCell.reuseIdentifier, for: indexPath) as? CartMenuItemCell else {fatalError(CartMenuItemCell.reuseIdentifier)}
                
                let orderItem = self.user?.order.orderItem[indexPath.item]
                cell.configureCell(orderItem)
                cell.backgroundColor = .tertiarySystemGroupedBackground
                return cell
                
            case Section.sectionThree.rawValue:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PriceDetailsCell.reuseIdentifier, for: indexPath) as? PriceDetailsCell else {fatalError(PriceDetailsCell.reuseIdentifier)}
                
                cell.backgroundColor = .tertiarySystemGroupedBackground
                self.user?.order.getSubTotal()
                cell.configurePricceDetail(self.user?.order)
                return cell
                
            default: return UICollectionViewCell()
            }
        }
    }
    
    func reloadData(){
        
        var snapShot = NSDiffableDataSourceSnapshot<Section,AnyHashable>()
        
        snapShot.appendSections([.sectionOne,.sectionTwo,.sectionThree,])
        
        snapShot.appendItems((self.user?.order.orderItem)!,toSection: Section.sectionOne)
        snapShot.appendItems([user],toSection: Section.sectionTwo)
        snapShot.appendItems([self.user?.order],toSection: Section.sectionThree)
        
        dataSource?.apply(snapShot)
    }
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            
            guard let section = Section(rawValue: sectionIndex) else {fatalError()}
            
            switch section {
                
            case Section.sectionOne: return self.createReceiptSection()
            case Section.sectionTwo: return self.createSelectedItemsSection()
            case Section.sectionThree: return self.createOrderDetailsSection()
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 10
        layout.configuration = config
        
        return layout
    }
    
    func createReceiptSection() -> NSCollectionLayoutSection{
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(150))
        
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        
        return layoutSection
    }
    
    func createSelectedItemsSection() -> NSCollectionLayoutSection{
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200))
        
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        
        return layoutSection
    }
    
    func createOrderDetailsSection() -> NSCollectionLayoutSection{
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200))
        
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        
        return layoutSection
    }
    
    @objc func didTapBackToHomeButton(){
        navigationController?.popViewController(animated: true)
    }
}
