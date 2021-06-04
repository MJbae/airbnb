//
//  Accommodation.swift
//  Arirbnb
//
//  Created by 지북 on 2021/06/04.
//

import Foundation

struct Accommodation: Decodable {
    var name: String?
    var maxPeople: Int?
    var type: String?
    var numOfBed: Int?
    var numOfBathroom: Int?
    var price: Int?
    var mainImageUrl: String?
}
