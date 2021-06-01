//
//  DayRangeIndicatorView.swift
//  Arirbnb
//
//  Created by 지북 on 2021/05/28.
//

import UIKit
import HorizonCalendar

final class DayRangeIndicatorView: UIView {
    
    private let indicatorColor: UIColor
    
    init() {
        self.indicatorColor = UIColor.systemPink.withAlphaComponent(0.3)
        super.init(frame: CGRect())
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        self.indicatorColor = UIColor.systemPink.withAlphaComponent(0.3)
        super.init(coder: coder)
    }
    
    var framesOfDaysToHighlight = [CGRect]() {
        didSet {
            guard framesOfDaysToHighlight != oldValue else { return }
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(indicatorColor.cgColor)
        
        var dayRowFrames = [CGRect]()
        var currentDayRowMinY: CGFloat?
        for dayFrame in framesOfDaysToHighlight {
            if dayFrame.minY != currentDayRowMinY {
                currentDayRowMinY = dayFrame.minY
                dayRowFrames.append(dayFrame)
            } else {
                let lastIndex = dayRowFrames.count - 1
                dayRowFrames[lastIndex] = dayRowFrames[lastIndex].union(dayFrame)
            }
        }
        
        for dayRowFrame in dayRowFrames {
            let roundedRectanglePath = UIBezierPath(roundedRect: dayRowFrame, cornerRadius: 20)
            context?.addPath(roundedRectanglePath.cgPath)
            context?.fillPath()
        }
    }
    
}

extension DayRangeIndicatorView: CalendarItemViewRepresentable {
    struct InvariantViewProperties: Hashable {
        let indicatorColor = UIColor.systemPink.withAlphaComponent(0.15)
    }
    
    struct ViewModel: Equatable {
        let framesOfDaysToHighlight: [CGRect]
    }
    
    static func makeView(withInvariantViewProperties invariantViewProperties: InvariantViewProperties) -> DayRangeIndicatorView {
        DayRangeIndicatorView()
    }
    
    static func setViewModel(_ viewModel: ViewModel, on view: DayRangeIndicatorView) {
        view.framesOfDaysToHighlight = viewModel.framesOfDaysToHighlight
    }
}
