//
//  FilteringTableViewDataSource.swift
//  Arirbnb
//
//  Created by 지북 on 2021/06/01.
//

import UIKit

class FilteringTableViewDataSource: NSObject, UITableViewDataSource {
    
    private var items: [FilterItem]?
    
    enum FilteringSection: Int, CaseIterable {
        case location, checkInOut, price, numberOfPeople
        
        func filteringName() -> String {
            switch self {
            case .location: return "위치"
            case .checkInOut: return "체크인/체크아웃"
            case .price: return "요금"
            case .numberOfPeople: return "인원"
            }
        }
    }
    
    override init() {
        items = FilteringSection.allCases.map({ section in
            FilterItem.init(filteringName: section.filteringName())
        })
        super.init()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FilteringCell.reuseIdentifier) as? FilteringCell
        cell?.configure(item: items?[indexPath.item])
        return cell ?? UITableViewCell()
    }
    
    func setDestination(_ destination: String? = "") {
        items?[FilteringSection.location.rawValue].filteringValue = destination
    }
    
    func checkInOutChange(_ description: String) {
        items?[FilteringSection.checkInOut.rawValue].filteringValue = description
    }
    
    func numberOfPeopleChange(_ description: String) {
        items?[FilteringSection.numberOfPeople.rawValue].filteringValue = description
    }
}
