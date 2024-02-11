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
        
    fileprivate func deleteUser(userId: String) {
        //TODO: delete user
        print("delete")
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
