//
//  ViewController.swift
//  Goal Post
//
//  Created by Sanwal on 20/08/2026.
//

import UIKit
import CoreData

let appDelegate = UIApplication.shared.delegate as? AppDelegate

class ViewController: UIViewController {
    @IBOutlet var tableview: UITableView!
    
    var goals: [Goal] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        tableview.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCoreDataObjects()
        tableview.reloadData()
    }
    
    func fetchCoreDataObjects() {
        self.fetch { complete in
            if complete {
                tableview.isHidden = goals.isEmpty
            }
        }
    }
    
    @IBAction func GoalBtn(_ sender: UIButton) {
        guard let createGoalVC = storyboard?.instantiateViewController(withIdentifier: "CreateGoal") else {
            return
        }
        presentDetail(createGoalVC)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GoalCell", for: indexPath) as? GoalCell else {
            return UITableViewCell()
        }
        let goal = goals[indexPath.row]
        cell.configureCell(goal: goal)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    // Modern iOS 13+ Swipe Actions Configuration
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // Delete Action
        let deleteAction = UIContextualAction(style: .destructive, title: "DELETE") { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            self.removeGoal(atIndexPath: indexPath)
            self.fetchCoreDataObjects()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completionHandler(true)
        }
        deleteAction.backgroundColor = UIColor(named: "Red") ?? .systemRed
        
        // Add 1 Progress Action
        let addAction = UIContextualAction(style: .normal, title: "ADD 1") { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            self.setProgress(atIndexPath: indexPath)
            tableView.reloadRows(at: [indexPath], with: .automatic)
            completionHandler(true)
        }
        addAction.backgroundColor = UIColor(named: "Green") ?? .systemGreen
        
        let swipeConfig = UISwipeActionsConfiguration(actions: [deleteAction, addAction])
        swipeConfig.performsFirstActionWithFullSwipe = false
        
        return swipeConfig
    }
}

// MARK: - Core Data Operations
extension ViewController {
    func setProgress(atIndexPath indexPath: IndexPath) {
        guard let manageContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let chosenGoal = goals[indexPath.row]
        
        // Increment progress by 1 until it hits the completion limit
        if chosenGoal.goalProgress < chosenGoal.goalCompletionValue {
            chosenGoal.goalProgress += 1
        } else {
            return
        }
        
        do {
            try manageContext.save()
            print("Successfully Set Progress!")
        } catch {
            debugPrint("Could not set progress: \(error.localizedDescription)")
        }
    }
    
    func removeGoal(atIndexPath indexPath: IndexPath) {
        guard let manageContext = appDelegate?.persistentContainer.viewContext else { return }
        
        manageContext.delete(goals[indexPath.row])
        do {
            try manageContext.save()
            print("Successfully removed goal!")
        } catch {
            debugPrint("Could not save: \(error.localizedDescription)")
        }
    }
    
    func fetch(completion: (_ complete: Bool) -> Void) {
        guard let manageContext = appDelegate?.persistentContainer.viewContext else {
            completion(false)
            return
        }
        
        let fetchRequest = NSFetchRequest<Goal>(entityName: "Goal")
        
        do {
            goals = try manageContext.fetch(fetchRequest)
            print("Successfully fetched data.")
            completion(true)
        } catch {
            debugPrint("Could not fetch: \(error.localizedDescription)")
            completion(false)
        }
    }
}
