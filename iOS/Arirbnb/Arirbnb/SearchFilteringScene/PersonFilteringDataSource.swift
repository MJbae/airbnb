//
//  PersonFilteringDataSource.swift
//  Arirbnb
//
//  Created by 지북 on 2021/06/01.
//

import UIKit

class PersonFilteringDataSource: NSObject, UITableViewDataSource {
    enum PersonSection:Int, CaseIterable {
        case Adult, Children, Infant
        
        func titleToKorean() -> String {
            switch self {
            case .Adult: return "성인"
            case .Children: return "어린이"
            case .Infant: return "유아"
            }
        }
        
        func describeToKorean() -> String {
            switch self {
            case .Adult: return "만 13세 이상"
            case .Children: return "만 2~12세"
            case .Infant: return "만 2세 미만"
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        PersonSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PersonFilteringCell.reuseIdentifier) as? PersonFilteringCell
        let section = PersonSection.allCases[indexPath.item]
        let item = PersonFilter(personType: section.titleToKorean(), description: section.describeToKorean())
        cell?.configure(item)
        
        return cell ?? UITableViewCell()
    }
}
