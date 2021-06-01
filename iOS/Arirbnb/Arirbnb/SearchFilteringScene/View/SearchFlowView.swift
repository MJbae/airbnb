//
//  SearchFlowView.swift
//  Arirbnb
//
//  Created by 지북 on 2021/05/28.
//

import UIKit

class SearchFlowView: UIView {
    var skipButton = UIButton()
    var eraseButton = UIButton()
    var nextButton = UIButton()
    
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
    
    @objc override  func configure() {
        skipButton.setTitle("건너뛰기", for: .normal)
        skipButton.setTitleColor(.black, for: .normal)
        
        eraseButton.setTitle("지우기", for: .normal)
        eraseButton.setTitleColor(.black, for: .normal)
        
        nextButton.setTitle("다음", for: .normal)
        nextButton.setTitleColor(.gray, for: .normal)
        nextButton.isEnabled = false
        
        addSubview(skipButton)
        addSubview(nextButton)
        
        configureDefaultLayout()
        
        nextButton.addTarget(self, action: #selector(nextButtonDidTap(_:)), for: .touchUpInside)
        skipButton.addTarget(self, action: #selector(nextButtonDidTap(_:)), for: .touchUpInside)
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
        nextButton.setTitleColor(.black, for: .normal)
        nextButton.isEnabled = true
        
        skipButton.removeFromSuperview()
        addEraseButton()
    }
    
    func doNotMeetTheConditions() {
        nextButton.setTitleColor(.gray, for: .normal)
        nextButton.isEnabled = false
        
        eraseButton.removeFromSuperview()
        addSkipButton()
    }
    
    @objc func nextButtonDidTap(_ sendor: UIButton) {
        NotificationCenter.default.post(name: .moveSearchFlowNextStep, object: self)
    }
}
