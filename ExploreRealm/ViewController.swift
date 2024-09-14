//
//  ViewController.swift
//  ExploreRealm
//
//  Created by Xcode on 19/2/24.
//

import UIKit
import RealmSwift

// 定义一个遵循 Encodable 协议的模型对象
// 定义一个遵循 Encodable 协议的类
class Person: Codable {
    var name: String
    var age: Int

    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}


class ViewController: UIViewController {

    @IBOutlet weak var inputStack: UIStackView!
    @IBOutlet weak var firstNameLabel: UITextField!
    @IBOutlet weak var lastNameLabel: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var deleteAllBtn: UIButton!

    var users: [User] = [] {
        didSet {
            tableView.reloadData()
        }
    }



    let realm: Realm = {
        var config = Realm.Configuration.defaultConfiguration
        config.schemaVersion = 8
        config.migrationBlock = { migration, oldSchemaVersion in

        }

        let realm = try! Realm(configuration: config)
        return realm
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: "UserTableViewCell")

        setupViews()
        readUsers()

        let defaultRealmPath = Realm.Configuration.defaultConfiguration.fileURL?.path
        print("Realm default path: \(defaultRealmPath ?? "Not found")")

        var dogsByFirstLetter: SectionedResults<String, User>
        let sectionedResults = realm.objects(User.self).sorted(byKeyPath: "firstName").sectioned(by: \.firstName)
        for section in sectionedResults {
            print("Age: \(section.id)")

            for person in section {
                print("- \(person.firstName)")
            }
        }



//        let people = realm.objects(Address.self).where{
//            $0.city == "Springfield"
//        }
//        let clubs = people.first!.users

//        print("-----"   + "\(clubs)")

//        let users = realm.objects(User.self)
//        for user in users {
//            if case let .date(companion) = user.companion {
//                  print("\(user.name)'s companion is: \(companion)")
//                  // Prints "Wolfie's companion is: Fluffy the Cat"
//              }
//        }


    }

    fileprivate func setupViews() {
        let padding: UIEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        inputStack.layoutMargins = padding
        inputStack.isLayoutMarginsRelativeArrangement = true
        //        inputStack.backgroundColor = .lightGray
        inputStack.layer.cornerRadius = 10

        datePicker.maximumDate = Date()

        saveBtn.layer.cornerRadius = 10
        deleteAllBtn.layer.cornerRadius = 10
    }

    fileprivate func createUser(firstName: String, lastName: String, age: Int) {

//        let string = "{\"sex\":1,\"age\":0,\"firstName\":\"你好1\",\"lastName\":\"北京1\"}"
//        let data = string.data(using: .utf8)!
//        try! realm.write {
//            let json = try! JSONSerialization.jsonObject(with: data, options: [])
//            realm.create(User.self, value: json)
//        }

        let newUser = User()
        newUser.firstName = firstName
        newUser.lastName = lastName
        newUser.companion = .date(Date())
        newUser.companion = .string("任意类型")
        try! realm.write {
            realm.add(newUser)
        }


//
//        realm.beginWrite()
//        realm.add(newUser)
//        try! realm.commitWrite()
    }

    fileprivate func readUsers() {
        let people = realm.objects(User.self)
        self.users = people.map({ $0 })

        var jsonArray = [[String : Any]]()

        for person in self.users {
            // 使用 JSONEncoder 将模型对象编码为 JSON 数据
//            print("favoriteParksByCity----：\(person.favoriteParksByCity["Chicago"] ?? "")")
//            print("favoriteParksByCity----：\(person.favoriteParksByCity["New York"] ?? "")")

            do {
                let jsonData = try JSONEncoder().encode(person)

                // 将 JSON 数据转成字符串
                if let jsonString = String(data: jsonData, encoding: .utf8) {
//                    print(jsonString)
                }
            } catch {
                print("转换为 JSON 失败：\(error)")
            }

        }

//        // 输出结果
//        let jsonData = try! JSONSerialization.data(withJSONObject: jsonArray, options: .prettyPrinted)
//        let jsonString = String(data: jsonData, encoding: .utf8)!
//        print(jsonString)
//
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

    @IBAction func deleteAllBtnPressed(_ sender: Any) {
        let deleteAllAlert = UIAlertController(title: "Sure?", message: "Are you sure to delete all users!", preferredStyle: .alert)
        deleteAllAlert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { _ in
            // delete all user
            do {
                try self.realm.write {

                    // if I nee to delete every thing!
                    //self.realm.deleteAll()

                    //If delete only all user
                    let usersToDelete = self.realm.objects(User.self)
                    self.realm.deleteAll()

                    print("All users deleted")
                    self.readUsers()
                }
            } catch {
                print("Error deleting all users: \(error)")
            }
        }))

        // Cancel Action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        deleteAllAlert.addAction(cancelAction)

        self.present(deleteAllAlert, animated: true, completion: nil)
    }

}

