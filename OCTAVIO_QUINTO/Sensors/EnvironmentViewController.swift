//
//  EnvironmentViewController.swift
//  OCTAVIO_QUINTO
//
//  Created by Federico Mireles on 23/07/24.
//

import UIKit

class EnvironmentViewController: UIViewController {

    @IBOutlet var lblsEnv: [UILabel]!
    
    var selectedUser: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        for i in lblsEnv{
            i.adjustFontSize()
        }
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
