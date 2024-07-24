//
//  CrudBtnsViewController.swift
//  OCTAVIO_QUINTO
//
//  Created by Federico Mireles on 24/07/24.
//

import UIKit

class CrudBtnsViewController: UIViewController {

    
    @IBOutlet weak var BtnEli: UIButton!
    @IBOutlet weak var BtnEdit: UIButton!
    @IBOutlet weak var btnRE: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        btnRE.makeRoundButton(cornerRadius: 5)
        BtnEli.makeRoundButton(cornerRadius: 5)
        BtnEdit.makeRoundButton(cornerRadius: 5)
       
        configureCustomNavigationBar(title: "Ing. Octavio", subtitle: "octavio@gmail.com")
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
