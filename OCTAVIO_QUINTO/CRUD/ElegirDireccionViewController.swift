//
//  ElegirDireccionViewController.swift
//  OCTAVIO_QUINTO
//
//  Created by Adrian Gottfried on 07/08/24.
//

import UIKit

class ElegirDireccionViewController: UIViewController {

    var personData: [String: Any]?
    var userDictionary: [String: Any]?
    var helmetDictionary: [String: Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserIdentifier()
        // Do any additional setup after loading the view.
        print(personData ?? "No se encontró nada de personData")
        print(userDictionary ?? "No se encontró nada de userDictionary")
        print(helmetDictionary ?? "No se encontró nada de helmetDictionary")

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
