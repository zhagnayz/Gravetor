//
//  DropViewController.swift
//  GravetonDriver
//
//  Created by Daniel Zhagany Zamora on 2/26/23.
//

import UIKit
import MapKit
import FirebaseDatabase

class DropViewController: UIViewController{
    
    var inFoButton: [IconMenu] = [IconMenu(icon: "location", title: "Navigate", subTitle: nil),IconMenu(icon: "pencil.and.scribble", title: "Order details", subTitle: nil)]
    
    private let value = Policy(title: nil, subTitle: "Task Details", policy: "Task Reference")
    var colordrop: [UIColor] = [UIColor.blue,UIColor.green]
    private var status_ref: DatabaseReference?
    var numberPassed: Int = 0
    var user: User?
    
    enum Sections: Int {
        case sectionOne
        case sectionTwo
        case sectionThree
    }
    
    var collectionView: UICollectionView!
    
    var dataSource: UICollectionViewDiffableDataSource<Sections,AnyHashable>?
    
    private lazy var floatingButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 6
        return button
    }()
        
    private var imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 200))
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 4
        return imageView
    }()
    
    private lazy var cameraButton:UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height:50))
        button.setImage(UIImage(systemName: "camera")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 50)).withTintColor(.red, renderingMode: .alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(didTapCameraButton), for: .touchDown)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if let orderId = user?.orderId {
            status_ref = Database.database().reference().child("status").child(orderId)
            floatingButton.setTitle("Hold to let client knows you have arrived", for: .normal)
            status_ref?.updateChildValues(["current":"Driver heading to you"])
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "camera")?.withTintColor(.gray, renderingMode: .alwaysOriginal), style: .done, target: self, action: #selector(didTapTakePictureButton))
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
//            
//            self.navigationController?.popViewController(animated: false)
//        })
        
        view.backgroundColor = .systemBackground

        cameraButton.center = view.center
        imageView.frame = CGRect(x: view.frame.size.width/2 - 50, y: 200, width: 100, height: 200)
        view.addSubview(cameraButton)
                
        collectionView = UICollectionView(frame: view.bounds,collectionViewLayout: createCompositionalLayout())
        
        collectionView.backgroundColor = .systemBackground
        
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        
        collectionView.register(ClientInfoCell.self, forCellWithReuseIdentifier: ClientInfoCell.reuseIdentifier)
        
        collectionView.register(ButtonCell.self, forCellWithReuseIdentifier: ButtonCell.reuseIdentifier)
        collectionView.register(TaskDetailsCell.self, forCellWithReuseIdentifier: TaskDetailsCell.reuseIdentifier)
        
        collectionView.delegate = self
        
        createDataSource()
        reloadData()
        
        view.addSubview(floatingButton)
        
        let long = UILongPressGestureRecognizer(target: self, action: #selector(didHoldButtonDrop(_:)))
        long.minimumPressDuration = 1
        
        self.floatingButton.addGestureRecognizer(long)
        
        NSLayoutConstraint.activate([
            floatingButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10),
            floatingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -10),
            floatingButton.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -50),
            floatingButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
   
    func createDataSource(){
        
        dataSource = UICollectionViewDiffableDataSource<Sections,AnyHashable>(collectionView:collectionView){collectionView,indexPath, item in
            
            switch indexPath.section{
                
            case Sections.sectionOne.rawValue:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ClientInfoCell.reuseIdentifier, for: indexPath) as? ClientInfoCell else {fatalError(ClientInfoCell.reuseIdentifier)}
                
                cell.BoxLabel.text = self.user?.driverInfo?.pickUpOrDrop
                cell.addressLabel.text = self.user?.driverInfo?.Deliveryaddress
                cell.mapFunction(self.user?.driverInfo?.PickUpaddress)
                cell.configureCell(self.user)

                return cell
            case Sections.sectionTwo.rawValue:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ButtonCell.reuseIdentifier, for: indexPath) as? ButtonCell else {fatalError(ButtonCell.reuseIdentifier)}
                
                cell.configureCell(item as? IconMenu)
                cell.backgroundColor = .tertiarySystemGroupedBackground

                return cell
                
            case Sections.sectionThree.rawValue:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TaskDetailsCell.reuseIdentifier, for: indexPath) as? TaskDetailsCell else {fatalError(TaskDetailsCell.reuseIdentifier)}
                
                cell.configureCell(self.user)
                cell.taskDetailLabel.text = self.value.subTitle
                cell.taskLabel.text = self.value.policy
                cell.restLabel.text = "order from \(self.user?.driverInfo?.restName ?? "")"
                return cell
                
            default: return UICollectionViewCell()
            }
        }
    }
    
    func reloadData(){
        
        var snapShot = NSDiffableDataSourceSnapshot<Sections,AnyHashable>()
        
        snapShot.appendSections([.sectionOne,.sectionTwo,.sectionThree])
        snapShot.appendItems([user],toSection: Sections.sectionOne)
        snapShot.appendItems(inFoButton,toSection: Sections.sectionTwo)
        snapShot.appendItems([value],toSection: Sections.sectionThree)
        
        dataSource?.apply(snapShot)
    }
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout{ sectionIndex, layoutEnvironment in
            
            guard let sectionType = Sections(rawValue: sectionIndex) else {fatalError()}
            
            switch sectionType {
                
            case Sections.sectionOne: return self.createProteinSection()
            case .sectionTwo: return self.ButtonsSection()
            case .sectionThree: return self.tastDetailsSection()
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        
        return layout
    }
    
    func createProteinSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(360))
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        
        return layoutSection
    }
    
    func ButtonsSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.interGroupSpacing = 5
        return layoutSection
    }
    
    func tastDetailsSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(150))
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.interGroupSpacing = 10
        return layoutSection
    }
    
    
    @objc func  didTapTakePictureButton(){
        collectionView.removeFromSuperview()
    }
    
    @objc func didTapCameraButton(){
        
        CameraManager.shared.showActionSheet(vc: self)
        CameraManager.shared.imagePickedBlock = { image in
            
            self.imageView.image = image
            self.view.addSubview(self.imageView)
        }
    }
    
    @objc func didHoldButtonDrop(_ sender: UIGestureRecognizer){
        
        if let button = sender.view as? UIButton {
            
            if sender.state == .ended {
                numberPassed += 1
                if numberPassed == 1 {
                    sender.view?.backgroundColor = colordrop[1]
                   button.setTitle("Hold to complete", for: .normal)
                    status_ref?.updateChildValues(["current":"Driver arrived at your location"])

                    let titleLabel = UILabel()
                    titleLabel.textColor = .red
                    titleLabel.text = "take picture of food, if it's not hand to client"
                    navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
                    
                }else{
                    status_ref?.updateChildValues(["current":"delivered"])
                    navigationController?.popToRootViewController(animated: false)
                }
            }
        }
    }
}

extension DropViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        if indexPath.section == 1 && indexPath.item == 0 {
            
        }else if indexPath.section == 1 && indexPath.item == 1 {
            
            let orderDetailsVC = OrderDetailsViewController()
            orderDetailsVC.user = user
            navigationController?.pushViewController(orderDetailsVC, animated: false)
        }
    }
}
