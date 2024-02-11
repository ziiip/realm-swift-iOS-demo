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
        
        createUser(firstName: "Sajid", lastName: "Hasan", age: 23)
        createUser(firstName: "Fuad", lastName: "Hasan", age: 54)
        
        readUsers()
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
}

class User: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var age: Int = 0
}
