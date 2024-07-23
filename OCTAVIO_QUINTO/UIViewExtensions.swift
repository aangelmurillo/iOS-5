//
//  UIViewExtensions.swift
//  OCTAVIO_QUINTO
//
//  Created by Federico Mireles on 12/07/24.
//

import Foundation
import UIKit

extension UIView {
    func makeRoundView (cornerRadius: CGFloat? = nil) {
        if let radius = cornerRadius {
            self.layer.cornerRadius = radius
        } else {
            self.layer.cornerRadius = self.frame.size.width / 2.0
        }
        self.clipsToBounds = true
    }
}

extension UIButton {
    func makeRoundButton(cornerRadius: CGFloat? = nil) {
        if let radius = cornerRadius {
            self.layer.cornerRadius = radius
        } else {
            self.layer.cornerRadius = self.frame.size.width / 2.0
        }
        self.clipsToBounds = true
    }
    
    
}

extension UILabel {
    func adjustFontSize() {
        let bounds = UIScreen.main.bounds
        let height = bounds.size.height
        let scaleFactor = height / 800.0
        self.font = self.font.withSize(self.font.pointSize * scaleFactor)
    }
}
