//
//  DumbaSlider.swift
//  Arirbnb
//
//  Created by 지북 on 2021/05/29.
//

import UIKit

class DumbaSlider: UIControl {
    var minimumValue: CGFloat = 0
    var maximumValue: CGFloat = 1
    var lowerValue: CGFloat = 0.0
    var upperValue: CGFloat = 1.0
    
    var thumbImage = #imageLiteral(resourceName: "pause")


    
    var trackTintColor = UIColor(white: 0.9, alpha: 1)
    var trackHighlightTintColor = #colorLiteral(red: 0.9098039216, green: 0.2980392157, blue: 0.3764705882, alpha: 1)
    
    private let lowerThumbImageView = UIImageView()
    private let upperThumbImageView = UIImageView()
    private var previousLocation = CGPoint()
    private let trackLayer = RangeSliderTrackLayer()
    
    override var frame: CGRect {
        didSet {
            updateLayerFrames()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    func configure() {
        trackLayer.rangeSlider = self
        trackLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(trackLayer)
        
        lowerThumbImageView.image = thumbImage
        addSubview(lowerThumbImageView)
        
        upperThumbImageView.image = thumbImage
        addSubview(upperThumbImageView)
        
    }
    
    private func updateLayerFrames() {
        trackLayer.frame = bounds.insetBy(dx: 0.0, dy: bounds.height / 3)
        trackLayer.setNeedsDisplay()
        lowerThumbImageView.frame = CGRect(origin: thumbOriginForValue(lowerValue),
                                           size: thumbImage.size)
        upperThumbImageView.frame = CGRect(origin: thumbOriginForValue(upperValue),
                                           size: thumbImage.size)
    }
    
    func positionForValue(_ value: CGFloat) -> CGFloat {
        return bounds.width * value
    }
    
    private func thumbOriginForValue(_ value: CGFloat) -> CGPoint {
        let x = positionForValue(value) - thumbImage.size.width / 2.0
        return CGPoint(x: x, y: (bounds.height - thumbImage.size.height) / 2.0)
    }
}

extension DumbaSlider {
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        // 1
        previousLocation = touch.location(in: self)
        
        // 2
        if lowerThumbImageView.frame.contains(previousLocation) {
            lowerThumbImageView.isHighlighted = true
        } else if upperThumbImageView.frame.contains(previousLocation) {
            upperThumbImageView.isHighlighted = true
        }
        
        // 3
        return lowerThumbImageView.isHighlighted || upperThumbImageView.isHighlighted
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        
        // 1
        let deltaLocation = location.x - previousLocation.x
        let deltaValue = (maximumValue - minimumValue) * deltaLocation / bounds.width
        
        previousLocation = location
        
        // 2
        if lowerThumbImageView.isHighlighted {
            lowerValue += deltaValue
            lowerValue = boundValue(lowerValue, toLowerValue: minimumValue,
                                    upperValue: upperValue)
        } else if upperThumbImageView.isHighlighted {
            upperValue += deltaValue
            upperValue = boundValue(upperValue, toLowerValue: lowerValue,
                                    upperValue: maximumValue)
        }
        
        // 3
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        updateLayerFrames()
        
        CATransaction.commit()
        
        return true
    }
    
    // 4
    private func boundValue(_ value: CGFloat, toLowerValue lowerValue: CGFloat,
                            upperValue: CGFloat) -> CGFloat {
        return min(max(value, lowerValue), upperValue)
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
      lowerThumbImageView.isHighlighted = false
      upperThumbImageView.isHighlighted = false
    }
}

class RangeSliderTrackLayer: CALayer {
  weak var rangeSlider: DumbaSlider?
    
    override func draw(in ctx: CGContext) {
      guard let slider = rangeSlider else {
        return
      }
      
      let path = UIBezierPath(roundedRect: bounds, cornerRadius: 10)
      ctx.addPath(path.cgPath)
      
      ctx.setFillColor(slider.trackTintColor.cgColor)
      ctx.fillPath()
      
      ctx.setFillColor(slider.trackHighlightTintColor.cgColor)
      let lowerValuePosition = slider.positionForValue(slider.lowerValue)
      let upperValuePosition = slider.positionForValue(slider.upperValue)
      let rect = CGRect(x: lowerValuePosition, y: 0,
                        width: upperValuePosition - lowerValuePosition,
                        height: bounds.height)
      ctx.fill(rect)
    }
}


