//
//  UserTableViewCell.swift
//  ExploreRealm
//
//  Created by Sajid Shanta on 11/2/24.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var userLabel: UILabel!
    
    
    var closure: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func populateData(user: User) {
        let userId = user.id
        let firstName = user.firstName
        let lastName = user.lastName
        let age = user.age
        let fullName = firstName + " " + lastName
        
        userLabel.text = "\(fullName) is \(age) years old!"
    }
    
    @IBAction func deleteBtn(_ sender: Any) {
        closure?()
    }
}
