//
//  StudentsTableViewController.swift
//  On The Map
//
//  Created by Sören Kirchner on 11.09.17.
//  Copyright © 2017 Sören Kirchner. All rights reserved.
//

import UIKit

class StudentsTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var students = Students.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        fetchStudents()
    }
 
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
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
            DispatchQueue.main.async {
                self.activity(false)
                self.reloadData()
            }
        }
    }
    
    // MARK: - activity helper
    
    func activity(_ active: Bool) {
        DispatchQueue.main.async {
            self.activityView.isHidden = !active
            active ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
        }
    }

    // MARK: - action
    
    @IBAction func add(_ sender: Any) {
        performSegue(withIdentifier: "TableToAddLocation", sender: self)
    }
    
    @IBAction func logout(_ sender: Any) {
        logout()
    }
    
    @IBAction func fetchStudents(_ sender: Any) {
        fetchStudents()
    }
    
}

extension StudentsTableViewController: UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
}

extension StudentsTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentsTableViewCell", for: indexPath) as! StudentsTableViewCell
        let student = students.get(atIndex: indexPath.row)
        cell.nameLabel.text = student.firstName + " " + student.lastName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print(indexPath)
        let app = UIApplication.shared
        
        guard let url = URL(string: (students.get(atIndex: indexPath.row).mediaURL)) else {
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






