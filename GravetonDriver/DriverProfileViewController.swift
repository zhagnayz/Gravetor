//
//  DriverProfileViewController.swift
//  GravetonDriver
//
//  Created by Daniel Zhagany Zamora on 2/26/23.
//

import UIKit
import FirebaseAuth

class DriverProfileViewController: UIViewController{
    
    enum Sections: Int {
        case sectionOne
        case sectionTwo
    }

     var person = [IconMenu(icon: "person.circle", title: "Daniel Zhagnay Zamora", subTitle: nil),IconMenu(icon: "envelope.circle.fill", title: "zhagnayz@pdx.edu", subTitle: nil),IconMenu(icon: "phone.circle.fill", title: "612-343-3437", subTitle: nil),IconMenu(icon: nil, title: "Delete Account", subTitle: nil)]
    
    var collectionView: UICollectionView!
    
    var dataSource: UICollectionViewDiffableDataSource<Sections,AnyHashable>?
    
    
    private var fileManager = FileManager.default
    var image:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageData = try? Data(contentsOf: getURLFileManager())
        
        if let imageData = imageData {
            image = UIImage(data: imageData)
        }else{
            image = UIImage(named: "AppIcon")
        }

        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward")?.withTintColor(.label, renderingMode: .alwaysOriginal), style: .done, target: self, action: #selector(didTapBackButton))
        
        collectionView = UICollectionView(frame: view.bounds,collectionViewLayout: createCompositionalLayout())
        
        collectionView.backgroundColor = .tertiarySystemGroupedBackground
        
        view.addSubview(collectionView)
                
        collectionView.register(ProfilePersonInfoCell.self, forCellWithReuseIdentifier: ProfilePersonInfoCell.reuseIdentifier)
        
        collectionView.register(AccountCell.self, forCellWithReuseIdentifier: AccountCell.reuseIdentifier)
        
        collectionView.delegate = self

        createDataSource()
        reloadData()
    }

    func createDataSource(){
        
        dataSource = UICollectionViewDiffableDataSource<Sections,AnyHashable>(collectionView:collectionView){collectionView,indexPath, item in
            
            switch indexPath.section{
        
            case Sections.sectionOne.rawValue:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfilePersonInfoCell.reuseIdentifier, for: indexPath) as? ProfilePersonInfoCell else {fatalError()}
                
                cell.cameraButton.addTarget(self, action: #selector(self.didTappedCameraButton), for: .touchUpInside)
                
                cell.imageView.image = self.image

                return cell
            case Sections.sectionTwo.rawValue:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AccountCell.reuseIdentifier, for: indexPath) as? AccountCell else {fatalError()}
           
                cell.configureCell(iconMenu: self.person, indexPath: indexPath)
                
                if indexPath.item == 3 {
                    cell.nameLabel.textColor = .systemRed
                    cell.nameLabel.font = UIFont.systemFont(ofSize: 12)
                    cell.backgroundColor = .systemBackground
                }
                
                return cell

            default:return UICollectionViewCell()
            }
        }
    }
    
    func reloadData(){
        
        var snapShot = NSDiffableDataSourceSnapshot<Sections,AnyHashable>()
        
        snapShot.appendSections([.sectionOne,.sectionTwo])
        snapShot.appendItems([""],toSection: .sectionOne)
        snapShot.appendItems(person,toSection: .sectionTwo)
        dataSource?.apply(snapShot)
    }
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout{ sectionIndex, layoutEnvironment in
            
            guard let sectionType = Sections(rawValue: sectionIndex) else {fatalError()}
            
            switch sectionType {
            
            case .sectionOne: return self.createProteinSection()
            case .sectionTwo: return self.ButtonsSection()
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 50
        layout.configuration = config
        
        return layout
    }
    
    func createProteinSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(150))
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        
        layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 40, leading: 0, bottom: 0, trailing: 0)
        
        return layoutSection
    }
    
    func ButtonsSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(45))
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.interGroupSpacing = 20
        return layoutSection
    }
   
    @objc func didTapBackButton(){
        navigationController?.popViewController(animated: false)
    }
    
    @objc func didTappedCameraButton(){
        
        CameraManager.shared.showActionSheet(vc: self)
        CameraManager.shared.imagePickedBlock = { image in
            
            self.image = image
            
            let imageData = image.jpegData(compressionQuality: 1.0)
            do {
                try imageData?.write(to: self.getURLFileManager())
            }catch let error {
                print(error.localizedDescription)
            }
            self.reloadData()
        }
    }
    
    func getURLFileManager() -> URL {
        let documentDictory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let pathURL = documentDictory.appendingPathComponent("FilePhoto")
        return pathURL
    }
    
    func createAlernController(_ title:String,_ message:String,_ bttonTitle:String,_ sdBttTitle:String){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: bttonTitle, style: .destructive) { (action:UIAlertAction!) in
            
            if bttonTitle == "Logout" {
                self.logoutUser()
                return
            }
            
            if let user = Auth.auth().currentUser {
                
                user.delete(){ error in
                    
                    if let error = error {
                        self.navigationItem.title = error.localizedDescription
                    }else{
                        self.logoutUser()
                    }
                }
                
            }else{
                self.createAlernController("Error found", "log out then sign in again, then tap delete", "Logout", "Cancel")
            }
        }
        
        alertController.addAction(yesAction)
        
        let cancelAction = UIAlertAction(title:sdBttTitle, style: .cancel)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion:nil)
    }
    
    func logoutUser(){
        let loginNavController = UINavigationController(rootViewController: ViewController())
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginNavController)
        AppDataManager.shared.driverNotAvailable()
    }
}

extension DriverProfileViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.item == 3 {
            createAlernController("Deleteting Account", "will clear all related information to you.", "Yes", "No")
        }
    }
}
