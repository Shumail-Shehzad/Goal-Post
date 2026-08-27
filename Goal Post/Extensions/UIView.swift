//
//  UIView.swift
//  Goal Post
//
//  Created by Sanwal on 24/08/2026.
//

import UIKit

extension UIView {
    func bindToKeyboard() {
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillChange(_:)),
        name: UIResponder.keyboardWillChangeFrameNotification,object: nil
        )
    }

    @objc private func keyboardWillChange(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue,
            let curveRaw = (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.uintValue,
            let targetFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else { return }

        // Determine screen height from context to avoid deprecated UIScreen.main
        let screenHeight: CGFloat
        if let screen = self.window?.windowScene?.screen {
            screenHeight = screen.bounds.height
        } else if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            screenHeight = scene.screen.bounds.height
        } else {
            // Fallback: use current bounds height if no window/scene yet
            screenHeight = self.bounds.height
        }

        // Determine if keyboard is showing based on screen height comparison
        let isShowing = targetFrame.origin.y < screenHeight

        // Calculate the exact offset needed to sit directly above the keyboard
        let translationY = isShowing ? -(screenHeight - targetFrame.origin.y) : 0

        let options = UIView.AnimationOptions(rawValue: curveRaw << 16)

        UIView.animate(withDuration: duration, delay: 0.0, options: options, animations: {
            self.transform = CGAffineTransform(translationX: 0, y: translationY)
        }, completion: nil)
    }
}
