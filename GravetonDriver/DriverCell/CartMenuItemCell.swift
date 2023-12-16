//
//  CartMenuItemCell.swift
//  GravetonDriver
//
//  Created by Daniel Zhagany Zamora on 2/27/23.
//

import UIKit

class CartMenuItemCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = "CartMenuItemCell"
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16,weight: .semibold)
        return label
    }()
    
    let proteinLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .label
        return label
    }()
    
    let detailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .label
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16,weight: .semibold)
        label.textColor = .red
        return label
    }()
    
    var addedItems:[String]? = []{
        
        didSet{
            reloadData()
        }
    }
    
    enum Sections: Int {
        case sectionOne
    }
    
    var collectionView: UICollectionView!
    
    var dataSource: UICollectionViewDiffableDataSource<Sections,AnyHashable>?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 4
        contentView.backgroundColor = .tertiarySystemGroupedBackground
        
        collectionView = UICollectionView(frame: contentView.bounds,collectionViewLayout: createCompositionalLayout())
        
        collectionView.backgroundColor = .tertiarySystemGroupedBackground
        
        collectionView.register(AccountCell.self, forCellWithReuseIdentifier: AccountCell.reuseIdentifier)
        
        createDataSource()
        
        let stackViewOne = UIStackView(arrangedSubviews: [proteinLabel,detailLabel])
        stackViewOne.axis = .vertical
        
        let stackViewThree = UIStackView(arrangedSubviews: [stackViewOne,collectionView])
        stackViewThree.axis = .vertical
        stackViewThree.spacing = 10
        
        let stackViewTwo = UIStackView(arrangedSubviews: [nameLabel,priceLabel])
        stackViewTwo.distribution = .equalSpacing
        
        let stackView = UIStackView(arrangedSubviews: [stackViewTwo,stackViewThree])
        stackView.axis = .vertical
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 10),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 10),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -10),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    func configureCell(_ orderItem:OrderItem?){
        
        guard let orderItem = orderItem else {return}
        
        nameLabel.text = orderItem.name
        
        if let proteins = orderItem.protein {
            
            for pro in  proteins{
                proteinLabel.text =  pro
            }
        }
 
        detailLabel.text = orderItem.spiceLevel
        priceLabel.text = orderItem.formattedSubTotal
        addedItems = orderItem.addItems
    }
    
    func createDataSource(){
        
        dataSource = UICollectionViewDiffableDataSource<Sections,AnyHashable>(collectionView:collectionView){collectionView,indexPath, item in
            
            switch indexPath.section{
                
            case Sections.sectionOne.rawValue:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AccountCell.reuseIdentifier, for: indexPath) as? AccountCell else {fatalError()}
                
                cell.nameLabel.text = self.addedItems?[indexPath.item]
                cell.imageIcon.image = UIImage(systemName: "chevron.right")
                return cell
            default:
                return UICollectionViewCell()
            }
        }
    }
    
    func reloadData(){
        
        var snapShot = NSDiffableDataSourceSnapshot<Sections,AnyHashable>()
        
        guard let addedItems = addedItems else {return}
        
        snapShot.appendSections([Sections.sectionOne])
        snapShot.appendItems(addedItems,toSection: Sections.sectionOne)
        
        dataSource?.apply(snapShot)
    }
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout{ sectionIndex, layoutEnvironment in
            
            guard let sectionType = Sections(rawValue: sectionIndex) else {fatalError()}
            
            switch sectionType {
                
            case .sectionOne: return self.createAddItemsSection()
            }
        }
        return layout
    }
    
    func createAddItemsSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(30))
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        
        return layoutSection
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

