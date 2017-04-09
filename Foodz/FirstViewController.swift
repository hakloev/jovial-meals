//
//  FirstViewController.swift
//  Foodz
//
//  Created by Håkon Ødegård Løvdal on 06/04/2017.
//  Copyright © 2017 Håkon Ødegård Løvdal. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

let BASE_URL = "http://10.0.1.44:8000/api/v1/food/"
public let RECIPE_URL = "\(BASE_URL)recipes/"
public let PLAN_URL = "\(BASE_URL)plans/"
public let LATEST_URL = "\(PLAN_URL)latest/"
public let MEAL_URL = "\(BASE_URL)meals/"

let user = "hakloev"
let password = ""
let credentialData = "\(user):\(password)".data(using: String.Encoding.utf8)!
let base64Credentials = credentialData.base64EncodedString(options: [])
let headers = ["Authorization": "Basic \(base64Credentials)"]

struct Recipe {
    var id: Int?
    var name: String
    var website: String?
    let recipeType: String
    
    init(json: JSON) {
        id = json["id"].int
        name = json["name"].string!
        website = json["website"].string
        recipeType = json["recipe_type"].string!
    }
    
    init(name: String, website: String = "", recipeType: String = "F") {
        self.name = name
        self.website = website
        self.recipeType = recipeType
    }
    
    func toParameters() -> [String:String] {
        return [
            "name": name,
            "website": website ?? "",
            "recipe_type": recipeType
        ]
    }
}

class FirstViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var recipes: [Recipe] = []
    var selectedIndex: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 50
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        Alamofire.request(RECIPE_URL).responseJSON { response in
            switch response.result {
            case .success(let value):
                print("Load success")
                let json = JSON(value)
                for (_, item):(String, JSON) in json {
                    self.recipes.append(Recipe(json: item))
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelToRecipesViewController(segue: UIStoryboardSegue) {
        print("Cancel RecipeDetailVC")
        if let selectedIndex = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: selectedIndex, animated: true)
        }
    }
    
    @IBAction func saveRecipeDetail(segue: UIStoryboardSegue) {
        print("Save RecipeDetailVC")
        
        if let recipeDetailViewController = segue.source as? RecipeDetailViewController {
            if let recipe = recipeDetailViewController.recipe {
                // TODO: Should the table sort here?
                if recipeDetailViewController.editMode {
                    self.recipes[(selectedIndex?.row)!] = recipe
                } else {
                    self.recipes.append(recipe)
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditRecipe" {
            if let rootVC = segue.destination as? UINavigationController {
                if let vc = rootVC.viewControllers[0] as? RecipeDetailViewController {
                    print("vc")
                    if let index = self.tableView.indexPathForSelectedRow {
                        print("index")
                        vc.editMode = true
                        vc.recipe = self.recipes[index.row]
                    }
                }
            }
        }
    }
}

extension FirstViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as! RecipeTableViewCell
        let recipe = self.recipes[indexPath.row]
        cell.titleLabel.text = recipe.name
        cell.typeLabel.text = recipe.recipeType
        cell.setNeedsLayout()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath
    }
    
    
}

