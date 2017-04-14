//
//  MostRecentPlanViewController.swift
//  Foodz
//
//  Created by Håkon Ødegård Løvdal on 08/04/2017.
//  Copyright © 2017 Håkon Ødegård Løvdal. All rights reserved.
//

import UIKit

class MostRecentPlanViewController: UIViewController {
    
    @IBOutlet weak var weekLabel: UILabel!
    
    var plan: Plan? {
        didSet {
            weekLabel.text = plan!.startDate
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadMostRecentPlan()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadMostRecentPlan() {
        ApiService.sharedInstance.getMostRecentPlan { (plan, error) in
            if let fetchedPlan = plan {
                self.plan = fetchedPlan.plan
            } else {
                print("[MostRecentPlanViewController] Error while unwrapping response from ApiService")
            }
            
        }
    }
}
