//
//  SwipeDismissableViewController.swift
//  OCTAVIO_QUINTO
//
//  Created by Federico Mireles on 19/07/24.
//

import UIKit

class SwipeDismissableViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSwipeGesture()
    }
    
    private func setupSwipeGesture() {
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeGesture.direction = .right
        view.addGestureRecognizer(swipeGesture)
    }
    
    @objc private func handleSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
}
