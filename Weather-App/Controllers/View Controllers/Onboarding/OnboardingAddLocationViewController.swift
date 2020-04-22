//
//  OnboardingAddLocationViewController.swift
//  Weather-App
//
//  Created by Kevin Tanner on 4/21/20.
//  Copyright © 2020 Kevin Tanner. All rights reserved.
//

import UIKit

class OnboardingAddLocationViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Updates the user so the onboarding screne doesn't show again
        WeatherUserDefaults.shared.updateUser()
    }
}

