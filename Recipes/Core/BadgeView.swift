//
//  BadgeView.swift
//  Recipes
//
//

import UIKit

final class BadgeView: UIView {
    
    private let valueLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "0"
        label.translatesAutoresizingMaskIntoConstraints = false
       return label
    }()
    
    private let backgroundIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "hexagon.fill")
        imageView.tintColor = ColorPalette.darkGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(backgroundIcon)
        addSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            backgroundIcon.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundIcon.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundIcon.topAnchor.constraint(equalTo: topAnchor),
            backgroundIcon.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            valueLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            valueLabel.topAnchor.constraint(equalTo: topAnchor),
            valueLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setBadgeValue(value: String) {
        valueLabel.text = value
    }
}
