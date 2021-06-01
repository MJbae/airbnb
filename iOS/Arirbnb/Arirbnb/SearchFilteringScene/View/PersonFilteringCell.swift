//
//  PersonFilteringCell.swift
//  Arirbnb
//
//  Created by 지북 on 2021/06/01.
//

import UIKit

class PersonFilteringCell: UITableViewCell, UINibCreateable {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var countLabel: UILabel!
    
    
    func configure(_ item: PersonFilter) {
        titleLabel.text = item.personType
        descriptionLabel.text = item.description
    }
}
