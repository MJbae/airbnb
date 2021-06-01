//
//  Calendar.swift
//  Arirbnb
//
//  Created by 지북 on 2021/05/28.
//

import UIKit
import HorizonCalendar

protocol DateInfoReceivable {
    func updateDateInfo(date: Date, isLowerDate: Bool)
}

class DumbaCalendar: UIView {
    
    private var today: Date!
    private var currentYear: Int!
    private var currentMonth: Int!
    private var currentDay: Int!
    private var nextYear: Int!

    private var calendarView: CalendarView! = nil
    public var dateInfoReceivable: DateInfoReceivable?
    
    private var lowerDay: Day? {
        willSet{
            if newValue == nil { return }
            guard let lowerDate = Calendar.current.date(from: DateComponents(year: newValue?.components.year, month: newValue?.components.month, day: newValue?.components.day)) else { return }
            dateInfoReceivable?.updateDateInfo(date: lowerDate, isLowerDate: true)
        }
    }
    
    private var upperDay: Day? {
        willSet{
            if newValue == nil { return }
            guard let upperDate = Calendar.current.date(from: DateComponents(year: newValue?.components.year, month: newValue?.components.month, day: newValue?.components.day)) else { return }
            dateInfoReceivable?.updateDateInfo(date: upperDate, isLowerDate: false)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureDate()
        configureCalendarView()
        setDaySelectionHandler()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureDate()
        configureCalendarView()
        setDaySelectionHandler()
    }
    
    private func configureDate() {
        today = Date()
        currentYear = Int(today.year) ?? 0
        currentMonth = Int(today.month) ?? 0
        currentDay = Int(today.day) ?? 0
        nextYear = (Int(today.year) ?? 0) + 1
    }
    
    private func configureCalendarView() {
        self.calendarView = CalendarView(initialContent: makeContent())
        self.addSubview(calendarView)
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
          calendarView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
          calendarView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
          calendarView.topAnchor.constraint(equalTo: self.topAnchor),
          calendarView.heightAnchor.constraint(equalTo: self.heightAnchor)
        ])
    }
    
    private func setDaySelectionHandler() {
        self.calendarView.daySelectionHandler = { [weak self] day in
            guard let self = self else { return }
            guard self.isValidDayToSelect(day: day) else { return}
            
            self.updateDaySelection(with: day)
            self.recreateCalendarContentIfNeeded()
        }
    }
    
    private func updateDaySelection(with newDay: Day) {
        if lowerDay == nil && upperDay == nil {
            lowerDay = newDay
        } else if lowerDay != nil && upperDay == nil {
            if newDay <= lowerDay! {
                lowerDay = newDay
            } else {
                upperDay = newDay
            }
        } else {
            lowerDay = newDay
            upperDay = nil
        }
    }
    
    private func isValidDayToSelect(day: Day) -> Bool {
        let compareYear: Int = day.components.year ?? currentYear
        let compareMonth: Int = day.components.month ?? currentMonth
        let compareDay: Int = day.components.day ?? currentDay

        if compareYear > currentYear { return true }
        if compareYear == currentYear && compareMonth > currentMonth { return true }
        if compareYear == currentYear && compareMonth == compareMonth && compareDay >= currentDay { return true }
        return false
    }
    
    private func recreateCalendarContentIfNeeded() {
        if lowerDay != nil && upperDay != nil {
            let newContent = makeContentWithHighlightRange()
            calendarView.setContent(newContent)
            NotificationCenter.default.post(name: .selectDateDidChange, object: self, userInfo: [UserInfoKey.selectedLowerDay: lowerDay, UserInfoKey.selectedUpperDay: upperDay])
        } else {
            let newContent = makeContent()
            calendarView.setContent(newContent)
            
            NotificationCenter.default.post(name: .selectDateisChanging, object: self)
        }
    }
    
    private func makeContentWithHighlightRange() -> CalendarViewContent {
        guard let lowerDate = Calendar.current.date(from: DateComponents(year: self.lowerDay?.components.year, month: self.lowerDay?.components.month, day: self.lowerDay?.components.day)) else { return makeContent()}
        guard let upperDate = Calendar.current.date(from: DateComponents(year: self.upperDay?.components.year, month: self.upperDay?.components.month, day: self.upperDay?.components.day)) else { return makeContent()}
        
        let dateRangeToHighlight = lowerDate...upperDate
        
        let newContent = self.makeContent().withDayRangeItemModelProvider(for: [dateRangeToHighlight]) { dayRangeLayoutContext in
            CalendarItemModel<DayRangeIndicatorView>(
                invariantViewProperties: .init(),
                viewModel: .init(framesOfDaysToHighlight: dayRangeLayoutContext.daysAndFrames.map { $0.frame }))
        }
        return newContent
    }
    
    private func makeContent() -> CalendarViewContent {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "ko_KR")
        let endOfMonth = Int(calendar.date(byAdding: .day, value: -1, to: today)?.day ?? "1") ?? 1
        let startDate = calendar.date(from: DateComponents(year: currentYear, month: currentMonth, day: 1)) ?? Date()
        let endDate = calendar.date(from: DateComponents(year: nextYear, month: currentMonth, day: endOfMonth)) ?? Date()
        
        return CalendarViewContent(
            calendar: calendar,
            visibleDateRange: startDate...endDate,
            monthsLayout: .vertical(options: VerticalMonthsLayoutOptions()))
            
            .withDayItemModelProvider { day in
                var invariantViewProperties: DayLabel.InvariantViewProperties = .init(
                    font: UIFont.systemFont(ofSize: 18),
                    textColor: .darkGray,
                    backgroundColor: .clear)
                
                if self.isValidDayToSelect(day: day) {
                    if day == self.lowerDay || day == self.upperDay {
                        invariantViewProperties.textColor = .white
                        invariantViewProperties.backgroundColor = #colorLiteral(red: 0.9098039216, green: 0.2980392157, blue: 0.3764705882, alpha: 1)
                    }
                } else {
                    invariantViewProperties.textColor = UIColor.systemGray2
                }
                
                return CalendarItemModel<DayLabel>(
                    invariantViewProperties: invariantViewProperties,
                    viewModel: .init(day: day))
                }
        
            .withInterMonthSpacing(24)
            .withVerticalDayMargin(8)
            .withHorizontalDayMargin(8)
    }
    
    public func clearCalendarView() {
        self.lowerDay = nil
        self.upperDay = nil
        
        self.calendarView.setContent(makeContent())
    }
}
