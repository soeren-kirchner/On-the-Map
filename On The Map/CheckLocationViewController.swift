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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let coordinate = self.location?.coordinate else {
            // TODO: implement error
            print("ERROR")
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
            // TODO: implement error
            return
        }
        
        guard let key = UdacityClient.shared.account?.key else {
            // TODO: ERROR
            return
        }
        
        UdacityClient.shared.fetchStudent("123") { result, error in
//        UdacityClient.shared.fetchStudent(key) { result, error in
            
            guard error == nil else {
                if error!.code == 101 {
                    print("user does not exist")
                    DispatchQueue.main.async {
                        let alertViewController = UIAlertController(title: "Student not in Database", message: "Add the Student to the Database?", preferredStyle: .alert)
                        alertViewController.addAction(UIAlertAction(title: "OK", style: .default) { action in
                            UdacityClient.shared.add(location: location, mapString: mapString, mediaURL: mediaURL, completionHandler: self.addOrUpdateCompletionHandler)
                        })
                        alertViewController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                        self.present(alertViewController, animated: true, completion: nil)
                    }
                    
                }
                else {
                    print("something wrong here")
                    // TODO: show error
                }
                return
            }
            
            guard let student = result as? Student else {
                // TODO: show error
                return
            }
            print(student)
            
            UdacityClient.shared.update(location: location, mapString: mapString, mediaURL: mediaURL, completionHandler: self.addOrUpdateCompletionHandler)
            
        }
        
        
        //UdacityClient.shared.add(student: student, location: location, mapString: mapString, mediaURL: mediaURL) { response, error in
            
        //}

    }
    
    func addOrUpdateCompletionHandler(result: AnyObject?, error: NSError?) -> Void {
        guard error == nil else {
            // TODO: show error
            return
        }
        
        print(result)
    }
    
    func unwind() {
        DispatchQueue.main.async {
            self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
            self.performSegue(withIdentifier: "unwindToStudentsMap", sender: self)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
