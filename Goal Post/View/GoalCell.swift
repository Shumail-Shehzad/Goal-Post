//
//  GoalCell.swift
//  Goal Post
//
//  Created by Sanwal on 21/08/2026.
//

import UIKit

class GoalCell: UITableViewCell {
    
    @IBOutlet var Descriptionlbl: UILabel!
    @IBOutlet var Typelbl: UILabel!
    @IBOutlet var Progresslbl: UILabel!
    @IBOutlet var CompletionView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    func configureCell(goal: Goal) {
        self.Descriptionlbl.text = goal.goalDescription
        self.Typelbl.text = goal.goalType
        self.Progresslbl.text = String(goal.goalProgress) // or String(describing: goal.goalProgress)
        if goal.goalProgress == goal.goalCompletionValue{
            self.CompletionView.isHidden = false
        } else{
            self.CompletionView.isHidden = true
        }
    }
}
