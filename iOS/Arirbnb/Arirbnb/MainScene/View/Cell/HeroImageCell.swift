//
//  HeroImageCell.swift
//  Arirbnb
//
//  Created by 지북 on 2021/05/18.
//

import UIKit

class HeroImageCell: UICollectionViewCell {
    static let reuseIdentifier = "HeroImageCell"
    
    var heroImageView =  UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    func configure() {
        contentView.addSubview(heroImageView)
        
        heroImageView.translatesAutoresizingMaskIntoConstraints = false
        heroImageView.backgroundColor = .green
        
        NSLayoutConstraint.activate([
            heroImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            heroImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            heroImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            heroImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
