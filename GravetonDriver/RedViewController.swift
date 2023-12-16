//
//  RedViewController.swift
//  GravetonDriver
//
//  Created by Daniel Zhagany Zamora on 3/21/23.
//

import UIKit

class FilterPresentationController: UIPresentationController {
    
    var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
    
    var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0
        return view
    }()
    
    var yHeight: Double = 0.5
    var containerHeight: Double = 0.6
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
                
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissController))
        backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.backgroundView.isUserInteractionEnabled = true
        self.backgroundView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        
        CGRect(origin: CGPoint(x: 0, y: self.containerView!.frame.height * yHeight),
               size: CGSize(width: self.containerView!.frame.width, height: self.containerView!.frame.height *
                            containerHeight))
    }
    
    override func presentationTransitionWillBegin() {
        
        self.containerView?.addSubview(backgroundView)
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { UIViewControllerTransitionCoordinatorContext in
            
            self.backgroundView.alpha = 0.7
        },completion: { (UIViewControllerTransitionCoordinatorContext) in })
    }
    
    override func dismissalTransitionWillBegin() {
        
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            self.backgroundView.alpha = 0
        }, completion: { (UIViewControllerTransitionCoordinatorContext) in
            self.backgroundView.removeFromSuperview()
        })
    }
    
    override func containerViewWillLayoutSubviews() {
        
        super.containerViewWillLayoutSubviews()
        
        presentedView!.roundCorners(corners: [.topLeft, .topRight], radius: 6)
    }
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        presentedView?.frame = frameOfPresentedViewInContainerView
        backgroundView.frame = containerView!.bounds
    }
    
    @objc func dismissController(){
        self.presentedViewController.dismiss(animated: true, completion: nil)
    }
}

extension UIView {
    
  func roundCorners(corners: UIRectCorner, radius: CGFloat) {
      let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners,
                              cornerRadii: CGSize(width: radius, height: radius))
      let mask = CAShapeLayer()
      mask.path = path.cgPath
      layer.mask = mask
  }
}
