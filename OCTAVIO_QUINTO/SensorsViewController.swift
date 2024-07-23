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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        for view in viewsSensors
        {
            view.makeRoundView(cornerRadius: 10.0)        }
    }

}
