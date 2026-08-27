//
//  UIButton.swift
//  Goal Post
//
//  Created by Sanwal on 24/08/2026.
//

import UIKit

extension UIButton {
    func setSelectedColor(){
        self.backgroundColor = UIColor.systemGreen
    }
    
    func setDeselectedColor(){
        self.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.3)
    }
}

