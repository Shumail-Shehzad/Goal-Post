//
//  CreateGoal.swift
//  Goal Post
//
//  Created by Sanwal on 22/08/2026.
//

import UIKit

class CreateGoal: UIViewController, UITextViewDelegate {
    @IBOutlet var textview: UITextView!
    @IBOutlet var Shortbtn: UIButton!
    @IBOutlet var Longbtn: UIButton!
    @IBOutlet var Nextbtn: UIButton!
    
    var goaltype: GoalType = .shortTerm
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Ensures full screen presentation without page-sheet top gap
        self.modalPresentationStyle = .fullScreen

        Nextbtn.bindToKeyboard()
        Shortbtn.setSelectedColor()
        Longbtn.setDeselectedColor()
        textview.delegate = self
        
        // Setup tap gesture to dismiss keyboard when tapping outside elements
        setupTapGesture()
    }
    
    private func setupTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func Shortbtn(_ sender: UIButton) {
        view.endEditing(true) // Dismisses keyboard & returns Next button to baseline
        goaltype = .shortTerm
        Shortbtn.setSelectedColor()
        Longbtn.setDeselectedColor()
    }
    
    @IBAction func Longbtn(_ sender: UIButton) {
        view.endEditing(true) // Dismisses keyboard & returns Next button to baseline
        goaltype = .longTerm
        Longbtn.setSelectedColor()
        Shortbtn.setDeselectedColor()
    }

    @IBAction func Nextbtn(_ sender: UIButton) {
        if let text = textview.text, !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty, text != "What is your goal?" {
            guard let finishGoalVC = storyboard?.instantiateViewController(withIdentifier: "FinishGoal") as? FinishGoal else { return }

            view.endEditing(true)
            finishGoalVC.initData(description: text, type: goaltype)
            presentingViewController?.presentSecondaryDetail(finishGoalVC)
        }
    }

    @IBAction func Backbtn(_ sender: UIButton) {
        view.endEditing(true)
        dismissDetail()
    }

    // MARK: - UITextViewDelegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "What is your goal?" {
            textView.text = ""
            textView.textColor = UIColor.label
        }
    }
}
