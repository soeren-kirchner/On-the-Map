//
//  AddLocationViewController.swift
//  On The Map
//
//  Created by Sören Kirchner on 17.09.17.
//  Copyright © 2017 Sören Kirchner. All rights reserved.
//

import UIKit
import CoreLocation

class AddLocationViewController: UIViewController {
    
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!

    var mapString = ""
    var mediaURL = ""
    var location: CLLocation? = nil
    
    @IBAction func getLocation(_ sender: Any) {
        
        self.mapString = addressTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        self.mediaURL = urlTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if self.mapString.isEmpty {
            self.showAlert(title: "No Address", alert: "Please enter a address")
            return
        }
        
        guard let _ = URL(string: mediaURL) else {
            self.showAlert(title: "No URL", alert: "Please enter a valid URL")
            return
        }
   
        let geoCoder = CLGeocoder()
        
        geoCoder.geocodeAddressString(mapString) { (placemarks, error) in
            
            guard error == nil else {
                self.showAlert(title: "Address not found", alert: "Could'nt get information to your Address")
                return
            }
            
            self.location = placemarks?.first?.location
            
            if self.location == nil {
                self.showAlert(title: "No Coordinates", alert: "Could'nt find any Coordinates to your Address")
                return
            }
            
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "AddToCeckLocationSegue", sender: self)
            }
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? CheckLocationViewController {
            destination.mediaURL = self.mediaURL
            destination.mapString = self.mapString
            destination.location = self.location
        }
    }

}
