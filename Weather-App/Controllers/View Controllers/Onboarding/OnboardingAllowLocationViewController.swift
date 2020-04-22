//
//  OnboardingAllowLocationViewController.swift
//  Weather-App
//
//  Created by Kevin Tanner on 4/21/20.
//  Copyright © 2020 Kevin Tanner. All rights reserved.
//

import UIKit
import CoreLocation

class OnboardingAllowLocationViewController: UIViewController, CLLocationManagerDelegate {

    var locationManager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
    }
    
    @IBAction func allowButtonTapped(_ sender: UIButton) {
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        WeatherManager.shared.allowsLocation = true
        let storyboard = UIStoryboard(name: Constants.mainStoryboard, bundle: nil)
        guard let vc = storyboard.instantiateViewController(identifier: Constants.onboardingAddLocationViewControllerID) as? OnboardingAddLocationViewController else { return }
        vc.modalPresentationStyle = .fullScreen
        
        presentVCFromRight(vc)
        
        
    }
    
    @IBAction func notNowButtonTapped(_ sender: UIButton) {
        WeatherManager.shared.allowsLocation = false
        let storyboard = UIStoryboard(name: Constants.mainStoryboard, bundle: nil)
        guard let vc = storyboard.instantiateViewController(identifier: Constants.onboardingAddLocationViewControllerID) as? OnboardingAddLocationViewController else { return }
        vc.modalPresentationStyle = .fullScreen
        
        presentVCFromRight(vc)
    }
}
