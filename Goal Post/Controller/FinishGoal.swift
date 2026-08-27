//
//  FinishGoal.swift
//  Goal Post
//
//  Created by Sanwal on 24/08/2026.
//

import UIKit
import CoreData
class FinishGoal: UIViewController, UITextFieldDelegate {
    // MARK: - Properties
    var goalDescription: String!
    var goalType: GoalType!
    
    @IBOutlet var textfield: UITextField!
    @IBOutlet var Createbtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Createbtn.bindToKeyboard()
        textfield.delegate = self
    }
    
    func initData(description: String, type: GoalType) {
        self.goalDescription = description
        self.goalType = type
    }
    
    @IBAction func createButtonTapped(_ sender: UIButton) {
        if textfield.text != ""{
            self.save{ (complete) in
                if complete{
                    dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func Backbtn(_ sender: UIButton) {
        dismissDetail()
    }
    func save(completion: (_ finished: Bool) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            completion(false)
            return
        }
        let manageContext = appDelegate.persistentContainer.viewContext
        let goal = Goal(context: manageContext)
        
        goal.goalDescription = goalDescription
        goal.goalType = goalType.rawValue
        goal.goalCompletionValue = Int32(textfield.text ?? "0") ?? 0
        goal.goalProgress = Int32 (0)
        
        do{
           try manageContext.save()
            completion(true)
        } catch{
            debugPrint("Could not save: \(error.localizedDescription)")
            completion(false)
        }
            
    }
    
}
