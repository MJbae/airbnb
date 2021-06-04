//
//  DetailAccommodation.swift
//  Arirbnb
//
//  Created by 지북 on 2021/06/04.
//

import Foundation

struct DetailAccommodation: Decodable {
    var name: String?
    var maxPeople: Int?
    var type: String?
    var numOfBed: Int?
    var numOfBathroom: Int?
    var price: Int?
    var hostName: String?
    var description: String?
    var images: [String]?
}
