//
//  FilterItems.swift
//  Arirbnb
//
//  Created by 지북 on 2021/05/26.
//

import Foundation

struct FilterItems {
    var items: [FilterItem]
}

struct FilterItem {
    var filteringName: String
    var filteringValue: String?
    
    init(filteringName: String, filteringValue: String? = nil) {
        self.filteringName = filteringName
        self.filteringValue = filteringValue
    }

}
