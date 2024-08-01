//
//  EnvironmentViewController.swift
//  OCTAVIO_QUINTO
//
//  Created by Federico Mireles on 23/07/24.
//

import UIKit

class EnvironmentViewController: UIViewController {

    @IBOutlet var lblsEnv: [UILabel]!
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in lblsEnv{
            i.adjustFontSize()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchUserIdentifier()
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
