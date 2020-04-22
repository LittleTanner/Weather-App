//
//  StyleGuide.swift
//  Weather-App
//
//  Created by Kevin Tanner on 4/22/20.
//  Copyright © 2020 Kevin Tanner. All rights reserved.
//

import UIKit

class StyleGuide {
    
    static let cornerRadius: CGFloat = 10
}

extension UIColor {
    static let blackLabel = UIColor(named: "blackLabel")!
    static let greyLabel = UIColor(named: "greyLabel")!
    static let collectionCellBackground = UIColor(named: "collectionCellBackground")!
    static let blueBackground = UIColor(named: "blueBackground")!
}

class ActionButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func configure() {
        
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = StyleGuide.cornerRadius
        backgroundColor = .blueBackground
        setTitleColor(.white, for: .normal)
    }
}
