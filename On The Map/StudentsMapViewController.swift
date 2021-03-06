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
    
    var students = Students.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        fetchStudents()
    }
    
    func fetchStudents() {
        activity(true)
        UdacityClient.shared.fetchStudents() { results, error in
            guard error == nil else {
                self.showAlert(title: "ERROR", alert: "could not load data")
                self.activity(false)
                return
            }
            
            guard let students = results as? [StudentInformation] else {
                self.showAlert(title: "ERROR", alert: "data not readable")
                self.activity(false)
                return
            }
            
            self.students.replace(by: students)
            
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
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {

        let app = UIApplication.shared
   
        guard control == view.rightCalloutAccessoryView else {
            return
        }
  
        guard let url = URL(string: (view.annotation?.subtitle!)!) else {
            self.showAlert(title: "Error", alert: "Failure in URL")
            return
        }
        
        app.open(url, options: [:]) { success in
            guard success else {
                self.showAlert(title: "Error", alert: "could not open the given URL")
                return
            }
        }
    }
}


