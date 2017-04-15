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
    @IBOutlet weak var currentMealLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let margin: CGFloat = 1, cellsPerRow: CGFloat = 2
    
    var plan: Plan? {
        didSet {
            updateLabels()
        }
    }
    
    var filteredMeals: [Meal] = []
    
    var recipes: [Recipe]?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadMostRecentPlan()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        guard let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        flowLayout.minimumInteritemSpacing = margin
        flowLayout.minimumLineSpacing = margin
        flowLayout.sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateLabels() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: (plan!.startDate!))
        weekLabel.text = "Week \(date!.getWeekNumber())"
        
        var today = Calendar.current.component(.weekday, from: Date()) - 2 // Subtract 2 in order to change to 0-6 instead of 1-7
        today = (today < 0) ? 6 : today
        
        filteredMeals = self.plan!.meals!.filter { meal in
            return meal.day != today
        }
        
        let todaysMeal = self.plan?.meals!.first(where: { $0.day == today })
        let todaysRecipe = self.recipes?.first(where: { $0.id == todaysMeal!.recipeId })
        currentMealLabel.text = todaysRecipe!.name
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        
    }
    
    func loadMostRecentPlan() {
        ApiService.sharedInstance.getMostRecentPlan { (plan, error) in
            if let fetchedPlan = plan {
                self.recipes = fetchedPlan.recipes
                self.plan = fetchedPlan.plan
            } else {
                print("[MostRecentPlanViewController] Error while unwrapping response from ApiService")
            }
            
        }
    }
}

extension MostRecentPlanViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredMeals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MealCell", for: indexPath as IndexPath) as! MealCollectionViewCell
        
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor.lightGray.cgColor
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        let meal = self.filteredMeals[indexPath.row]
        if let recipeId = meal.recipeId {
            if let recipe = self.recipes?.filter({ $0.id == recipeId }).first {
                cell.mealLabel.text = recipe.name
            }
        }
        
        if let day = meal.day {
            cell.dayLabel.text = Day(rawValue: day)!.stringLabel
        }
        
        //cell.myLabel.text = self.items[indexPath.item]
        //cell.backgroundColor = UIColor.cyan // make cell more visible in our example project
        
        return cell
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let marginsAndInsets = flowLayout.sectionInset.left + flowLayout.sectionInset.right + flowLayout.minimumInteritemSpacing * (cellsPerRow - 1)
        let itemWidth = (collectionView.bounds.size.width - marginsAndInsets) / cellsPerRow
        let itemHeight = (collectionView.bounds.size.height) / 3
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        insetForSectionAt section: Int) -> UIEdgeInsets {
//        let leftRightInset = self.view.frame.size.width / 10.0
//        print(leftRightInset)
//        return UIEdgeInsetsMake(0, 0, 0, 0)
//
//    }
    
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return sectionInsets.left
//    }
    
}
