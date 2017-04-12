//
//  RecipePickerViewController.swift
//  Foodz
//
//  Created by Håkon Ødegård Løvdal on 07/04/2017.
//  Copyright © 2017 Håkon Ødegård Løvdal. All rights reserved.
//

import UIKit

class RecipePickerViewController: UITableViewController {

    var recipes: [Recipe] = []
    var selectedRecipe: Recipe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ApiService.sharedInstance.getAllRecipes { (recipes, error) in
            if let fetchedRecipes = recipes {
                self.recipes = fetchedRecipes
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                print("[RecipePickerViewController] Something wrong while unwrapping recipes from ApiService")
            }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SaveSelectedRecipe" {
            if let cell = sender as? UITableViewCell {
                let indexPath = tableView.indexPath(for: cell)
                if let index = indexPath?.row {
                    selectedRecipe = recipes[index]
                }
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return recipes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipePickerCell", for: indexPath)
        cell.textLabel?.text = self.recipes[indexPath.row].name
        return cell
    }
}
