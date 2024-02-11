//
//  ViewController+TableView.swift
//  ExploreRealm
//
//  Created by Sajid Shanta on 11/2/24.
//

import Foundation
import UIKit

extension ViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as! UserTableViewCell
        cell.populateData(user: users[indexPath.row])
        cell.editClosure = { [weak self]  in
            guard let self else { return }
            print(users[indexPath.item])
            self.updateUser(users[indexPath.item])
        }
        cell.deleteClosure = { [weak self]  in
            guard let self else { return }
            print(users[indexPath.item])
            self.deleteUser(users[indexPath.item])
        }
        return cell
    }
}
