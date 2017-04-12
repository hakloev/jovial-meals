//
//  PlanDetailViewController.swift
//  Foodz
//
//  Created by Håkon Ødegård Løvdal on 07/04/2017.
//  Copyright © 2017 Håkon Ødegård Løvdal. All rights reserved.
//

import UIKit

class PlanDetailViewController: UITableViewController {
    
    var plan: Plan? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var editMode: Bool = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("PlanDetail willAppear")
        if editMode {
            if let tempPlan = self.plan {
                print("meals for plan \(tempPlan.startDate!)")
            }

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if editMode {
            if let startDate = plan?.startDate {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let date = dateFormatter.date(from: startDate)
                self.navigationItem.title = "Week \(date!.getWeekNumber())"
            } else {
                self.navigationItem.title = "Week X"
            }
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
    
    @IBAction func unwindWithSelectedRecipe(segue: UIStoryboardSegue) {
        if let index = self.tableView.indexPathForSelectedRow {
            if let vc = segue.source as? RecipePickerViewController {
                print("Picked Recipe \(vc.selectedRecipe!.name!)")
                self.plan!.meals?[index.row].recipe = vc.selectedRecipe
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @IBAction func savePlan(_ sender: Any) {
        if editMode {
            print("save edited plan")
            
            
            
        } else {
            print("save new plan")
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
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: (plan?.startDate)!)
            cell.textLabel?.text = "Week \(date!.getWeekNumber())"
            
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: "mealCell", for: indexPath)
            let meal = plan!.meals?[indexPath.row]
            cell.textLabel?.text = Day(rawValue: meal!.day!)!.stringLabel
            if let recipe = meal?.recipe {
                cell.detailTextLabel?.text = recipe.name
            } else {
                cell.detailTextLabel?.text = "Not Selected"
            }
        default:
            print("section error")
            cell = tableView.dequeueReusableCell(withIdentifier: "weekCell", for: indexPath)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Week"
        case 1:
            return "Meals"
        default:
            return "Error"
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
