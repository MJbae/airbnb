//
//  WishListCell.swift
//  Arirbnb
//
//  Created by 지북 on 2021/06/04.
//

import UIKit

class WishListCell: UICollectionViewCell, UINibCreateable {

    @IBOutlet weak var wishListImageView: UIImageView!
    @IBOutlet weak var accommodationNameLabel: UILabel!
    @IBOutlet weak var perPriceLabel: UILabel!
    
    func configure(_ item: WishListItem) {
        wishListImageView.load(url: item.mainImageUrl)
        accommodationNameLabel.text = item.accommodationName
        perPriceLabel.text = String(item.price ?? 0)
    }
}
