//
//  LoginViewController.swift
//  On The Map
//
//  Created by Sören Kirchner on 09.09.17.
//  Copyright © 2017 Sören Kirchner. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwdTextField: UITextField!
    @IBOutlet weak var loginActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        subscribeToKeyboardNotifications()
        loginTextField.delegate = self
        passwdTextField.delegate = self
        loginActivityIndicator.hidesWhenStopped = true
        loginActivityIndicator.stopAnimating()
        loginButton.setTitleColor(UIColor.darkGray, for: .normal)
        loginButton.setTitleColor(UIColor.lightGray, for: .disabled)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = .default
        unsubscribeFromKeyboardNotifications()
    }

    // MARK: - Navigation
    
//    func showAlert(_ alert: String) {
//        DispatchQueue.main.async {
//            let alertViewController = UIAlertController(title: "Login Failure", message: alert, preferredStyle: .alert)
//            alertViewController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//            self.present(alertViewController, animated: true, completion: nil)
//        }
//    }
    
    @IBAction func login(_ sender: Any) {
        loginActivityIndicator.startAnimating()
        loginButton.isEnabled = false
        UdacityClient.shared.udacityLogin(user: loginTextField.text!, password: passwdTextField.text!) { data, error in
            print(data)
            
            DispatchQueue.main.async {
                self.loginActivityIndicator.stopAnimating()
                self.loginButton.isEnabled = true
            }
            
            guard error == nil else {
                print(error.debugDescription)
                self.showAlert(title: "Login Error", alert: error!.localizedDescription)
                return
            }
            
            guard
                let data = data,
                let accountData = data["account"] as? JSONDictionary,
                let account = UdacityAccount(dictionary: accountData)
            else {
                
                return
            }
            
            UdacityClient.shared.account = account
            print(account)
            print(UdacityClient.shared.account!.key)
            
            UdacityClient.shared.fetchMyPublicData() { user, error in
                
                guard error == nil else {
                    self.showAlert(title: "Fetching Data Error", alert: error!.localizedDescription)
                    return
                }
                
                guard let user = user as? UdacityUser else {
                    self.showAlert(title: "Fetching Data Error", alert: "Could nozt fetch user for this account")
                    return
                }
                
                UdacityClient.shared.user = user
                
                //print(error!)
                print(user)
                
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "LoggedInSegue", sender: self)
                }
            }
            
            
            
//            UdacityClient.shared.fetchStudent(account.key) { student, error in
//
//                guard error == nil else {
//                    print(error.debugDescription)
//                    self.showAlert(error!.localizedDescription)
//                    return
//                }
//
//                guard let student = student else {
//                    self.showAlert("something wrong with student data")
//                    return
//                }
//
//                UdacityClient.shared.mySelf = student
//            }
            
            
        }
    }

    // MARK: - Keybord things
    

    
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return(true)
    }
    
}
