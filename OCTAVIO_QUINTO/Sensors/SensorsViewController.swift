//
//  SensorsViewController.swift
//  OCTAVIO_QUINTO
//
//  Created by Federico Mireles on 11/07/24.
//

import UIKit

class SensorsViewController: SwipeDismissableViewController {
    @IBOutlet var btnsSensors: [UIButton]!
    @IBOutlet var viewsSensors: [UIView]!
    
    var selectedUser: User?

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        for view in viewsSensors {
            view.makeRoundView(cornerRadius: 10.0)
        }
        if let user = selectedUser {
            configureCenteredNavBar(title: user.user_name, subtitle: user.helmet.helmet_serial_number)
            print("User Email: \(user.email)")
        }
    }
    
    
}
