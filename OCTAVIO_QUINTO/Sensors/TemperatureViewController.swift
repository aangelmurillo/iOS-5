//
//  TemperatureViewController.swift
//  OCTAVIO_QUINTO
//
//  Created by Federico Mireles on 18/07/24.
//

import UIKit

class TemperatureViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchUserIdentifier()
    }
}
