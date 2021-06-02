//
//  UITableView+Extension.swift
//  Arirbnb
//
//  Created by 지북 on 2021/06/02.
//

import UIKit

extension UITableView {
    func configureFilteringTableView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isScrollEnabled = false
        self.isUserInteractionEnabled = false
        self.register(FilteringCell.nib, forCellReuseIdentifier: FilteringCell.reuseIdentifier)
        self.heightAnchor.constraint(equalToConstant: 170).isActive = true
    }
}
