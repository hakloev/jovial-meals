//
//  RecipesViewController.swift
//  Foodz
//
//  Created by Håkon Ødegård Løvdal on 06/04/2017.
//  Copyright © 2017 Håkon Ødegård Løvdal. All rights reserved.
//

import UIKit
import SwiftyJSON

class RecipesViewController: UIViewController {
    
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
        
        ApiService.sharedInstance.getAllRecipes { (json, error) in
            
            for (_, item):(String, JSON) in json! {
                self.recipes.append(Recipe(json: item))
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
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

extension RecipesViewController: UITableViewDelegate, UITableViewDataSource {

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

