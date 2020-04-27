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

    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
    }
    
    @IBAction func allowButtonTapped(_ sender: UIButton) {
        locationManager.requestWhenInUseAuthorization()
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
