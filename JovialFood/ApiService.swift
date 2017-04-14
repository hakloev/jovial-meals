//
//  ApiService.swift
//  Foodz
//
//  Created by Håkon Ødegård Løvdal on 09/04/2017.
//  Copyright © 2017 Håkon Ødegård Løvdal. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

let BASE_URL = "http://10.0.0.62:8000/api/v1/food/"
public let RECIPE_URL = "\(BASE_URL)recipes/"
public let PLAN_URL = "\(BASE_URL)plans/"
public let LATEST_URL = "\(PLAN_URL)latest/"
public let MEAL_URL = "\(BASE_URL)meals/"


class ApiService {
    
    static let sharedInstance = ApiService()
    
    // TODO: Maybe completion here passed from general api func? To return error?
    // example: let error = NSError(domain: "fitmi-invalid-jwt-token", code: 2, userInfo: nil) as Error
    
    // TODO: Need to check http status codes.. example: 401 

    private func getTokenHeaders() -> Dictionary<String, String> {
        let defaults = UserDefaults.standard
        guard let jwtToken = defaults.string(forKey: LoginConstants.JWT_TOKEN_KEY) else {
            return [:]
        }
        
        return ["Authorization": "JWT \(jwtToken)"]
    }
    
    func getMostRecentPlan(completion: @escaping (PlanDetailResponse?, Error?) -> Void) {
        // TODO: Need error handling for getTokenHeaders()

        Alamofire.request(LATEST_URL, headers: getTokenHeaders()).responseObject { (response: DataResponse<PlanDetailResponse>) in
            switch response.result {
            case .success(let planDetail):
                completion(planDetail, nil)
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                completion(nil, error)
            }
        }
    }
    
    func getPlan(byId id: Int, completion: @escaping (PlanDetailResponse?, Error?) -> Void) {
        Alamofire.request("\(PLAN_URL)\(id)/", headers: getTokenHeaders()).responseObject { (response: DataResponse<PlanDetailResponse>) in
            switch response.result {
            case .success(let planDetail):
                completion(planDetail, nil)
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                completion(nil, error)
            }
        }
    }
    
    func editPlan(byId id: Int, andParameters parameters: [String:Any], completion: @escaping (Plan?, Error?) -> Void) {
        Alamofire.request("\(PLAN_URL)\(id)/", method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: getTokenHeaders()).responseObject { (response: DataResponse<Plan>) in
            switch response.result {
            case .success(let plan):
                completion(plan, nil)
            case .failure(let error):
                print("Error \(error.localizedDescription)")
                completion(nil, error)
            }
        }
    }

   
    func getAllPlans(completion: @escaping ([Plan]?, Error?) -> Void) {
        Alamofire.request(PLAN_URL, headers: getTokenHeaders()).responseObject { (response: DataResponse<PlanListResponse>) in
            switch response.result {
            case .success(let value):
                if let plans = value.results {
                    completion(plans, nil)
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                completion(nil, error)
            }
        }
    }
    
    func getMealsForPlanById(id: Int, completion: @escaping ([Meal]?, Error?) -> Void) {
        Alamofire.request("\(PLAN_URL)\(id)/", headers: getTokenHeaders()).responseArray { (response:DataResponse<[Meal]>) in
            switch response.result {
            case .success(let meals):
                completion(meals, nil)
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                completion(nil, error)
            }
        }
    }
    
    func getAllRecipes(completion: @escaping ([Recipe]?, Error?) -> Void) {
        Alamofire.request(RECIPE_URL, headers: getTokenHeaders()).responseObject { (response: DataResponse<RecipeListResponse>) in
            switch response.result {
            case .success(let value):
                if let recipes = value.results {
                    completion(recipes, nil)
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                completion(nil, error)
            }
        }
    }
    
    func addPlan(parameters: [String: Any], completion: @escaping (Plan?, Error?) -> Void) {
        Alamofire.request(PLAN_URL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: getTokenHeaders()).responseObject { (response: DataResponse<Plan>) in
            switch response.result {
            case .success(let plan):
                completion(plan, nil)
            case .failure(let error):
                print("Error \(error.localizedDescription)")
                completion(nil, error)
            }
        
        }
    }
    
    func addRecipe(parameters: [String: Any], completion: @escaping (Recipe?, Error?) -> Void) {
        Alamofire.request(RECIPE_URL, method: .post, parameters: parameters, headers: getTokenHeaders()).responseObject { (response: DataResponse<Recipe>) in
            switch response.result {
            case .success(let recipe):
                completion(recipe, nil)
            case .failure(let error):
                print("Error \(error.localizedDescription)")
                completion(nil, error)
            }
        }
    }
    
    func editRecipe(withId id: Int, andParameters parameters: [String:Any], completion: @escaping (Recipe?, Error?) -> Void) {
        Alamofire.request("\(RECIPE_URL)\(id)/", method: .put, parameters: parameters, headers: getTokenHeaders()).responseObject { (response: DataResponse<Recipe>) in
            switch response.result {
            case .success(let recipe):
                completion(recipe, nil)
            case .failure(let error):
                print("Error \(error.localizedDescription)")
                completion(nil, error)
            }
        }
    }
}
