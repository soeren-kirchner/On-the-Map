//
//  StudentsMapViewController.swift
//  On The Map
//
//  Created by Sören Kirchner on 16.09.17.
//  Copyright © 2017 Sören Kirchner. All rights reserved.
//

import UIKit
import MapKit

class StudentsMapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var students = [Student] ()

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
//        mapView.showsScale = true
//        mapView.showsPointsOfInterest = true
        fetchStudents()
    }
    
//    func showAlert(_ alert: String) {
//        DispatchQueue.main.async {
//            let alertViewController = UIAlertController(title: "Update Failure", message: alert, preferredStyle: .alert)
//            alertViewController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//            self.present(alertViewController, animated: true, completion: nil)
//        }
//    }
    
    func fetchStudents() {
        activity(true)
        UdacityClient.shared.fetchStudents() { results, error in
            guard error == nil else {
                self.showAlert(title: "ERROR", alert: "could not load data")
                self.activity(false)
                return
            }
            
            guard let students = results as? [Student] else {
                self.showAlert(title: "ERROR", alert: "data not readable")
                self.activity(false)
                return
            }
            
            self.students = students
            
            var annotations = [MKPointAnnotation]()
            
            for student in self.students {
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: student.latitude, longitude: student.longitude)
                annotation.title = "\(student.firstName) \(student.lastName)"
                annotation.subtitle = student.mediaURL
                annotations.append(annotation)
            }
            
            DispatchQueue.main.async {
                self.mapView.removeAnnotations(self.mapView.annotations)
                self.mapView.addAnnotations(annotations)
                self.activity(false)
            }
        }
    }
    
    func activity(_ active: Bool) {
        DispatchQueue.main.async {
            self.activityView.isHidden = !active
            active ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
        }
    }
    
    @IBAction func add(_ sender: Any) {
        performSegue(withIdentifier: "MapToAddLocation", sender: self)
    }
    
    @IBAction func logout(_ sender: Any) {
        logout()
    }
  
    @IBAction func fetchStudents(_ sender: Any) {
        fetchStudents()
    }
    
    
    // MARK: - Navigation

    @IBAction func unwindToStudentsMapView(segue: UIStoryboardSegue) {}
    
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */    
}

extension StudentsMapViewController: MKMapViewDelegate {

    // create pinView
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "StudentPin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .green
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    // responde to tabbing
    // TODO: improve it
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("It was called")
        print(control)
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let url = URL(string: (view.annotation?.subtitle!)!) {
                app.open(url, options: [:])
            }
            else {
                print("could not open safari")
            }
        }
    }
    
}


