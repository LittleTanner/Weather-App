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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Updates the user so the onboarding screen doesn't show again
        WeatherUserDefaults.shared.updateUser()
    }
    
    
    @IBAction func actionButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: Constants.mainStoryboard, bundle: nil)
        guard let vc = storyboard.instantiateViewController(identifier: Constants.weatherPageViewControllerID) as? WeatherPageViewController else { return }
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
}

