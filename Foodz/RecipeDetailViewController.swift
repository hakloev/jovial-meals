//
//  RecipeDetailViewController.swift
//  Foodz
//
//  Created by Håkon Ødegård Løvdal on 06/04/2017.
//  Copyright © 2017 Håkon Ødegård Løvdal. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

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
            let params = recipe?.toParameters()
            Alamofire.request(RECIPE_URL, method: .post, parameters: params, headers: nil).responseJSON { response in
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .done, target: nil, action: nil)
                switch response.result {
                case .success(let value):
                    let newRecipe = Recipe(json: JSON(value))
                    self.recipe = newRecipe
                    self.performSegue(withIdentifier: "SaveRecipeDetail", sender: self)
                case .failure(let error):
                    print("Error \(error.localizedDescription)")
                }
            }
        } else {
            let params = recipe?.toParameters()
            Alamofire.request("\(RECIPE_URL)\(recipe!.id!)/", method: .put, parameters: params, headers: nil).responseJSON { response in
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: nil, action: nil)
                switch response.result {
                case .success(let value):
                    let updatedRecipe = Recipe(json: JSON(value))
                    self.recipe = updatedRecipe
                    self.performSegue(withIdentifier: "SaveRecipeDetail", sender: self)
                case .failure(let error):
                    print("Error \(error.localizedDescription)")
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

        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
