//
//  LoginViewController.swift
//  Foodz
//
//  Created by Håkon Ødegård Løvdal on 09/04/2017.
//  Copyright © 2017 Håkon Ødegård Løvdal. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    var loginService: LoginService = LoginService.sharedInstance
    
//    override func viewWillAppear(_ animated: Bool) {
//        if UserDefaults.standard.bool(forKey: LoginConstants.USER_LOGGED_IN_KEY) {
//            print("User already logged in, continue to main VC")
//            self.sendUserToMainViewControllerAfterLogin()
//        }
//        
//        super.viewWillAppear(animated)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginService.delegate = self
        
//        UserDefaults.standard.set(false, forKey: LoginConstants.USER_LOGGED_IN_KEY)
//        UserDefaults.standard.synchronize
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sendUserToMainViewControllerAfterLogin() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "LoginSucceded", sender: self)
        }
    }
    
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        if let username = usernameInput.text, let password = passwordInput.text {
            loginService.login(username: username , password: password)
        } else {
            print("[loginButtonPressed] Username or password not defined")
        }
        
    }
}

extension LoginViewController: LoginServiceDelegate {
   
    func loginDidSucceded(token: String) {
        self.sendUserToMainViewControllerAfterLogin()
    }
    
    func loginDidFail() {
        print("Failed login")
    }
}
