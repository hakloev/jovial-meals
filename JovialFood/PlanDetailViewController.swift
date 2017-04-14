//
//  PlanDetailViewController.swift
//  Foodz
//
//  Created by Håkon Ødegård Løvdal on 07/04/2017.
//  Copyright © 2017 Håkon Ødegård Løvdal. All rights reserved.
//

import UIKit

class PlanDetailViewController: UITableViewController {
    
    var planId: Int? {
        didSet {
            self.fetchPlanDetails()
        }
    }
    
    var plan: Plan?
    var recipes: [Recipe]? = []
    
    var editMode: Bool = false
    
    lazy var recipePickerView: RecipePickerViewController = {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "RecipePickerView") as! RecipePickerViewController
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if editMode {
            self.navigationItem.title = "Edit Plan"
            self.navigationItem.rightBarButtonItem?.title = "Save"
        } else {
            print("add new plan, editMode false")
            self.navigationItem.title = "New Plan"
            plan = Plan()
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func fetchPlanDetails() {
        if let planId = self.planId {
            ApiService.sharedInstance.getPlan(byId: planId) { (planDetail, error) in
                if let planDetail = planDetail {
                    if let plan = planDetail.plan {
                        self.plan = plan
                    }
                    if let recipes = planDetail.recipes {
                        self.recipes = recipes
                    }
                    print("Got all details from server")
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }

        }
    }
    
    @IBAction func unwindWithSelectedRecipe(segue: UIStoryboardSegue) {
        if let index = self.tableView.indexPathForSelectedRow {
            if let vc = segue.source as? RecipePickerViewController {
                if let selectedRecipe = vc.selectedRecipe {
                    print("Picked Recipe \(selectedRecipe.id!) \(selectedRecipe.name!)")
                    // Add the selected recipe 
                    if !self.recipes!.contains(where: { $0.id == selectedRecipe.id }) {
                        print("Did not have recipe, add it to list")
                        self.recipes!.append(selectedRecipe)
                    }
                    // Add recipe id to plan model
                    self.plan!.meals![index.row].recipeId = selectedRecipe.id!
                    print(self.plan!.meals![index.row].recipeId!)
                   
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    @IBAction func savePlan(_ sender: Any) {
        if editMode {
            print("save edited plan")
            ApiService.sharedInstance.editPlan(byId: plan!.id!, andParameters: plan!.toJSON()) { (plan, error) in
                if let updatedPlan = plan {
                    self.plan = updatedPlan
                    self.performSegue(withIdentifier: "SavePlanDetail", sender: self)
                }
            }
            
        } else {
            print("save new plan")
            ApiService.sharedInstance.addPlan(parameters: plan!.toJSON()) { (plan, error) in
                print("Added plan")
                if let newPlan = plan {
                    self.plan = newPlan
                    self.performSegue(withIdentifier: "SavePlanDetail", sender: self)
                }
            }

        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return 1
        case 1:
            //return 0
            //return meals?.count ?? 0
            return plan?.meals?.count ?? 7
        default:
            return 0
        }
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        
        switch indexPath.section {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: "weekCell", for: indexPath)
            
            if let plan = self.plan {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let date = dateFormatter.date(from: (plan.startDate!))
                cell.textLabel?.text = "Week \(date!.getWeekNumber())"
            }
            
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: "mealCell", for: indexPath)
            if let meal = plan?.meals?[indexPath.row] {
                cell.textLabel?.text = Day(rawValue: meal.day!)!.stringLabel
                if let recipeId = meal.recipeId {
                    let currentRecipe = self.recipes?.filter({ $0.id == recipeId }).first
                    if let recipe = currentRecipe {
                        cell.detailTextLabel?.text = recipe.name
                    }
                } else {
                    cell.detailTextLabel?.text = "Not Selected"
                }
            }
        default:
            print("section error")
            cell = tableView.dequeueReusableCell(withIdentifier: "weekCell", for: indexPath)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Week"
        case 1: return "Meals"
        default: return "Error"
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            self.recipePickerView.searchController.searchBar.text = "" // Reset query
            self.navigationController?.pushViewController(self.recipePickerView, animated: true)
        }
    }
}
