//
//  UIView+Extension.swift
//  Arirbnb
//
//  Created by 지북 on 2021/06/01.
//

import UIKit

extension UIView {
    func configureFilteringViewLayout() {
        self.heightAnchor.constraint(equalTo: superview?.heightAnchor ?? NSLayoutDimension(), multiplier: 0.7).isActive = true
    }
    
    @objc func configure() { }
}
