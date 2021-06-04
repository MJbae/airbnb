//
//  SearchResult.swift
//  Arirbnb
//
//  Created by 지북 on 2021/06/02.
//

import Foundation
import HorizonCalendar

struct SearchResult {
    var destination: String?
    var checkInDate: Day?
    var checkOutDate: Day?
    var totalDay: Int?
    var minPrice: Int?
    var maxPrice: Int?
    var numOfAdult: Int?
    var numOfChild: Int?
    var numOfInfant: Int?
}
