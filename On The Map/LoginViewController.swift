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
    
    func showAlert(_ alert: String) {
        DispatchQueue.main.async {
            let alertViewController = UIAlertController(title: "Login Failure", message: alert, preferredStyle: .alert)
            alertViewController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertViewController, animated: true, completion: nil)
        }
    }
    
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
                self.showAlert(error!.localizedDescription)
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
            print(UdacityClient.shared.account?.key)
            
            UdacityClient.shared.fetchMyPublicData() { data, error in
                
                print(error)
                print(data)
                
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
            
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "LoggedInSegue", sender: self)
            }
        }
    }

    // MARK: - Keybord things
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func keyboardWillShow(_ notification:Notification) {
        view.frame.origin.y = 0-getKeyboardHeight(notification)
    }
    
    func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return(true)
    }
    
}
