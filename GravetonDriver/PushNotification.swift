//
//  PushNotification.swift
//  GravetonDriver
//
//  Created by Daniel Zhagany Zamora on 3/27/23.
//

import Foundation
import UIKit
import MapKit

class PushNotification {
    
    var orderId:String?
    
    var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0
        return view
    }()
    
    var alertView: UIView = {
        let view = UIView()
        view.backgroundColor = .tertiarySystemGroupedBackground
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 4
        return view
    }()
    
    let mapView = MKMapView()
    
    let taskDateStringLabel: UILabel = {
        let label = UILabel()
        label.text = "Task Date:"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let taskDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "2"
        label.textColor  = .clear
        return label
    }()
    
    var circleArrow: CircleArrow = {
        let  circleArrow = CircleArrow(frame: CGRect(x: 0, y: 0, width: 30, height: 40))
        circleArrow.backgroundColor = .clear
        circleArrow.translatesAutoresizingMaskIntoConstraints = false
        return circleArrow
    }()
    
    let pickUpAddressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16,weight: .medium)
        return label
    }()
    
    let deliveryAddressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18,weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    let taskDistanceString: UILabel = {
        let label = UILabel()
        label.text = "Task Distance"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let taskDistanceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18,weight: .semibold)
        label.textColor = .red
        return label
    }()
    
    let moneyString: UILabel = {
        let label = UILabel()
        label.text = "Graveton Pay"
        label.font = UIFont.systemFont(ofSize: 16,weight: .semibold)
        return label
    }()
    
    let moneyTipExplain: UILabel = {
        let label = UILabel()
        label.text = "(Includes expected tip)"
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    let moneyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: 20,weight: .bold)
        return label
    }()
    
    let rejectButton: UIButton = {
        let button = UIButton()
        button.setTitle("Reject", for: .normal)
        button.backgroundColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let acceptButton: UIButton = {
        let button = UIButton()
        button.setTitle("Aceppt", for: .normal)
        button.backgroundColor = .green
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var myTargetView: UIView?
    
    let getRootView = GetRootView()
    
    func createNotification(_ notificationData: NotificationData){
        
        self.orderId = notificationData.orderId
        
       let targetView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
                
        myTargetView = targetView
        
        let timestamp_date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy hh:mm a"
        self.taskDateLabel.text = dateFormatter.string(from: timestamp_date)
        
        pickUpAddressLabel.text = notificationData.name
        deliveryAddressLabel.text = notificationData.userAddress
        taskDistanceLabel.text = notificationData.formattedDistance
        moneyLabel.text = notificationData.formattedMoney
        
        LocationManager.shared.getReverseGeoCodedLocation(address: notificationData.userAddress) { location, placemark, error in
            
            self.locationMapPin(location)
        }
        
        backgroundView.frame = targetView.bounds
        backgroundView.alpha = 0.7
        
        let superView = getRootView.getRootView()
        superView.addSubview(backgroundView)
        superView.addSubview(alertView)
        
        alertView.frame = CGRect(x: 0, y: 0, width: backgroundView.frame.size.width - 40, height: 400)
        alertView.center = backgroundView.center
        
        let stackViewTwo = UIStackView(arrangedSubviews: [taskDateStringLabel,taskDateLabel])
        
        let stackViewThree = UIStackView(arrangedSubviews: [emptyLabel,circleArrow])
        stackViewThree.axis = .vertical
        
        let stackViewFour = UIStackView(arrangedSubviews: [pickUpAddressLabel,deliveryAddressLabel])
        stackViewFour.axis = .vertical
        stackViewFour.spacing = 15
        
        let stackViewFive = UIStackView(arrangedSubviews: [stackViewThree,stackViewFour])
        stackViewFive.spacing = 5
        
        let test = UIStackView(arrangedSubviews: [moneyString,moneyTipExplain])
        test.axis = .vertical
        
        let stackViewSix = UIStackView(arrangedSubviews: [taskDistanceString,test])
        
        let stackViewSeven = UIStackView(arrangedSubviews: [taskDistanceLabel,moneyLabel])
        
        let stackViewEight = UIStackView(arrangedSubviews: [rejectButton,acceptButton])
        stackViewEight.distribution = .fillEqually
        
        let stackView = UIStackView(arrangedSubviews: [mapView,stackViewTwo,stackViewFive,stackViewSix,stackViewSeven,stackViewEight])
        stackView.axis = .vertical
        stackView.spacing = 5
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        alertView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: alertView.leadingAnchor,constant: 2),
            stackView.topAnchor.constraint(equalTo: alertView.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: alertView.trailingAnchor,constant: -2),
            stackView.bottomAnchor.constraint(equalTo: alertView.bottomAnchor,constant: -1),
            circleArrow.widthAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func locationMapPin(_ location:CLLocation?) {
        
        if let location = location {
            
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002))
            
            self.mapView.setRegion(region, animated: false)
            self.addPinToMap(location)
        }
    }
    
    func addPinToMap(_ location:CLLocation){
        let pinLocation : CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let objectAnnotation = MKPointAnnotation()
        objectAnnotation.coordinate = pinLocation
        objectAnnotation.title = ""
        self.mapView.addAnnotation(objectAnnotation)
    }
    
    func removeOrderCustomView(){
        
        guard let _ = myTargetView else {return}
        
        UIView.animate(withDuration: 0.25, animations: {
            
            self.backgroundView.alpha = 0.0
            self.alertView.removeFromSuperview()
        })
    }
}
