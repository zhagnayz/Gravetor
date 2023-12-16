//
//  ViewController.swift
//  GravetonDriver
//
//  Created by Daniel Zhagany Zamora on 2/26/23.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    
    var iconMenu: [IconMenu] = [IconMenu(icon: "", title: "Login", subTitle: nil),IconMenu(icon: "", title: "Became Graveton Driver", subTitle: nil)]
    
    var placeHolder = ["email","password"]
    
    private lazy var showOrHideButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        button.setTitle("show", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.addTarget(self, action: #selector(didTapHideOrShowButton(_:)), for: .touchUpInside)
        return button
    }()
    
    var tempPlaceHolder:[String] = []
    var hideOrShowClick = true
    
    enum Sections: Int {
        case sectionOne
        case sectionTwo
        case sectionThree
    }
    
    var collectionView: UICollectionView!
    
    var dataSource: UICollectionViewDiffableDataSource<Sections,AnyHashable>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView = UICollectionView(frame: view.bounds,collectionViewLayout: createCompositionalLayout())
        
        collectionView.backgroundColor = .tertiarySystemGroupedBackground
        
        view.addSubview(collectionView)
        
        collectionView.register(HeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: HeaderReusableView.reuseIdentifier)
        
        collectionView.register(FeaturedCircleProducts.self, forCellWithReuseIdentifier: FeaturedCircleProducts.reuseIdentifier)
        
        collectionView.register(TextFieldCell.self, forCellWithReuseIdentifier: TextFieldCell.reuseIdentifier)
        
        collectionView.register(ButtonCell.self, forCellWithReuseIdentifier: ButtonCell.reuseIdentifier)
        
        collectionView.delegate = self
        
        createDataSource()
        reloadData()
    }
    
    func createDataSource(){
        
        dataSource = UICollectionViewDiffableDataSource<Sections,AnyHashable>(collectionView:collectionView){collectionView,indexPath, item in
            
            switch indexPath.section {
                
            case Sections.sectionOne.rawValue:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedCircleProducts.reuseIdentifier, for: indexPath) as? FeaturedCircleProducts else {fatalError(FeaturedCircleProducts.reuseIdentifier)}
                
                cell.imageView.image = UIImage(named: "AppIcon")
                cell.nameLabel.text = "Earn money today. Sign up to become a Graveton Driver in Minutes."
                
                return cell
            case Sections.sectionTwo.rawValue:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextFieldCell.reuseIdentifier, for: indexPath) as? TextFieldCell else {fatalError(TextFieldCell.reuseIdentifier)}
                
                cell.placeHolderr = self.placeHolder[indexPath.item]
                

                cell.textField.delegate = self
                
                if indexPath.item == 1{
                    cell.textField.isSecureTextEntry = true
                    cell.textField.rightViewMode = .always
                    cell.textField.rightView = self.showOrHideButton
                }
                
                return cell
                
            case Sections.sectionThree.rawValue:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ButtonCell.reuseIdentifier, for: indexPath) as? ButtonCell else {fatalError(ButtonCell.reuseIdentifier)}
                
                cell.contentView.backgroundColor = .systemBackground
                
                cell.imageIcon.isHidden = true
                cell.layer.masksToBounds = true
                cell.layer.cornerRadius = cell.frame.size.height/2
                
                cell.configureCell(item as? IconMenu)
                
                return cell
                
            default: return UICollectionViewCell()
            }
        }
    }
    
    func reloadData(){
        
        var snapShot = NSDiffableDataSourceSnapshot<Sections,AnyHashable>()
        
        snapShot.appendSections([.sectionOne,.sectionTwo,.sectionThree])
        
        snapShot.appendItems(["icon"],toSection: Sections.sectionOne)
        snapShot.appendItems(tempPlaceHolder,toSection: Sections.sectionTwo)
        snapShot.appendItems(iconMenu,toSection: Sections.sectionThree)
        
        dataSource?.apply(snapShot)
    }
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout{ sectionIndex, layoutEnvironment in
            
            guard let sectionType = Sections(rawValue: sectionIndex) else {fatalError()}
            
            switch sectionType {
                
            case .sectionOne: return self.createGravetonSection()
            case .sectionTwo: return self.createTextFieldsSection()
            case .sectionThree: return self.createButtonssSection()
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        
        return layout
    }
    
    func createGravetonSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(190))
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 100, leading: 50, bottom: 0, trailing: 50)
        
        return layoutSection
    }
    
    
    func createTextFieldsSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 35, bottom: 0, trailing: 35)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        
        return layoutSection
    }
    
    func createButtonssSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0)
        let nestedVerticalGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
        let nestedVerticalGroup =  NSCollectionLayoutGroup.vertical(layoutSize: nestedVerticalGroupSize, subitems: [layoutItem])
        
        nestedVerticalGroup.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 35, bottom: 0, trailing: 35)
        
        let layoutSection = NSCollectionLayoutSection(group: nestedVerticalGroup)
        
        return layoutSection
    }
    
    func didTapLoginButton(){
        
        if tempPlaceHolder == []{
            tempPlaceHolder = placeHolder
            reloadData()
            return
        }
        
        loginasGuest()
        
        var personInfo = PersonInfo()
        
        for item in 0..<collectionView.numberOfItems(inSection: 1){
            
            let indexPath = IndexPath(item: item, section: 1)
            
            let cell = collectionView.cellForItem(at: indexPath) as! TextFieldCell
            
            switch item {
                
            case 0: personInfo.email = cell.textField.text!.trimmingCharacters(in: .whitespaces)
            case 1: personInfo.password = cell.textField.text!
                
            default: cell.backgroundColor = .white
            }
        }
        
        if let email = personInfo.email,let password = personInfo.password {
            
            if email.count > 0, password.count > 0 {
                handleLogin(email,password)
                return
            }
        }
    }
    
    func handleLogin(_ email:String,_ password:String) {
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(ViewController())
            
            AppDataManager.shared.driverAvailable(result?.user.uid)
            UserDefaults.standard.set(true, forKey: "isUserLogged")
        }
    }
        
    func loginasGuest(){
        
        let taskVC = UINavigationController(rootViewController: TaskViewController())
        
        // navigationController?.pushViewController(taskVC, animated: false)
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(taskVC)
    }
    
    func didTapRegisterButton(){
         let regiserVC = RegisterViewController()
         navigationController?.pushViewController(regiserVC, animated: false)
     }
    
    @objc func didTapHideOrShowButton(_ sender: UIButton){
        
        sender.isSelected = !sender.isSelected
        
        let cell = collectionView.cellForItem(at: IndexPath(item: 1, section: 1)) as? TextFieldCell
        
        if sender.isSelected {
            
            cell?.textField.isSecureTextEntry = sender.isSelected
            
            showOrHideButton.setTitle("show", for: .normal)
            
        }else{
            
            cell?.textField.isSecureTextEntry = sender.isSelected
            
            showOrHideButton.setTitle("hide", for: .normal)
        }
        reloadData()
    }
 
    func isEmailValid(email: String) -> Bool {
        var string = email
        
        if let lastCharacter = email.last?.description {
            if let unicodeValue = UnicodeScalar(lastCharacter) {
                if !CharacterSet.letters.contains(unicodeValue) && !CharacterSet.decimalDigits.contains(unicodeValue) {
                    string = String(string[..<string.index(before: string.endIndex)])
                }
            }
        }
        
        if !string.contains("@") { return false }
        else if string.hasSuffix("gmail.com") { return true }
        else if string.hasSuffix("hotmail.com") { return true }
        else if string.hasSuffix("outlook.com") { return true }
        else if string.hasSuffix("pdx.edu") { return true }
        else if string.hasSuffix("icloud.com") { return true }
        else { return false }
    }
}

