//
//  StudentsTableViewController.swift
//  On The Map
//
//  Created by Sören Kirchner on 11.09.17.
//  Copyright © 2017 Sören Kirchner. All rights reserved.
//

import UIKit

class StudentsTableViewController: UITableViewController {
    
    var students = [Student] ()

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchStudents()
    }

    func showAlert(_ alert: String) {
        DispatchQueue.main.async {
            let alertViewController = UIAlertController(title: "Update Failure", message: alert, preferredStyle: .alert)
            alertViewController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertViewController, animated: true, completion: nil)
        }
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func fetchStudents() {
        UdacityClient.shared.fetchStudents() { results, error in
            guard error == nil else {
                print(error!.localizedDescription)
                self.showAlert("could not load data")
                return
            }
            self.students = results!
            self.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentsTableViewCell", for: indexPath) as! StudentsTableViewCell
        let student = students[indexPath.row]
        cell.nameLabel.text = student.firstName + " " + student.lastName
        return cell
    }

    // MARK: - action
    
    @IBAction func add(_ sender: Any) {
    }
    
    @IBAction func logout(_ sender: Any) {
    }
    
    @IBAction func fetchStudents(_ sender: Any) {
        fetchStudents()
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
