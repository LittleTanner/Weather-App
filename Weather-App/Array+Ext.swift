//
//  Array+Ext.swift
//  Weather-App
//
//  Created by Kevin Tanner on 4/27/20.
//  Copyright © 2020 Kevin Tanner. All rights reserved.
//

import UIKit

extension Array {
    
    func createImageArray(total: Int, imagePrefix: String) -> [UIImage] {
        var imageArray: [UIImage] = []
        
        for imageCount in 0..<total {
            let imageName = "\(imagePrefix)-\(imageCount).png"
            let image = UIImage(named: imageName)!
            
            imageArray.append(image)
        }
        
        return imageArray
    }
}
