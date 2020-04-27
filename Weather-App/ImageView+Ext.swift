//
//  ImageView+Ext.swift
//  Weather-App
//
//  Created by Kevin Tanner on 4/27/20.
//  Copyright © 2020 Kevin Tanner. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func startAnimation(imageView: UIImageView, images: [UIImage]) {
        imageView.animationImages = images
        imageView.animationDuration = 1.0
        imageView.animationRepeatCount = 0
        imageView.startAnimating()
    }
    
    func stopAnimation(imageView: UIImageView) {
        imageView.stopAnimating()
    }
}
