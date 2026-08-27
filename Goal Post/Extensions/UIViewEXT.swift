//
//  UIViewEXT.swift
//  Goal Post
//
//  Created by Sanwal on 23/08/2026.
//

import UIKit

extension UIViewController {
    func presentDetail(_ viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = .push
        transition.subtype = .fromRight
        
        // THIS FIXES THE GAP: Force full screen presentation style
        viewControllerToPresent.modalPresentationStyle = .fullScreen
        
        self.view.window?.layer.add(transition, forKey: CATransitionType.push.rawValue)
        
        present(viewControllerToPresent, animated: false, completion: nil)
    }
    func presentSecondaryDetail(_ viewControllerToPresent: UIViewController){
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = .push
        transition.subtype = .fromRight
        //This fixes the gap and show full screen 
        viewControllerToPresent.modalPresentationStyle = .fullScreen
        
        guard presentedViewController != nil else { return }
        self.dismiss(animated: false) {
            self.view.window?.layer.add(transition, forKey: CATransitionType.push.rawValue)
            self.present(viewControllerToPresent, animated: false, completion: nil)
        }
    }
    
    func dismissDetail() {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = .push
        transition.subtype = .fromLeft
        self.view.window?.layer.add(transition, forKey: CATransitionType.push.rawValue)
        
        dismiss(animated: false, completion: nil)
    }
}

