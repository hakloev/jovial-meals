//
//  LoginService.swift
//  Foodz
//
//  Created by Håkon Ødegård Løvdal on 09/04/2017.
//  Copyright © 2017 Håkon Ødegård Løvdal. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

protocol LoginServiceDelegate: class {
    func loginDidSucceded(token: String)
    func loginDidFail()
}

public struct LoginConstants {
    static let JWT_TOKEN_KEY = "jwtTokenKey"
    static let USER_LOGGED_IN_KEY = "isUserLoggedIn"
}

class LoginService {
    
    public static let sharedInstance = LoginService()
    
    private let BASE_URL = "http://10.0.0.62:8000/api/v1/token-auth/"
    
    weak var delegate: LoginServiceDelegate?
    
    func login(username: String, password: String) {
        let parameters = [
            "username": username,
            "password": password,
        ]
        
        Alamofire.request(BASE_URL, method: .post, parameters: parameters, headers: nil).responseObject { (response: DataResponse<LoginResponse>) in
            switch response.result {
            case .success(let response):
                if let jwtKey = response.token {
                    print(jwtKey)
                    UserDefaults.standard.set(true, forKey: LoginConstants.USER_LOGGED_IN_KEY)
                    UserDefaults.standard.set(jwtKey, forKey: LoginConstants.JWT_TOKEN_KEY)
                    UserDefaults.standard.synchronize()
                    
                    // Delegate Success here
                    self.delegate?.loginDidSucceded(token: jwtKey)
                } else {
                    // Delegate Error
                    print("Error in jwtKey parse")
                    self.delegate?.loginDidFail()
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                // Delegate error
                self.delegate?.loginDidFail()
            }
        }
    }
}
