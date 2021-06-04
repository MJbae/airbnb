//
//  WishListItem.swift
//  Arirbnb
//
//  Created by 지북 on 2021/06/04.
//

import Foundation

struct WishListItem: Decodable {
    var accommodationName: String?
    var price: Int?
    var mainImageUrl: String?
}
