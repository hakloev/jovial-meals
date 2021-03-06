//
//  PlansViewController.swift
//  Foodz
//
//  Created by Håkon Ødegård Løvdal on 06/04/2017.
//  Copyright © 2017 Håkon Ødegård Løvdal. All rights reserved.
//

import UIKit

class PlansViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var plans: [Plan] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 50
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        ApiService.sharedInstance.getAllPlans { (plans, error) in
            // TODO: Add error handling here
            if let fetchedPlans = plans {
                self.plans = fetchedPlans
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                print("[PlansViewController] Error while unwrapping plans from ApiService")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PlanDetail" {
            if let rootVC = segue.destination as? UINavigationController {
                if let vc = rootVC.viewControllers[0] as? PlanDetailViewController {
                    let plan = self.plans[self.tableView.indexPathForSelectedRow!.row]
                    vc.editMode = true
                    vc.planId = plan.id!
                }
            }
        }
    }
    
    @IBAction func saveToPlansDetailViewController(segue: UIStoryboardSegue) {
        print("Save PlanDetail")
        if let planDetailViewController = segue.source as? PlanDetailViewController {
            if let newPlan = planDetailViewController.plan {
                let alreadyExists = self.plans.contains(where: { $0.id! == newPlan.id })
                
                if !alreadyExists {
                    self.plans.insert(newPlan, at: 0)
                } else {
                    let index = self.plans.index(where: { $0.id! == newPlan.id })
                    if let index = index {
                        self.plans[index] = newPlan
                    }
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }
        }
    }
    
    @IBAction func cancelToPlansViewController(segue: UIStoryboardSegue) {
        print("Cancel PlanDetail")
        if let selectedIndex = self.tableView.indexPathForSelectedRow {
            if let vc = segue.source as? PlanDetailViewController {
                // TODO: May remove this, and only do it on succeded save
                //self.plans[selectedIndex.row] = vc.plan!
            }
        }
    }
    
}

extension PlansViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plans.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "planCell", for: indexPath) as! PlanTableViewCell
        let plan = self.plans[indexPath.row]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // 2017-12-31
        let startDate = dateFormatter.date(from: (plan.startDate!))
        let endDate = dateFormatter.date(from: (plan.endDate!))
        
        dateFormatter.dateFormat = "d MMM" // 7 May
        let startDateString = dateFormatter.string(from: startDate!)
        let endDateString = dateFormatter.string(from: endDate!)
        
        cell.weekLabel.text = "Week \(startDate!.getWeekNumber())"
        cell.datesLabel.text = "\(startDateString) - \(endDateString)"
        cell.layoutIfNeeded()
        return cell
    }
}

