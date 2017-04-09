//
//  MostRecentPlanViewController.swift
//  Foodz
//
//  Created by Håkon Ødegård Løvdal on 08/04/2017.
//  Copyright © 2017 Håkon Ødegård Løvdal. All rights reserved.
//

import UIKit
import Alamofire
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
        Alamofire.request(LATEST_URL, headers: ["Authorization": "JWT \(UserDefaults.standard.string(forKey: LoginConstants.JWT_TOKEN_KEY)!)"]).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let plan = Plan(json: json)
                print(plan)
                self.plan = plan
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
