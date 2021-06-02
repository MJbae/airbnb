//
//  Day+Extension.swift
//  Arirbnb
//
//  Created by 지북 on 2021/05/28.
//

import Foundation
import HorizonCalendar

extension Day {
    public var descriptionOnlyMonthDayForKorean: String {
        let monthDescription = String(format: "%02d", month.month)
        let dayDescription = String(format: "%02d", day)
        return "\(monthDescription)월 \(dayDescription)일"
    }
}
