//
//  SearchResultUseCase.swift
//  Arirbnb
//
//  Created by 지북 on 2021/06/03.
//

import Foundation

import Alamofire
import HorizonCalendar

class SearchResultManager {
    
    private var searchResult = SearchResult()
    private (set) var filterDescript = ""
    static var shared = SearchResultManager()
    
    private init() {}
    
    func setDestination(_ destination: String?) {
        searchResult.destination = destination
        filterDescript += destination ?? ""
    }
    
    func setDate(_ checkInDate: Day?, _ checkOutDate: Day?, _ totalDay: Int?) {
        searchResult.checkInDate = checkInDate
        searchResult.checkOutDate = checkOutDate
        searchResult.totalDay = totalDay
        
        filterDescript += " • " + (checkInDate?.descriptionOnlyMonthDayForKorean ?? "")
        filterDescript += " - " + (checkOutDate?.descriptionOnlyMonthDayForKorean ?? "")
    }
    
    func setGuest(_ numOfAdult: Int?, _ numOfChild: Int?, _ numOfInfant: Int?) {
        searchResult.numOfAdult = numOfAdult
        searchResult.numOfChild = numOfChild
        searchResult.numOfInfant = numOfInfant
        
        filterDescript += " • " + "게스트 \((numOfAdult ?? 0 ) + (numOfChild ?? 0))명"
        if numOfInfant != nil && numOfInfant != 0 {
            filterDescript += ", 유아 \((numOfInfant ?? 0))명"
        }
    }
    
    func clearDate() {
        searchResult.checkInDate = nil
        searchResult.checkOutDate = nil
    }
    
    func clearGuest() {
        searchResult.numOfAdult = nil
        searchResult.numOfChild = nil
        searchResult.numOfInfant = nil
    }
    
    func selectedTotalDate() -> Int? {
        searchResult.totalDay
    }
    func parameter() -> Parameters {
        var parameter = Parameters()
        if searchResult.destination != nil {
            parameter["destination"] = searchResult.destination!
        }
        if searchResult.checkInDate != nil && searchResult.checkOutDate != nil {
            parameter["checkInDate"] = searchResult.checkInDate!.fullDate
            parameter["checkOutDate"] = searchResult.checkOutDate!.fullDate
        }
        if searchResult.minPrice != nil && searchResult.maxPrice != nil {
            parameter["minPrice"] = searchResult.minPrice!
            parameter["maxPrice"] = searchResult.maxPrice!
        }
        if searchResult.numOfAdult != nil {
            parameter["numOfAdult"] = searchResult.numOfAdult!
        }
        if searchResult.numOfChild != nil && searchResult.numOfChild != 0  {
            parameter["numOfChild"] = searchResult.numOfChild!
        }
        if searchResult.numOfInfant != nil && searchResult.numOfInfant != 0 {
            parameter["numOfInfant"] = searchResult.numOfInfant!
        }
        return parameter
    }
}
