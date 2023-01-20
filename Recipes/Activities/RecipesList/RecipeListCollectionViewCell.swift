//
//  RecipeListCollectionViewCell.swift
//  Recipes
//
//

import UIKit

final class RecipeListCollectionViewCell: UICollectionViewCell {
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .white
        titleLabel.font = UIFont.preferredFont(forTextStyle: .callout)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    private let dishTypesLabel: UILabel = {
        let dishTypesLabel = UILabel()
        dishTypesLabel.textColor = .white
        dishTypesLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        dishTypesLabel.translatesAutoresizingMaskIntoConstraints = false
        return dishTypesLabel
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
        
    private lazy var recipeInformationContainerView: UIStackView = {
        let containerView = UIStackView(arrangedSubviews: [self.titleLabel, self.dishTypesLabel])
        containerView.axis = .vertical
        containerView.backgroundColor = ColorPalette.orange
        containerView.spacing = 0
        containerView.distribution = .fillEqually
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layoutMargins = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        containerView.isLayoutMarginsRelativeArrangement = true
        return containerView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        contentView.addSubview(imageView)
        contentView.addSubview(recipeInformationContainerView)
        contentView.addSubview(badgeView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.80)
        ])
        
        NSLayoutConstraint.activate([
            recipeInformationContainerView.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            recipeInformationContainerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            recipeInformationContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            recipeInformationContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            recipeInformationContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            recipeInformationContainerView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.20)
        ])
        
        NSLayoutConstraint.activate([
            badgeView.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 12),
            badgeView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -12),
            badgeView.heightAnchor.constraint(equalToConstant: 40),
            badgeView.widthAnchor.constraint(equalToConstant: 40),
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        dishTypesLabel.text = nil
        imageView.image = nil
    }
}

extension RecipeListCollectionViewCell {
    
    func configureFor(viewModel: RecipeListCollectionViewCelViewModel) {
        titleLabel.text = viewModel.title
        dishTypesLabel.text = viewModel.dishTypes
        imageView.load(url: viewModel.imageURL)
        badgeView.setBadgeValue(value: viewModel.badgeValue)
    }
}
