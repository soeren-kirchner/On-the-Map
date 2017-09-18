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

    var address = ""
    var urlString = ""
    var location: CLLocation? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAlert(_ alert: String) {
        DispatchQueue.main.async {
            let alertViewController = UIAlertController(title: "ERROR", message: alert, preferredStyle: .alert)
            alertViewController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func getLocation(_ sender: Any) {
        
        self.address = addressTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        self.urlString = urlTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        print("address: \(self.address)")
        print("urlString: \(self.urlString)")
 
        if self.address.isEmpty {
            self.showAlert("Please enter a address")
            return
        }
        
        guard let _ = URL(string: urlString) else {
            self.showAlert("Please enter a valid URL")
            return
        }
   
        let geoCoder = CLGeocoder()
        
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            
            guard error == nil else {
                self.showAlert("Could'nt get information to your Address")
                return
            }
            
            self.location = placemarks?.first?.location
            
            if self.location == nil {
                self.showAlert("Could'nt find any Coordinates to your Address")
                return
            }
//            let lat = location.coordinate.latitude
//            let lon = location.coordinate.longitude
//            print(lat)
//            print(lon)
            
            
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "AddToCeckLocationSegue", sender: self)

            }
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? CheckLocationViewController {
            destination.location = self.location
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
