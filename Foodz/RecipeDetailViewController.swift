//
//  RecipeDetailViewController.swift
//  Foodz
//
//  Created by Håkon Ødegård Løvdal on 06/04/2017.
//  Copyright © 2017 Håkon Ødegård Løvdal. All rights reserved.
//

import UIKit

class RecipeDetailViewController: UIViewController {

    lazy var spinner: UIBarButtonItem = {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        return UIBarButtonItem(customView: activityIndicator)
    }()

    
    @IBOutlet weak var name: UITextField!
    
    var recipe: Recipe?
    var editMode: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if editMode {
            self.navigationItem.rightBarButtonItem?.title = "Save"
            if let recipeTitle = recipe?.name {
                self.navigationItem.title = recipeTitle
                self.name.text = recipeTitle
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveRecipe(_ sender: Any) {
        self.navigationItem.rightBarButtonItem = spinner
                
        if !editMode {
            recipe = Recipe(name: self.name.text!)
        } else {
            recipe?.name = self.name.text!
        }
                
        if !editMode {
            let params = recipe?.toJSON()
            ApiService.sharedInstance.addRecipe(parameters: params!) { (recipe, error) in
                if let newRecipe = recipe {
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .done, target: nil, action: nil)
                    self.recipe = newRecipe
                    self.performSegue(withIdentifier: "SaveRecipeDetail", sender: self)
                } else {
                    // Todo: Alert here
                    print("[RecipeDetailViewController] Error while unwrapping recipe from ApiService")
                }
            }
            
        } else {
            let params = recipe?.toJSON()
            ApiService.sharedInstance.editRecipe(withId: recipe!.id!, andParameters: params!) { (recipe, error) in
                if let updatedRecipe = recipe {
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: nil, action: nil)
                    self.recipe = updatedRecipe
                    self.performSegue(withIdentifier: "SaveRecipeDetail", sender: self)
                } else {
                    // Todo: Alert here
                    print("[RecipeDetailViewController] Error while unwrapping recipe from ApiService")
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SaveRecipeDetail" {
            print("SaveRecipeDetail seque")
        }
    }

}
