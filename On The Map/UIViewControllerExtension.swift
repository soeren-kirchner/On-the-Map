//
//  UIViewControllerExtension.swift
//  On The Map
//
//  Created by Sören Kirchner on 30.09.17.
//  Copyright © 2017 Sören Kirchner. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    // common user alert dialog
    
    func showAlert(title: String, alert: String) {
        DispatchQueue.main.async {
            let alertViewController = UIAlertController(title: title, message: alert, preferredStyle: .alert)
            alertViewController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertViewController, animated: true, completion: nil)
        }
    }
    
    // show/hide keyboard
    
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
    
    @objc func keyboardWillShow(_ notification:Notification) {
        view.frame.origin.y = 0-getKeyboardHeight(notification)
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }
    
    // Logout for Table and Map VCs
    
    func logout() {
        UdacityClient.shared.logout() { results, error in
            guard error == nil else {
                self.showAlert(title: "Logout Error", alert: error!.description)
                return
            }
            
            guard let results = results else {
                self.showAlert(title: "Logout Error", alert: "Could not logout for unknown reason")
                return
            }
            
            print(results)
            DispatchQueue.main.async {
                self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
            }
        }
    }
}
