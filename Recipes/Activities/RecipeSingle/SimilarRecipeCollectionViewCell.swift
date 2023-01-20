//
//  SimilarRecipeCollectionViewCell.swift
//  Recipes
//
//

import UIKit

class SimilarRecipeCollectionViewCell: UICollectionViewCell {
    
    private let titleContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorPalette.green
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .black
        titleLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let badgeView: BadgeView = {
        let badgeView = BadgeView(frame: .zero)
        badgeView.translatesAutoresizingMaskIntoConstraints = false
        return badgeView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        
        backgroundColor = .white
        contentView.addSubview(imageView)
        contentView.addSubview(badgeView)
        contentView.addSubview(titleContainerView)
        titleContainerView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            badgeView.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 12),
            badgeView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -12),
            badgeView.heightAnchor.constraint(equalToConstant: 40),
            badgeView.widthAnchor.constraint(equalToConstant: 40),
        ])
        
        NSLayoutConstraint.activate([
            titleContainerView.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            titleContainerView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            titleContainerView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            titleContainerView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.2),
            titleContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: titleContainerView.leadingAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: titleContainerView.trailingAnchor, constant: -4),
            titleLabel.centerYAnchor.constraint(equalTo: titleContainerView.centerYAnchor)
        ])
    }
}

extension SimilarRecipeCollectionViewCell {
    
    func configureForViewModel(_ viewModel: SimilarRecipeCollectionViewCellViewModel) {
        titleLabel.text = viewModel.title
        imageView.load(url: viewModel.imageURL)
        badgeView.setBadgeValue(value: viewModel.badgeValue)
    }
}
