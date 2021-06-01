//
//  SliderView.swift
//  Arirbnb
//
//  Created by 지북 on 2021/06/01.
//

import UIKit

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
        slider.translatesAutoresizingMaskIntoConstraints = false
        priceHeaderLabel.text = "가격 범위"
        priceHeaderLabel.adjustsFontForContentSizeCategory = true
        priceHeaderLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        
        addSubview(slider)
        addSubview(priceHeaderLabel)
        
        
        let margin: CGFloat = 20
        let width = (superview?.bounds.width ?? 0) - 2 * margin
        let height: CGFloat = 30
        
        slider.frame = CGRect(x: 0, y: 0, width: width, height: height)
        slider.center = superview?.center ?? CGPoint.zero
    }
}
