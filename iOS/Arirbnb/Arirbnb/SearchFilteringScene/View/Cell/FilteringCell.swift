//
//  FilteringCell.swift
//  Arirbnb
//
//  Created by 지북 on 2021/05/26.
//

import UIKit

class FilteringCell: UITableViewCell {
    static let reuseIdentifier = "FilteringCell"
    static var nib: UINib {
        return UINib(nibName: reuseIdentifier, bundle: nil)
    }
    
    @IBOutlet weak var filteringName: UILabel!
    @IBOutlet weak var filteringValue: UILabel!
    
    func configure(item: FilterItem?) {
        guard let item = item else { return }
        filteringName.text = item.filteringName
        filteringValue.text = item.filteringValue
    }
}
