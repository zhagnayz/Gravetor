//
//  ClientInfoCell.swift
//  GravetonDriver
//
//  Created by Daniel Zhagany Zamora on 2/26/23.
//

import UIKit
import MapKit
import CoreLocation

class ClientInfoCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = "ClientInfoCell"
    
    let mapView: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    let BoxLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.textAlignment = .center
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.layer.masksToBounds = true
        dateLabel.layer.cornerRadius = 3
        dateLabel.backgroundColor = .tertiaryLabel
        return dateLabel
    }()
    
    let emailButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "fork.knife")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal), for: .normal)
        return button
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16,weight: .semibold)
        label.textColor = .gray
        return label
    }()
    
    let phoneButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "phone.fill")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal), for: .normal)
        return button
    }()
    
    let phoneLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16,weight: .semibold)
        label.textColor = .gray
        return label
    }()
    
    let addressImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "mappin")
        image.setImageTintColor(.lightGray)
        return image
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16,weight: .semibold)
        return label
    }()
    
    let dateImageView: UIImageView = {
        let image = UIImageView()
        image.image =  UIImage(systemName: "clock")
        image.setImageTintColor(.lightGray)
        return image
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16,weight: .semibold)
        label.textColor = .gray
        return label
    }()
    
    let lineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    override init(frame:CGRect){
        super.init(frame: frame)
        
        let stackViewOne = UIStackView(arrangedSubviews: [BoxLabel,lineView])
        let stackViewTwo = UIStackView(arrangedSubviews: [emailButton,emailLabel])
        let stackViewThree = UIStackView(arrangedSubviews: [phoneButton,phoneLabel])
        
        let stackViewFour = UIStackView(arrangedSubviews: [stackViewTwo,stackViewThree])
        stackViewFour.distribution = .equalSpacing
        
        let stackViewFive = UIStackView(arrangedSubviews: [addressImageView,addressLabel])
        
        let stackViewSix = UIStackView(arrangedSubviews: [dateImageView,dateLabel])
        
        let stackViewSeven = UIStackView(arrangedSubviews: [stackViewOne,stackViewFour,stackViewFive,stackViewSix])
        stackViewSeven.axis = .vertical
        stackViewSeven.spacing = 10
        
        let stackView = UIStackView(arrangedSubviews: [mapView,stackViewSeven])
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            mapView.heightAnchor.constraint(equalToConstant: 250),
        ])
    }
    
    func configureCell(_ user:User?){
        
        if let seconds = user?.timestamp {
            let timestamp_date = Date(timeIntervalSince1970: seconds)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yy hh:mm a"
            self.dateLabel.text = dateFormatter.string(from: timestamp_date)
        }
    }
    
    func mapFunction(_ address:String?){
        
        if let address = address {
            
            LocationManager.shared.getReverseGeoCodedLocation(address: address) { location, placemark, error in
                
                if let location = location {
                    
                    let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                    
                    let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002))
                    
                    let pin = MKPointAnnotation()
                    pin.coordinate = center
                    pin.title = ""
                    
                    self.mapView.addAnnotation(pin)
                    self.mapView.setRegion(region, animated: false)
                }
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