extension ViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == 2 && indexPath.item == 0 {
            didTapLoginButton()

        }else if indexPath.section == 2 && indexPath.item == 1 {
            didTapRegisterButton()
        }
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        for _ in 0..<collectionView.numberOfItems(inSection: 1){
            
            let indexPath = IndexPath(item: 0, section: 1)
            
            let cell = collectionView.cellForItem(at: indexPath) as! TextFieldCell
            
            if textField == cell.textField {
                
                guard let email = textField.text else { return false }
                cell.textField.errorMessage = isEmailValid(email: email+string) ? nil : "email must be valid email address"
            }
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        for item in 0..<collectionView.numberOfItems(inSection: 1){
            
            let indexPath = IndexPath(item:item , section: 1)
            
            let cell = collectionView.cellForItem(at: indexPath) as! TextFieldCell
            
            if textField == cell.textField {
                textField.resignFirstResponder()
            }
        }
        
        return true
    }
}


class FeaturedCircleProducts: UICollectionViewCell {
    
    static let reuseIdentifier: String = "CircleProductCell"
    
    var outerView: UIView = {
        var view = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = CGSize(width: 5, height: 10)
        view.layer.cornerRadius = view.frame.size.width/2
        view.layer.shadowRadius = 10
        view.layer.shadowPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: 40).cgPath
        return view
    }()
    
    var imageView: UIImageView = {
        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        image.layer.cornerRadius = image.frame.size.width/2
        image.layer.masksToBounds = true
        return image
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25,weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        outerView.addSubview(imageView)
        
        let stackView = UIStackView(arrangedSubviews: [outerView,nameLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            outerView.heightAnchor.constraint(equalToConstant: 80),
            outerView.widthAnchor.constraint(equalToConstant: 80)
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
