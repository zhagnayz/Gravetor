//
//  TaskViewController.swift
//  GravetonDriver
//
//  Created by Daniel Zhagany Zamora on 2/26/23.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class TaskViewController: UIViewController {
    
    private let emptyValues = Policy(title: "🛒", subTitle: "No Task Assigment Yet", policy: "You have no tasks assigned or your all tasks were completed. We'll notify you when new tasks arrive")
    
    private let url = "https://www.facebook.com/daniel.zhagnay"
    
    private var pushNotification = PushNotification()
    
    private lazy var segmentedController: UISegmentedControl = {
        let segmentedConrol = UISegmentedControl(items: ["Today's Task","All Task No"])
        segmentedConrol.layer.cornerRadius = 20
        segmentedConrol.layer.borderWidth = 0.5
        segmentedConrol.layer.borderColor = UIColor.tertiarySystemGroupedBackground.cgColor
        segmentedConrol.backgroundColor = .systemBackground
        segmentedConrol.selectedSegmentIndex = 0
        segmentedConrol.addTarget(self, action: #selector(didTapsegmentedController(_:)), for: .valueChanged)
        segmentedConrol.selectedSegmentTintColor = .secondarySystemFill
        segmentedConrol.layer.masksToBounds = true
        return segmentedConrol
    }()
    
    var notificationAddress = NotificationData(orderId: "8b8", name: "Thai Bloom", restAddress: "3024 Hennepin Ave, Minneapolis, MN 55408", userAddress: "2504 Girard Ave South Minneapolis,MN 55408", distance: 2.3, money: 4.50)
    
    var users:[User] = []
    
    enum Sections: Int{
        case sectionOne
        case sectionTwo
    }
    
    var collectionView: UICollectionView!
    
    var dataSource: UICollectionViewDiffableDataSource<Sections,AnyHashable>?
    
    private var sideMenuViewController = AccountViewController()
    private var sideMenuRevealWidth: CGFloat = 420
    private let paddingForRotation: CGFloat = 150
    private var isExpanded: Bool = false
    private var sideMenuTrailingConstraint: NSLayoutConstraint!
    private var revealSideMenuOnTop: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.titleView = segmentedController
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.dash")?.withTintColor(.label, renderingMode: .alwaysOriginal), style: .done, target: self, action: #selector(didTapListDashButton))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "admin", style: .done, target: self, action: #selector(didTapView))
        
        collectionView = UICollectionView(frame: view.bounds,collectionViewLayout: createCompositionalLayout())
        
        collectionView.backgroundColor = .secondarySystemBackground
        
        view.addSubview(collectionView)
        
        collectionView.register(DropCell.self, forCellWithReuseIdentifier: DropCell.reuseIdentifier)
        collectionView.register(SideMenuCell.self, forCellWithReuseIdentifier: SideMenuCell.reuseIdentifier)
        
        pushNotification.rejectButton.addTarget(self, action: #selector(didTapRejectButton), for: .touchUpInside)
        pushNotification.acceptButton.addTarget(self, action: #selector(didTapAcceiptButton), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveUpdate), name: AppDataManager.orderUpdateNotification, object: nil)
        
        setUpSideBarMenu()
        
        createData()
        reloadData()
    }
    
    func createData(){
        
        dataSource = UICollectionViewDiffableDataSource<Sections,AnyHashable>(collectionView:collectionView){
            collectionView,indexPath, item in
            
            switch indexPath.section {
                
            case Sections.sectionOne.rawValue:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DropCell.reuseIdentifier, for: indexPath) as? DropCell else {fatalError()}
                
                cell.configureCell(self.users[indexPath.item].driverInfo)
                
                cell.buttonPanelView.completion = { item in
                    
                    switch item {
                    case .minus: self.pickUpFood(indexPath)
                    case .plus: self.deliveryFood(indexPath)
                    }
                }
                
                return cell
                
            case Sections.sectionTwo.rawValue:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SideMenuCell.reuseIdentifier, for: indexPath) as? SideMenuCell else {fatalError()}
                
                cell.layer.borderColor = UIColor.clear.cgColor
                
                let value = item as! Policy
                cell.imageLabel.text = value.title
                cell.titleLabel.text = value.subTitle
                cell.subTitle.text = value.policy
                
                return cell
                
            default: return UICollectionViewCell()
            }
        }
    }
    
    func reloadData(){
        
        var snapShot = NSDiffableDataSourceSnapshot<Sections,AnyHashable>()
        
        defer{dataSource?.apply(snapShot)}
        
        snapShot.appendSections([Sections.sectionOne,Sections.sectionTwo])
        
        guard !users.isEmpty else{
            
            snapShot.appendItems([emptyValues],toSection: Sections.sectionTwo)
            return
        }
        
        for user in users {
            snapShot.appendItems([user.driverInfo],toSection: Sections.sectionOne)
        }
    }
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { sectionIndex,layoutEnvironment in
            
            guard let sectionType = Sections(rawValue: sectionIndex) else {fatalError()}
            
            switch sectionType {
                
            case .sectionOne: return self.createSectionDriver()
            case .sectionTwo: return self.createEmptySection()
            }
        }
        return layout
    }
    
    func createSectionDriver() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(180))
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 10, bottom: 0, trailing: 10)
        return layoutSection
    }
    
    func createEmptySection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(150))
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        
        layoutSection.contentInsets = NSDirectionalEdgeInsets(top: view.frame.size.height/3, leading: 10, bottom: 0, trailing: 10)
        
        return layoutSection
    }
    
    @objc func didTapsegmentedController(_ sender:UISegmentedControl){
        
        if sender.selectedSegmentIndex == 0 {
            
        }else{
            
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            
            let content = UNMutableNotificationContent()
            content.title = "Task Notification"
            content.body = "You Have Task Offer!"
            content.sound = .default
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            center.add(request)
            
        }
    }
    
    @objc func didReceiveUpdate(){
        
        let users = AppDataManager.shared.users
        self.users = users
        reloadData()
    }
    
    func setUpSideBarMenu(){
        
        self.sideMenuViewController.delegate = self
        view.insertSubview(self.sideMenuViewController.view, at: self.revealSideMenuOnTop ? 2 : 0)
        addChild(self.sideMenuViewController)
        self.sideMenuViewController.didMove(toParent: self)
        
        self.sideMenuViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        if self.revealSideMenuOnTop {
            self.sideMenuTrailingConstraint = self.sideMenuViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -self.sideMenuRevealWidth - self.paddingForRotation)
            self.sideMenuTrailingConstraint.isActive = true
        }
        NSLayoutConstraint.activate([
            self.sideMenuViewController.view.widthAnchor.constraint(equalToConstant: self.sideMenuRevealWidth),
            self.sideMenuViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            self.sideMenuViewController.view.topAnchor.constraint(equalTo: view.topAnchor)
        ])
    }
   
    @objc func didTapListDashButton(){
        self.sideMenuState(expanded: self.isExpanded ? false : true)
    }
    
    func pickUpFood(_ indexPath:IndexPath){
        
        let pickUpVC = PickUpViewController()
        var user = users[indexPath.item]
        user.driverInfo?.pickUpOrDrop = "PickUp"
        pickUpVC.user = user
        navigationController?.pushViewController(pickUpVC, animated: false)
    }
    
    func deliveryFood(_ indexPath:IndexPath){
        
        let DropVC = DropViewController()
        var user = users[indexPath.item]
        user.driverInfo?.pickUpOrDrop = "Drop"
        DropVC.user = user
        navigationController?.pushViewController(DropVC, animated: false)
        AppDataManager.shared.removeUser(users[indexPath.item])
    }
}

