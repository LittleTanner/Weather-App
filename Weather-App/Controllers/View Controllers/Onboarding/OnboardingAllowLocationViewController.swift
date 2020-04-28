//
//  OnboardingAllowLocationViewController.swift
//  Weather-App
//
//  Created by Kevin Tanner on 4/21/20.
//  Copyright © 2020 Kevin Tanner. All rights reserved.
//

import UIKit
import CoreLocation

class OnboardingAllowLocationViewController: UIViewController {

    @IBOutlet weak var rightArrow: UIImageView!
    @IBOutlet weak var leftArrow: UIImageView!
    
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        rightArrow.isHidden = true
        leftArrow.isHidden = true
    }
    
    @IBAction func allowButtonTapped(_ sender: UIButton) {
        locationManager.requestWhenInUseAuthorization()
        rightArrow.isHidden = false
        leftArrow.isHidden = false
    }
    
    @IBAction func notNowButtonTapped(_ sender: UIButton) {
        WeatherManager.shared.allowsLocation = false
        let storyboard = UIStoryboard(name: Constants.mainStoryboard, bundle: nil)
        guard let vc = storyboard.instantiateViewController(identifier: Constants.onboardingAddLocationViewControllerID) as? OnboardingAddLocationViewController else { return }
        vc.modalPresentationStyle = .fullScreen
        
        presentVCFromRight(vc)
    }
}

extension OnboardingAllowLocationViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            print("Authorized")
            WeatherManager.shared.allowsLocation = true
            let storyboard = UIStoryboard(name: Constants.mainStoryboard, bundle: nil)
            guard let vc = storyboard.instantiateViewController(identifier: Constants.onboardingAddLocationViewControllerID) as? OnboardingAddLocationViewController else { return }
            vc.modalPresentationStyle = .fullScreen
            
            self.presentVCFromRight(vc)
        }
    }
}
