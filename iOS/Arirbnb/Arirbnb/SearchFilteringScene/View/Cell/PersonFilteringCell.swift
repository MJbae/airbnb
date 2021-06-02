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
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    
    private var sectionNumber: Int?
    
    @IBAction func plustButtonDidTap(_ sender: UIButton) {
        NotificationCenter.default.post(name: .personPlustButtonDidTap, object: self, userInfo: [UserInfoKey.personSection: sectionNumber ?? 0])
    }
    
    @IBAction func minusButtonDidTap(_ sender: UIButton) {
        NotificationCenter.default.post(name: .personMinusButtonDidTap, object: self, userInfo: [UserInfoKey.personSection: sectionNumber ?? 0])
    }
    
    func configure(_ item: PersonFilter, _ sectionNumber: Int) {
        titleLabel.text = item.personType
        descriptionLabel.text = item.description
        countLabel.text = String(item.count)
        self.sectionNumber = sectionNumber
        
        plusButton.isEnabled = item.plustButtonValidate
        minusButton.isEnabled = item.minusButtonValidate
    }
}