extension TaskViewController: SideMenuViewControllerDelegate {
    
    func selectedCell(_ row: Int) {
        
        switch row {
        case 0: break
        case 1: navigationController?.pushViewController(DriverProfileViewController(), animated: false)
        case 2:
            let taskHistoryVC = TaskHistoryViewController()
            taskHistoryVC.title = "Earnings"
            navigationController?.pushViewController(taskHistoryVC, animated: false)
        case 3: break
        case 4:
            
            if let url = URL(string: url), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
            
        default:break
        }
        DispatchQueue.main.async { self.sideMenuState(expanded: false) }
    }
    
    func sideMenuState(expanded: Bool) {
        
        if expanded {
            self.animateSideMenu(targetPosition: self.revealSideMenuOnTop ? 0 : self.sideMenuRevealWidth) { _ in
                self.isExpanded = true
            }
        }else {
            self.animateSideMenu(targetPosition: self.revealSideMenuOnTop ? (-self.sideMenuRevealWidth - self.paddingForRotation) : 0) { _ in
                self.isExpanded = false
            }
        }
    }
    
    func animateSideMenu(targetPosition: CGFloat, completion: @escaping (Bool) -> ()) {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .layoutSubviews, animations: {
            
            if self.revealSideMenuOnTop {
                self.sideMenuTrailingConstraint.constant = targetPosition
                self.view.layoutIfNeeded()
            }else {
                self.view.subviews[1].frame.origin.x = targetPosition
            }
        })
    }
    
    @objc func didTapRejectButton(){
        
        pushNotification.orderId = nil
        pushNotification.removeOrderCustomView()
    }
    
    @objc func didTapAcceiptButton(){
                
        if let orderId = AppDataManager.shared.RestNameAndID.subTitle{
            
            let orderRef = Database.database().reference().child("orders")
            
            orderRef.child(orderId).observeSingleEvent(of: .value, with: { snapshot in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {

                    var user = User()
                    user.orderId = orderId
                    user.fromId = dictionary["fromId"] as? String
                    user.orderStatus = dictionary["orderStatus"] as? String
                    user.orderNum = dictionary["orderNum"] as? String
                    user.timestamp = dictionary["timestamp"] as? Double
                    user.personInfo.fullName = dictionary["personInfo"] as? String

                    var info = DriverInfo()
                    info.restName = AppDataManager.shared.RestNameAndID.title
                    info.PickUpaddress = dictionary["restAddress"] as? String
                    info.Deliveryaddress =  dictionary["userAddress"] as? String
                    
                    user.driverInfo = info

                    if let secondDictionary = dictionary["foods"] as? [[String:Any]]{
                        
                        for orderItemDictionary in secondDictionary {
                            var orderItem = OrderItem()
                            orderItem.name = orderItemDictionary["name"] as? String
                            orderItem.price = orderItemDictionary["price"] as? Double
                            orderItem.protein = orderItemDictionary["protein"] as? [String]
                            orderItem.spiceLevel = orderItemDictionary["spice"] as? String
                            orderItem.addItems = orderItemDictionary["addItems"] as? [String]
                            orderItem.quantity = orderItemDictionary["quantity"] as? Int
                            user.order.orderItem.append(orderItem)
                            AppDataManager.shared.users.append(user)
                        }
                    }
                }
            })
        }
        
//        let food:[String:Any] = ["name":"Pad Thai","protein":"chicken","spice":"xxx","addItems":["carrot ($1.50)","green one ($1.50)","waterchestnut ($1.50)","baby corn ($1.50)"],"quantity":2,"price":14.49]
//        
//        
//        let dictionary:[String:Any] = ["fromId":"X5iyJIj5YvYwtd7KklfiGWgBfIC3","restAddress":"3024 Hennepin Ave, Minneapolis, MN 55408","userAddress":"2504 Girard Ave S, Minneapolis, MN 55405","orderStatus":"pick up","orderNum":"O3435","timestamp":1691282281.806538,"personInfo":"Daniel Zhagnay Zamora","food":food]
//        
//        var user = User()
//        user.orderId = "-NkqnJErtHCNuVe0OHrn"
//        user.fromId = dictionary["fromId"] as? String
//        user.orderStatus = dictionary["orderStatus"] as? String
//        user.orderNum = dictionary["orderNum"] as? String
//        user.timestamp = dictionary["timestamp"] as? Double
//        user.personInfo.fullName = dictionary["personInfo"] as? String
//        
//        var info = DriverInfo()
//        info.restName = "Thai Bloom"
//        info.PickUpaddress = dictionary["restAddress"] as? String
//        info.Deliveryaddress =  dictionary["userAddress"] as? String
//        
//        user.driverInfo = info
//        
//        if let secondDictionary = dictionary["food"] as? [String:Any]{
//            
//            var orderItem = OrderItem()
//            orderItem.name = secondDictionary["name"] as? String
//            orderItem.price = secondDictionary["price"] as? Double
//            orderItem.protein = secondDictionary["protein"] as? [String]
//            orderItem.spiceLevel = secondDictionary["spice"] as? String
//            orderItem.addItems = secondDictionary["addItems"] as? [String]
//            
//            user.order.orderItem.append(orderItem)
//            
//            AppDataManager.shared.users.append(user)
//        }
        
        pushNotification.orderId = nil
        pushNotification.removeOrderCustomView()
        
        saveEarnings(notificationAddress.money)
    }
    
    func saveEarnings(_ amount:Double){
        
        let earnings:[String:Any] = ["timestamp":Date().timeIntervalSince1970,"total":amount]
        
        if let uid = Auth.auth().currentUser?.uid {
            
            let ref = Database.database().reference().child(uid).child("earns")
            
            let uistirng = UUID().uuidString
            ref.child(uistirng).setValue(earnings)
        }
    }
    
    @objc func didTapView(){
            
        let cardVC = CardViewController()
        navigationController?.pushViewController(cardVC, animated: false)
    }
}

extension TaskViewController: UNUserNotificationCenterDelegate  {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        LocationManager.shared.getLocation { location, error in
            
            if error != nil {
                self.navigationItem.title = error!.description
            }
            
            self.pushNotification.createNotification(self.notificationAddress)
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.sound,.banner,.badge])
    }
}
