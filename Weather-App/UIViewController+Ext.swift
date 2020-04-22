//
//  UIViewController+Ext.swift
//  Weather-App
//
//  Created by Kevin Tanner on 4/22/20.
//  Copyright © 2020 Kevin Tanner. All rights reserved.
//

import UIKit


extension UIViewController {
    
    func presentVCFromRight(_ viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.35
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        present(viewControllerToPresent, animated: false, completion: nil)
    }
    
    func presentVCFromLeft(_ viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.35
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        present(viewControllerToPresent, animated: false, completion: nil)
    }
    
    func presentAlert(with title: String, message: String, actionButtonTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionButtonTitle, style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
