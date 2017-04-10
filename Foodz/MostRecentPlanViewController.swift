//
//  MostRecentPlanViewController.swift
//  Foodz
//
//  Created by Håkon Ødegård Løvdal on 08/04/2017.
//  Copyright © 2017 Håkon Ødegård Løvdal. All rights reserved.
//

import UIKit
import SwiftyJSON

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
        ApiService.sharedInstance.getMostRecentPlan { (json, error) in
            guard let _ = json else {
                if let err = error {
                    print("Error while fetching most recent plan: \(err.localizedDescription)")
                } else {
                    print("Error while fetching most recent plan")
                }
                return
            }
            
            let plan = Plan(json: json!)
            self.plan = plan
            
        }
    }
}
