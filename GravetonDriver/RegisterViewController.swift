//
//  RegisterViewController.swift
//  GravetonDriver
//
//  Created by Daniel Zhagany Zamora on 5/9/23.
//

import UIKit
import FirebaseStorage

class RegisterViewController: UIViewController {
    
    private lazy var showOrHideButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        button.setTitle("show", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.addTarget(self, action: #selector(didTapHideOrShowButton), for: .touchUpInside)
        return button
    }()
    
    var number: String = ""
    let config = UIImage.SymbolConfiguration(pointSize: 20)
    
    private lazy var didTapPolicyAndTerms = UITapGestureRecognizer(target: self, action: #selector(didTapPolicyAndTermsButton))
    
    var policyString = "By clicking Register, I agree to the Indepndent Contractor Agreement and have read the Graveton Privacy Policy"
    
    var SignUpplaceHolder = ["First Name","Last Name","Email","Phone","must be 18 or over","Password"]
    var DriverplaceHolder = ["First Name","Last Name","Email","Phone","must be 18 or over","Password","car model","policy number(insurance n.)"]
    
    var iconMenu = [IconMenu(icon: nil, title: "Register", subTitle: nil)]
    
    var flag = true
    
    enum Sections: Int {
        case sectionOne
        case sectionTwo
        case sectionThree
    }
    
    var collectionView: UICollectionView!
    
    var dataSource: UICollectionViewDiffableDataSource<Sections,AnyHashable>?
    
    private var fileManager = FileManager.default
    private let switchButton = UISwitch()
    private var isDriving:Bool = false
    private var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switchButton.addTarget(self, action: #selector(didTapSwitchButton(_:)), for: .valueChanged)
        
        navigationItem.title = "Are you going to be driving?"
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: switchButton)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward",withConfiguration: config)?.withTintColor(.label, renderingMode: .alwaysOriginal), style: .done, target: self, action: #selector(didTapBackButton))
        
        collectionView = UICollectionView(frame: view.bounds,collectionViewLayout: createCompositionalLayout())
        
        collectionView.backgroundColor = .tertiarySystemGroupedBackground
        
        view.addSubview(collectionView)
        
        collectionView.register(ProfilePersonInfoCell.self, forCellWithReuseIdentifier: ProfilePersonInfoCell.reuseIdentifier)
        
        collectionView.register(TextFieldCell.self, forCellWithReuseIdentifier: TextFieldCell.reuseIdentifier)
        
        collectionView.register(ButtonCell.self, forCellWithReuseIdentifier: ButtonCell.reuseIdentifier)
        
        collectionView.register(HeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: HeaderReusableView.reuseIdentifier)
        
        collectionView.delegate = self
        
        createDataSource()
        reloadData()
    }
    
    func createDataSource(){
        
        dataSource = UICollectionViewDiffableDataSource<Sections,AnyHashable>(collectionView:collectionView){collectionView,indexPath, item in
            
            switch indexPath.section {
                
            case Sections.sectionOne.rawValue:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfilePersonInfoCell.reuseIdentifier, for: indexPath) as? ProfilePersonInfoCell else {fatalError()}
                cell.imageView.image = self.image
                cell.cameraButton.addTarget(self, action: #selector(self.didTappedCameraButton), for: .touchUpInside)
                cell.subHeaderLabel.text = "require* if driving,take picture of driver' license"
                return cell
                
            case Sections.sectionTwo.rawValue:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextFieldCell.reuseIdentifier, for: indexPath) as? TextFieldCell else {fatalError(TextFieldCell.reuseIdentifier)}
                
                cell.placeHolderr = item as? String
                cell.textField.delegate = self
                
                if indexPath.item == 3 {
                    
                    cell.textField.keyboardType = .numberPad
                }else if indexPath.item == 5 {
                    
                    cell.textField.isSecureTextEntry = true
                    cell.textField.rightViewMode = .always
                    cell.textField.rightView = self.showOrHideButton
                }
                
                return cell
                
            case Sections.sectionThree.rawValue:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ButtonCell.reuseIdentifier, for: indexPath) as? ButtonCell else {fatalError( ButtonCell.reuseIdentifier)}
                
                cell.configureCell(item as? IconMenu)
                
                cell.backgroundColor = .systemBackground
                cell.layer.masksToBounds = true
                cell.layer.cornerRadius = 15
                
                return cell
                
            default:
                return UICollectionViewCell()
            }
        }
        
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderReusableView.reuseIdentifier, for: indexPath) as? HeaderReusableView else {fatalError()}
            
            sectionHeader.headerLabel.isUserInteractionEnabled = true
            sectionHeader.headerLabel.addGestureRecognizer(self.didTapPolicyAndTerms)
            
            sectionHeader.headerLabel.setDifferentColor(string: self.policyString, location: 37, length: 32)
            
            return sectionHeader
        }
    }
    
    func reloadData(){
        
        var snapShot = NSDiffableDataSourceSnapshot<Sections,AnyHashable>()
        
        snapShot.appendSections([.sectionOne,.sectionTwo,.sectionThree])
        
        let value = self.isDriving ? [image] : []
        
        let newValue = self.isDriving ? DriverplaceHolder : SignUpplaceHolder
        
        snapShot.appendItems(value,toSection: .sectionOne)
        snapShot.appendItems(newValue,toSection: .sectionTwo)
        snapShot.appendItems(iconMenu,toSection: .sectionThree)
        
        dataSource?.apply(snapShot)
    }
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout{ sectionIndex, layoutEnvironment in
            
            guard let sectionType = Sections(rawValue: sectionIndex) else {fatalError()}
            
            switch sectionType {
                
            case Sections.sectionOne: return self.createProfileSection()
            case .sectionTwo:return self.createTextFieldsSection()
            case .sectionThree:return self.createButtonssSection()
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 50
        layout.configuration = config
        
        return layout
    }
    
    func createProfileSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(150))
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        
        return layoutSection
    }
    
    func createTextFieldsSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 0, bottom: 0, trailing: 0)
        
        let nestedHorizontalItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/2), heightDimension: .fractionalHeight(1))
        
        let nestedHorizontalGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let nestedHorizontalItem = NSCollectionLayoutItem(layoutSize: nestedHorizontalItemSize)
        
        let nestedHorizontalGroup  = NSCollectionLayoutGroup.horizontal(layoutSize: nestedHorizontalGroupSize, repeatingSubitem: nestedHorizontalItem, count: 2)
        nestedHorizontalGroup.interItemSpacing = .fixed(40)
        
        let nestedVerticalGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(55))
        let nestedVerticalGroup =  NSCollectionLayoutGroup.vertical(layoutSize: nestedVerticalGroupSize, subitems: [nestedHorizontalGroup,layoutItem,nestedHorizontalGroup,layoutItem,layoutItem,layoutItem])
        
        nestedVerticalGroup.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 30)
        
        let section = NSCollectionLayoutSection(group: nestedVerticalGroup)
        
        return section
    }
    
    func createButtonssSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        
        layoutSection.contentInsets = NSDirectionalEdgeInsets(top:0, leading:20, bottom:30, trailing: 20)
        
        let layoutSectionFooter = createSectionFooter()
        layoutSection.boundarySupplementaryItems = [layoutSectionFooter]
        
        return layoutSection
    }
    
    func createSectionFooter() -> NSCollectionLayoutBoundarySupplementaryItem {
        
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.88), heightDimension: .estimated(50))
        
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHeaderSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
        
        return layoutSectionHeader
    }
    
    @objc func didTapPolicyAndTermsButton(){
        
        let taskHistoryVC = TaskHistoryViewController()
        taskHistoryVC.navigationItem.rightBarButtonItem?.isHidden = true
        taskHistoryVC.title = "Privacy Policy"
        
        let storageRef = Storage.storage().reference(withPath: "policy")
        
        storageRef.getData(maxSize:17065) { data, error in
            
            if let data = data {
                
                let decodedData =  try? JSONDecoder().decode(Policy.self, from: data)
                taskHistoryVC.policyString = decodedData?.policy
            }
            
            taskHistoryVC.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "multiply.circle")?.withTintColor(.label, renderingMode: .alwaysOriginal), style: .done, target: self, action: #selector(self.didTapBackXButton))
            
            let settingVCNav = UINavigationController(rootViewController: taskHistoryVC)
            
            
            self.present(settingVCNav, animated: true)
        }
    }
    
    @objc func didTapBackXButton(){
        dismiss(animated: true)
    }
    
    @objc func didTapBackButton(){
        navigationController?.popViewController(animated: false)
    }
    
    @objc func didTapSwitchButton(_ sender:UISwitch){
        
        self.isDriving = sender.isOn
        self.reloadData()
    }
    
    @objc func didTapSignUpButton(){
        
        var personInfo = PersonInfo()
        
        for item in 0..<collectionView.numberOfItems(inSection: 1){
            
            let indexPath = NSIndexPath(item: item, section: 1)
            
            let cell = collectionView.cellForItem(at: indexPath as IndexPath) as! TextFieldCell
            
            switch item {
                
            case 0:personInfo.firstName = cell.textField.text!
            case 1:personInfo.lastName = cell.textField.text!
            case 2:personInfo.email = cell.textField.text!.trimmingCharacters(in: .whitespaces)
            case 3:personInfo.phone = cell.textField.text!
            case 4:personInfo.password = cell.textField.text!
            case 5:personInfo.fullName = cell.textField.text!
            case 6:personInfo.midName = cell.textField.text!
                
            default:
                cell.backgroundColor = .systemRed
            }
        }
        
        
        //        if isDriving {
        //            if let firstName = personInfo.firstName,let lastName = personInfo.lastName,let email = personInfo.email,let phone = personInfo.phone,let password = personInfo.password,let carModel = personInfo.fullName,let policyNum = personInfo.midName {
        //
        //                if firstName.count > 0,lastName.count > 0,email.count > 0,phone.count > 0,password.count > 0,carModel.count > 0,policyNum.count > 0{
        //
        //                }
        //            }
        //        }else{
        //            if let firstName = personInfo.firstName,let lastName = personInfo.lastName,let email = personInfo.email,let phone = personInfo.phone,let password = personInfo.password{
        //
        //                if firstName.count > 0,lastName.count > 0,email.count > 0,phone.count > 0,password.count > 0{
        //                    print(personInfo)
        //                }
        //            }
        //        }
        
        handleRegister(personInfo)
        
    }
    
    @objc func didTappedCameraButton(){
        
        CameraManager.shared.showActionSheet(vc: self)
        CameraManager.shared.imagePickedBlock = { image in
            self.image = image
            self.reloadData()
        }
    }
    
    func handleRegister(_ personInfo: PersonInfo){
        
        //        Auth.auth().createUser(withEmail: personInfo.email, password: personInfo.password) {
        //            user, error in
        //
        //            if let error = error as? AuthErrorCode {
        //                switch error.code {
        //                case .emailAlreadyInUse:
        //
        //                    NotificationBanner.show(BannerData(icon: "person.fill.xmark", title: "Email already used", detail: "Please choose a different email adress", typeBanner: .Error))
        //                case .invalidEmail:
        //
        //                    NotificationBanner.show(BannerData(icon: "person.fill.xmark", title: "Email is invalid", detail: "Please enter a valid email", typeBanner: .Error))
        //                case .weakPassword:
        //
        //                    NotificationBanner.show(BannerData(icon: "person.fill.xmark", title: "Weak Password", detail: "Please Choose a longer Password", typeBanner: .Error))
        //                default:
        //                    break
        //                }
        //
        //                return
        //            }
        //
        //            print("Successfully authenticated user!")
        //
        //            // save it to Firebase database
        //            let img_name = NSUUID().uuidString
        //            let storageRef = Storage.storage().reference(withPath: "profile_images/\(img_name).jpg")
        //            let uploadData = UIImage(named: "food3")?.pngData()
        //
        //            storageRef.putData(uploadData!, completion: { (metadata, e) in
        //
        //                if e != nil {print ("Error: \(String(describing: e?.localizedDescription))")
        //                    return}
        //
        //                storageRef.downloadURL(completion: { url, err in
        //
        //                    guard let profileImageUrl = url else {print (err!)
        //                        return}
        //
        //                    let name = "\(personInfo.firstName) \(personInfo.lastName)"
        //
        //                    let values = ["name": name, "email": personInfo.email, "profileImageUrl": profileImageUrl.absoluteString]
        //                    self.registerUserIntoDatabase(uid: (user?.user.uid)!, values: values )
        //                })
        //            })
        //        }
    }
    
    
    func registerUserIntoDatabase (uid: String, values: [String: Any]) {
        
        //        var usersReference = Database.database().reference().child("users").child(uid)
        //
        //        usersReference.setValue(values) { (error, ref) in
        //
        //            if error != nil {print (error?.localizedDescription as Any)
        //                return}
        //
        //            print("Save user successfully to Firebase database!")
        //            self.navigationController?.popToRootViewController(animated: false)
        //        }
    }
    
    func userLogin(){
        
        let taskVC = UINavigationController(rootViewController: TaskViewController())
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(taskVC)
    }
    
    @objc func didTapOutsideOfTextField(){
        view.endEditing(true)
    }
    
    @objc func didTapHideOrShowButton(_ sender: UIButton){
        
        sender.isSelected = !sender.isSelected
        
        let indexPath = IndexPath(item: 4, section: 1)
        
        let cell = collectionView.cellForItem(at: indexPath) as? TextFieldCell
        
        if sender.isSelected {
            
            cell?.textField.isSecureTextEntry = sender.isSelected
            
            showOrHideButton.setTitle("show", for: .normal)
            
        }else{
            
            cell?.textField.isSecureTextEntry = sender.isSelected
            
            showOrHideButton.setTitle("hide", for: .normal)
        }
        reloadData()
    }
}

