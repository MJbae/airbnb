//
//  SearchFlowView.swift
//  Arirbnb
//
//  Created by 지북 on 2021/05/28.
//

import UIKit

class SearchFlowView: UIView {
    private var skipButton = UIButton()
    private var eraseButton = UIButton()
    private var nextButton = UIButton()
    
    private let defaultColor = #colorLiteral(red: 0.9367293119, green: 0.3948215544, blue: 0.4507040977, alpha: 1)
    private let unableColor = #colorLiteral(red: 0.7362961781, green: 0.3136540533, blue: 0.3689730703, alpha: 0.7572233693)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemGray6
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .systemGray6
        configure()
    }
    
    func configure() {
        skipButton.setTitle("건너뛰기", for: .normal)
        skipButton.setTitleColor(defaultColor, for: .normal)
        
        eraseButton.setTitle("지우기", for: .normal)
        eraseButton.setTitleColor(defaultColor, for: .normal)
        
        nextButton.setTitle("다음", for: .normal)
        nextButton.setTitleColor(unableColor, for: .normal)
        nextButton.isEnabled = false
        
        addSubview(skipButton)
        addSubview(nextButton)
        
        configureDefaultLayout()
        
        nextButton.addTarget(self, action: #selector(nextButtonDidTap(_:)), for: .touchUpInside)
        skipButton.addTarget(self, action: #selector(nextButtonDidTap(_:)), for: .touchUpInside)
        eraseButton.addTarget(self, action: #selector(eraseButtonDidTap(_:)), for: .touchUpInside)
    }
    
    private func configureDefaultLayout() {
        addNextButton()
        addSkipButton()
    }
    
    private func addNextButton() {
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nextButton.topAnchor.constraint(equalTo: topAnchor, constant: 14),
            nextButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    private func addSkipButton() {
        addSubview(skipButton)
        
        skipButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            skipButton.topAnchor.constraint(equalTo: topAnchor, constant: 14),
            skipButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        ])
    }
    
    private func addEraseButton() {
        addSubview(eraseButton)
        
        eraseButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            eraseButton.topAnchor.constraint(equalTo: topAnchor, constant: 14),
            eraseButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        ])
    }
    
    func meetTheConditions() {
        nextButton.setTitleColor(defaultColor, for: .normal)
        nextButton.isEnabled = true
        
        skipButton.removeFromSuperview()
        addEraseButton()
    }
    
    func doNotMeetTheConditions() {
        nextButton.setTitleColor(unableColor, for: .normal)
        nextButton.isEnabled = false
        
        eraseButton.removeFromSuperview()
        addSkipButton()
    }
    
    @objc private func nextButtonDidTap(_ sendor: UIButton) {
        NotificationCenter.default.post(name: .moveSearchFlowNextStep, object: self)
    }
    
    @objc private func eraseButtonDidTap(_ sendor: UIButton) {
        NotificationCenter.default.post(name: .resetFiltering, object: self)
    }
}
