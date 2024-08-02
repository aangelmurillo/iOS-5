//
//  CameraViewController.swift
//  OCTAVIO_QUINTO
//
//  Created by Federico Mireles on 18/07/24.
//

import UIKit

class CameraViewController: UIViewController {
    
    var selectedUser: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = selectedUser {
            print("User Name: \(user.user_name)")
            print("User Email: \(user.email)")
            print("Helmet Serial Number: \(user.helmet.helmet_serial_number)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let user = selectedUser {
            configureCenteredNavBar(title: user.user_name, subtitle: user.helmet.helmet_serial_number)
        }
    }
}
