//
//  SliderView.swift
//  Arirbnb
//
//  Created by 지북 on 2021/06/01.
//

import UIKit
import SnapKit

class SliderView: UIView {
    
    private lazy var priceHeaderLabel = UILabel()
    private lazy var slider = DumbaSlider()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    @objc override func configure() {
        guard let superview = superview else { return }
        slider.translatesAutoresizingMaskIntoConstraints = false

        addSubview(slider)
        addSubview(priceHeaderLabel)
        
        priceHeaderLabel.text = "가격 범위"
        priceHeaderLabel.adjustsFontForContentSizeCategory = true
        priceHeaderLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        priceHeaderLabel.textColor = .black
        priceHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        

        priceHeaderLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 32).isActive = true
        priceHeaderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        
        let margin: CGFloat = 20
        let width = superview.bounds.width - 2 * margin
        let height: CGFloat = 20
        
        slider.frame = CGRect(x: 0, y: 0, width: width, height: height)
        slider.center = CGPoint(x: superview.center.x, y: superview.center.y - 100)
    }
}
