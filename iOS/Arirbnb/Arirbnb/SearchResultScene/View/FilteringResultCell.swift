//
//  SearchResultCell.swift
//  Arirbnb
//
//  Created by 지북 on 2021/06/02.
//

import UIKit

class FilteringResultCell: UICollectionViewCell, UINibCreateable {

    @IBOutlet private weak var thumbImageView: UIImageView!
    @IBOutlet private weak var starPointLabel: UILabel!
    @IBOutlet private weak var reviewCountLabel: UILabel!
    @IBOutlet private weak var accommodationNameLabel: UILabel!
    @IBOutlet private weak var pricePerDayLabel: UILabel!
    @IBOutlet private weak var totalPriceLabel: UILabel!
    
    func configure(accommodation: Accommodation, totalPrice: Int?) {
        thumbImageView.load(url: accommodation.mainImageUrl)
        accommodationNameLabel.text = accommodation.name
        pricePerDayLabel.text = String(accommodation.price ?? 0) + "원"
        totalPriceLabel.text = String(totalPrice ?? 0) + "원"
    }
}
