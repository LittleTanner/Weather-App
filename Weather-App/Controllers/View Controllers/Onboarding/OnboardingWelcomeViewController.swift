//
//  OnboardingWelcomeViewController.swift
//  Weather-App
//
//  Created by Kevin Tanner on 4/21/20.
//  Copyright © 2020 Kevin Tanner. All rights reserved.
//

import UIKit

class OnboardingWelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func actionButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: Constants.mainStoryboard, bundle: nil)
        guard let vc = storyboard.instantiateViewController(identifier: Constants.onboardingAllowLocationViewControllerID) as? OnboardingAllowLocationViewController else { return }
        vc.modalPresentationStyle = .fullScreen
        presentVCFromRight(vc)
    }
}
