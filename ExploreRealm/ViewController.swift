//
//  ViewController.swift
//  ExploreRealm
//
//  Created by Sajid Shanta on 8/2/24.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var inputStack: UIStackView!
    @IBOutlet weak var firstNameLabel: UITextField!
    @IBOutlet weak var lastNameLabel: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var users: [User] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: "UserTableViewCell")
        
        setupViews()
        readUsers()
    }
    
    fileprivate func setupViews() {
        let padding: UIEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        inputStack.layoutMargins = padding
        inputStack.isLayoutMarginsRelativeArrangement = true
        //        inputStack.backgroundColor = .lightGray
        inputStack.layer.cornerRadius = 10
        
        datePicker.maximumDate = Date()
        
        saveBtn.layer.cornerRadius = 10
    }
    
    fileprivate func createUser(firstName: String, lastName: String, age: Int) {
        let newUser = User()
        newUser.firstName = firstName
        newUser.lastName = lastName
        newUser.age = age
        
        realm.beginWrite()
        realm.add(newUser)
        try! realm.commitWrite()
    }
    
    fileprivate func readUsers() {
        let people = realm.objects(User.self)
        self.users = people.map({ $0 })
    }
    
    
    func updateUser(_ user: User) {
        // Create an alert controller
        let alertController = UIAlertController(title: "Update User", message: nil, preferredStyle: .alert)
        
        // Add text fields
        alertController.addTextField { textField in
            textField.placeholder = "First Name"
            textField.text = user.firstName // Display current value
        }
        
        alertController.addTextField { textField in
            textField.placeholder = "Last Name"
            textField.text = user.lastName // Display current value
        }
        
        // Add update button
        let updateAction = UIAlertAction(title: "Update User", style: .default) { _ in
            // Handle the update action here
            if let firstNameTextField = alertController.textFields?.first,
               let lastNameTextField = alertController.textFields?.last
//               let age = Calendar.current.dateComponents([.year], from: Calendar.current.startOfDay(for: datePicker.date), to: Calendar.current.startOfDay(for: Date())).year
            {
                let firstName = firstNameTextField.text ?? ""
                let lastName = lastNameTextField.text ?? ""
                // Perform update based on name, and date picker values
                do {
                    let realm = try Realm()
                    if let userToUpdate = realm.objects(User.self).filter("id == %@", user.id).first {
                        try realm.write {
                            userToUpdate.firstName = firstName
                            userToUpdate.lastName = lastName
//                            userToUpdate.age = age
                        }
                        print("updated data to: first Name \(user.firstName), last name \(user.lastName) and age is \(user.age)")
                        self.readUsers()
                        
                        // With an alert to provide feedback
                        let successAlert = UIAlertController(title: "Update Successful", message: "User information has been updated for \(user.firstName) \(user.lastName).", preferredStyle: .alert)
                        successAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                            self.readUsers()
                        }))
                        self.present(successAlert, animated: true, completion: nil)
                    }
                } catch {
                    print("Error updating task: \(error)")
                }
                
            }
        }
        
        alertController.addAction(updateAction)
        
        // Add cancel button
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        // Present the alert
        present(alertController, animated: true, completion: nil)
    }
    

    
    func deleteUser(_ user: User) {
        do {
            if let userToDelete = realm.objects(User.self).filter("id == %@", user.id).first {
                try realm.write {
                    print("delete user: \(user.firstName)")
                    realm.delete(userToDelete)
                }
                readUsers()
            }
        } catch {
            print("Error deleting user \(user.firstName): \(error)")
        }
    }
    
    @IBAction func saveBtnPressed(_ sender: UIButton) {
        if let firstName = firstNameLabel.text,
           let lastName = lastNameLabel.text,
           let age = Calendar.current.dateComponents([.year], from: Calendar.current.startOfDay(for: datePicker.date), to: Calendar.current.startOfDay(for: Date())).year
        {
            createUser(firstName: firstName, lastName: lastName, age: age)
            readUsers()
            
            resetInputFields()
        } else {
            print("Error in saving User!")
        }
    }
    
    func resetInputFields() {
        firstNameLabel.text = ""
        lastNameLabel.text = ""
        datePicker.date = Date()
    }
}

class User: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var age: Int = 0
}
