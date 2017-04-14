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
    var filteredRecipes: [Recipe] = []
    
    var selectedRecipe: Recipe?
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
//        definesPresentationContext = false
        self.tableView.tableHeaderView = searchController.searchBar
        
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
                    if searchController.isActive && searchController.searchBar.text != "" {
                        selectedRecipe = filteredRecipes[index]
                    } else {
                        selectedRecipe = recipes[index]
                    }
                }
            }
        }
    }
    
    func filterContentForSearchText(query: String) {
        filteredRecipes = recipes.filter { recipe in
            return recipe.name!.lowercased().contains(query.lowercased())
        }

        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredRecipes.count
        }
        return recipes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipePickerCell", for: indexPath)
        let recipe: Recipe
        if searchController.isActive && searchController.searchBar.text != "" {
            recipe = filteredRecipes[indexPath.row]
        } else {
            recipe = recipes[indexPath.row]
        }
        
        cell.textLabel?.text = recipe.name
        
        if let selectedRecipe = self.selectedRecipe {
            if selectedRecipe.id == recipe.id {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        }
        
        return cell
    }
    
}

extension RecipePickerViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(query: searchController.searchBar.text!)
    }
    
}
