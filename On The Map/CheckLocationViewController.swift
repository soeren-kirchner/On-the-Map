//
//  CheckLocationViewController.swift
//  On The Map
//
//  Created by Sören Kirchner on 18.09.17.
//  Copyright © 2017 Sören Kirchner. All rights reserved.
//

import UIKit
import MapKit

class CheckLocationViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    var location: CLLocation? = nil
    var mediaURL: String?
    var mapString: String?
    
    override func viewDidAppear(_ animated: Bool) {
        guard let coordinate = self.location?.coordinate else {
            showAlert(title: "Fatal Error", alert: "No Location")
            return
        }
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        
        mapView.addAnnotation(annotation)
        mapView.setRegion(region, animated: true)
    }
    
    @IBAction func addLocation(_ sender: Any) {
        
        guard
            let location = location,
            let mediaURL = mediaURL,
            let mapString = mapString
        else {
            showAlert(title: "Fatal Error", alert: "No location or no mediaURL or no mapString")
            return
        }
        
        guard let key = UdacityClient.shared.account?.key else {
            showAlert(title: "Fatal Error", alert: "No location or no mediaURL or no mapString")
            return
        }
        
        UdacityClient.shared.fetchStudent(key) { result, error in
            
            guard error == nil else {
                if error!.code == 101 {
                    self.showQuestion(title: "Student does not exist", message: "Add the Student to the Database?") {
                        UdacityClient.shared.add(location: location, mapString: mapString, mediaURL: mediaURL, completionHandler: self.addOrUpdateCompletionHandler)
                    }
                }
                else {
                    self.showAlert(title: "ERROR", alert: "The internet connection is offline.")
                }
                return
            }
            
            guard let student = result as? StudentInformation else {
                self.showAlert(title: "ERROR in Data", alert: "for unknown reason.")
                return
            }
        
            self.showQuestion(title: "Student already exists", message: "Update information in the Database?") {
                UdacityClient.shared.update(objectID: student.objectId, location: location, mapString: mapString, mediaURL: mediaURL, completionHandler: self.addOrUpdateCompletionHandler)
            }
        }
    }
    
    func showQuestion(title: String, message: String, handler: @escaping ()->()) {
        DispatchQueue.main.async {
            let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertViewController.addAction(UIAlertAction(title: "OK", style: .default) { action in
                handler()
            })
            alertViewController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            self.present(alertViewController, animated: true, completion: nil)
        }
    }
    
    func addOrUpdateCompletionHandler(result: AnyObject?, error: NSError?) -> Void {
        guard error == nil else {
            showAlert(title: "ERROR", alert: "could not add/update the Location. Detail: \(error!.localizedDescription)")
            return
        }
        unwind()
    }
    
    // MARK: - Navigation
    
    func unwind() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "unwindToStudentsMap", sender: self)
        }
    }
}
