//
//  ViewController.swift
//  ExploreRealm
//
//  Created by Sajid Shanta on 8/2/24.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    
    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createUser(firstName: "Sajid", lastName: "Hasan", age: 23)
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
}

class User: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var age: Int = 0
}