extension RegisterViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == 0 && indexPath.item == 0 {
            
            CameraManager.shared.showActionSheet(vc: self)
            CameraManager.shared.imagePickedBlock = { image in
                
                self.image = image
                self.reloadData()
            }
        }
        
        if indexPath.section == 2 && indexPath.item == 0 {didTapSignUpButton()}
    }
}

extension RegisterViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let indexPath = IndexPath(item: 2, section:1)
        let SecondindexPath = IndexPath(item: 3, section:1)
        
        let cell = collectionView.cellForItem(at: indexPath) as! TextFieldCell
        let cellfsl = collectionView.cellForItem(at: SecondindexPath) as! TextFieldCell
        
        if textField == cell.textField {
            
            guard let email = textField.text else { return false }
            
        } else if SecondindexPath.item == 3 && textField == cell.textField{
            
            let str = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            
            return checkEnglishPhoneNumberFormat(string: string, str: str)
        }
        
        return true
    }
    
    func checkEnglishPhoneNumberFormat(string: String?, str: String?) -> Bool{
        
        let indexPath = IndexPath(item: 3, section: 1)
        
        let visibleCell = self.collectionView.cellForItem(at: indexPath) as? TextFieldCell
        
        guard let visibleCell = visibleCell else {fatalError()}
        
        if string == ""{ //BackSpace
            
            return true
            
        }else if str!.count < 3{
            
            if str!.count == 1{
                
                visibleCell.textField.text = "("
            }
            
        }else if str!.count == 5{
            
            visibleCell.textField.text = visibleCell.textField.text! + ") "
            
        }else if str!.count == 10{
            
            visibleCell.textField.text = visibleCell.textField.text! + "-"
            
        }else if str!.count > 14{
            
            return false
        }
        
        number += string ?? ""
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        for item in 0..<collectionView.numberOfItems(inSection: 1){
            
            let indexPath = NSIndexPath(item:item , section: 1)
            
            let cell = collectionView.cellForItem(at: indexPath as IndexPath) as! TextFieldCell
            
            if textField == cell.textField {
                textField.resignFirstResponder()
            }
        }
        return true
    }
}
