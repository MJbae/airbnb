//
//  PersonFilteringDataSource.swift
//  Arirbnb
//
//  Created by 지북 on 2021/06/01.
//

import UIKit

class PersonFilteringDataSource: NSObject, UITableViewDataSource {
    
    private var personFilters: [PersonFilter]
    
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
    
    override init() {
        self.personFilters = []
        super.init()
        configurePersonFilters()
    }
    
    
    private func configurePersonFilters() {
        personFilters = PersonSection.allCases.map({ section in
            PersonFilter.init(personType: section.titleToKorean(), description: section.describeToKorean(), count: 0, minusButtonValidate: false, plustButtonValidate: true)
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        PersonSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PersonFilteringCell.reuseIdentifier) as? PersonFilteringCell
        cell?.selectionStyle = .none
        let item = personFilters[indexPath.item]
        cell?.configure(item, indexPath.item)
        
        return cell ?? UITableViewCell()
    }
    
    func plus(_ section: Int) {
        buttonEnable(section)
        personFilters[section].count += 1
        checkDefaultAdult(section)
        
        if personFilters[section].count == 8 {
            personFilters[section].plustButtonValidate = false
        }
       
    }
    
    func minus(_ section: Int) {
        personFilters[section].count -= 1
        buttonEnable(section)
        if personFilters[section].count == 0 {
            personFilters[section].minusButtonValidate = false
        }
    }
    
    func totalPeopleToString() -> String {
        let gusetCount = personFilters[PersonSection.Adult.rawValue].count + personFilters[PersonSection.Children.rawValue].count
        let infantCount = personFilters[PersonSection.Infant.rawValue].count
        if infantCount == 0 {
            return "게스트 \(gusetCount)명"
        } else {
            return "게스트 \(gusetCount)명 유아 \(infantCount)명"
        }
    }
    
    func reset() {
        configurePersonFilters()
    }
    
    private func checkDefaultAdult(_ section: Int) {
        if (section == PersonSection.Children.rawValue || section == PersonSection.Infant.rawValue) && personFilters[PersonSection.Adult.rawValue].count == 0 {
            personFilters[PersonSection.Adult.rawValue].count += 1
            buttonEnable(PersonSection.Adult.rawValue)
        }
    }
    
    private func buttonEnable(_ section: Int) {
        personFilters[section].plustButtonValidate = true
        personFilters[section].minusButtonValidate = true
    }
    
    private func isPlusAble(_ number: Int) -> Bool {
        return number < 8
    }
    
    private func isMinusAble(_ number: Int) -> Bool {
        return number > 0
    }
    
    func isDefaultValues() -> Bool {
        let defaultPersons = personFilters.filter { personType in
            personType.count == 0
        }
        
        return defaultPersons.count == personFilters.count
    }
}