class Address:Object, Codable {
    @Persisted var street: String?
    @Persisted var city: String?
    @Persisted var country: String?
    @Persisted var postalCode: String?
    @Persisted(originProperty: "address") var users: LinkingObjects<User>

    // 实现 Encodable 协议
     enum CodingKeys: String, CodingKey {
         case street
         case city
         case country
         case postalCode
     }

    // 遵循 Encodable 协议并实现 encode(to:) 方法
       func encode(to encoder: Encoder) throws {
           var container = encoder.container(keyedBy: CodingKeys.self)
           try container.encode(street, forKey: .street)
           try container.encode(city, forKey: .city)
           try container.encode(country, forKey: .country)
           try container.encode(postalCode, forKey: .postalCode)
       }
}

class User: Object,Codable {
    @Persisted(primaryKey: true) var id: String = UUID().uuidString
    @Persisted(indexed: true) var firstName: String = ""
    @Persisted var lastName: String = ""
    @Persisted var age: Int = 0
    @Persisted var sex: Int = 0
    @Persisted var email1: String?

    @Persisted var address: Address?

    @Persisted var favoriteParksByCity: Map<String, String>
    @Persisted var citiesVisited: MutableSet<String>

    @Persisted var companion: AnyRealmValue

    @Persisted var position2d: CGPoint?
    var tmpId = 0

    var name: String {
         return "\(firstName) \(lastName)"
     }

    @objc dynamic var email = ""


    // 自定义编码方法
    enum CodingKeys: String, CodingKey {
        case id
        case firstName
        case lastName
        case age
        case sex
        case email1
        case favoriteParksByCity
        case address
        case citiesVisited
    }

    required override init() {
        super.init()
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decode(String.self, forKey: .lastName)
        age = try container.decode(Int.self, forKey: .age)
        sex = try container.decode(Int.self, forKey: .sex)
        email1 = try container.decode(String.self, forKey: .email1)
        address = try container.decode(Address.self, forKey: .address)
        favoriteParksByCity = try container.decode(Map.self, forKey: .favoriteParksByCity)
        citiesVisited = try container.decode(MutableSet.self, forKey: .citiesVisited)
        super.init()
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(age, forKey: .age)
        try container.encode(sex, forKey: .sex)
        try container.encode(email1, forKey: .email1)
        try container.encode(favoriteParksByCity, forKey: .favoriteParksByCity)
        if let unwrappedAddress = address {
            try unwrappedAddress.encode(to: encoder)
        }
    }

}


// MARK: - CGPoint
extension CGPoint: CustomPersistable {
    public typealias PersistedType = PersistablePoint
    public init(persistedValue: PersistablePoint) { self.init(x: persistedValue.x, y: persistedValue.y) }
    public var persistableValue: PersistablePoint { PersistablePoint(self) }
}

public class PersistablePoint: EmbeddedObject {
    @Persisted var x = 0.0
    @Persisted var y = 0.0

    convenience init(_ point: CGPoint) {
        self.init()
        self.x = point.x
        self.y = point.y
    }
}
