//
//  RecipeSingleViewController.swift
//  Recipes
//
//

import UIKit
import Combine

final class RecipeSingleViewController: UIViewController {
    
    // MARK: Private Properties
    
    private static let similarRecipeCellIdentifier = "similarRecipeCellIdentifier"
    private static let similarRecipeHeaderViewIdentifier = "similarRecipeHeaderViewIdentifier"
    
    private var cancellables: [AnyCancellable]
    private let viewModel: RecipeSingleViewModel
    
    // MARK: Private UI
    
    private let activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = ColorPalette.green
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    private let refreshControl: UIRefreshControl = {
       let refreshControl = UIRefreshControl()
       return refreshControl
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleView: UILabel = {
       let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
       return label
    }()
    
    private let instructionsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let summaryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        return label
    }()
    
    private let cuisinesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 5
        layout.scrollDirection = .horizontal
        layout.sectionInset = .zero
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SimilarRecipeCollectionViewCell.self, forCellWithReuseIdentifier: Self.similarRecipeCellIdentifier)
        collectionView.register(SimilarRecipeCollectionViewHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Self.similarRecipeHeaderViewIdentifier)
        return collectionView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView: UIScrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.refreshControl = refreshControl
        return scrollView
    }()
    
    // MARK: Lifecycle
    
    init(recipe: Recipe, cancellables: [AnyCancellable] = [AnyCancellable]() ) {
        self.viewModel = RecipeSingleViewModel(recipe: recipe)
        self.cancellables = cancellables
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        bindToViewModel()
        bindUIInteractions()
        fetchResources()
    }
    
    // MARK: Private Methods
    
    private func setUpUI() {
        
        title = viewModel.activityTitle
        view.backgroundColor = ColorPalette.orange
        
        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        scrollView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
            imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
            
        ])
        
        scrollView.addSubview(titleView)
        
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            titleView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 12),
            titleView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -12),
            titleView.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),
        ])
        
        scrollView.addSubview(summaryLabel)
        
        NSLayoutConstraint.activate([
            summaryLabel.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 8),
            summaryLabel.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: 12),
            summaryLabel.trailingAnchor.constraint(equalTo: titleView.trailingAnchor, constant: -12),
            summaryLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),
        ])
        
        scrollView.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: summaryLabel.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25),
            collectionView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        ])
        
        imageView.load(url: viewModel.recipeImageURL)
        titleView.text = viewModel.recipeTitle
        summaryLabel.attributedText = viewModel.recipeSummary
    }
    
    @objc private func fetchResources() {
        
        activityIndicatorView.startAnimating()
        viewModel.fetchSimilarRecipes()
    }
    
    private func bindToViewModel() {
        
        viewModel.similarRecipes$
            .receive(on: DispatchQueue.main)
            .replaceError(with: .success([Recipe]()))
            .sink { [weak self] result in
                switch result {
                case .success:
                    self?.collectionView.reloadData()
                case .failure:
                    break
                }
                self?.activityIndicatorView.stopAnimating()
                self?.refreshControl.endRefreshing()
            }.store(in: &cancellables)
    }
    
    private func bindUIInteractions() {
        refreshControl.addTarget(self, action: #selector(fetchResources), for: .valueChanged)
    }
    
    private func showErrorDialog(message:String = "Service not available") {
        let alertController = UIAlertController(title: "Oops", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}

extension RecipeSingleViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        
        guard kind == UICollectionView.elementKindSectionHeader else {
            fatalError("Bad Supplementary View Dequeue")
        }
        
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Self.similarRecipeHeaderViewIdentifier, for: indexPath) as? SimilarRecipeCollectionViewHeaderView else {
            fatalError("Bad Supplementary View Dequeue")
        }
        
        return header
            
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Self.similarRecipeCellIdentifier, for: indexPath) as? SimilarRecipeCollectionViewCell else {
            fatalError("Bad Recipe Cell Dequeue")
        }
        
        let selectedRecipe = viewModel.similarRecipeAtIndex(indexPath.row)
        let similarRecipeCellViewModel = SimilarRecipeCollectionViewCellViewModel(recipe: selectedRecipe)
        
        cell.configureForViewModel(similarRecipeCellViewModel)
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.sectionsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.similarRecipesCount
    }
}

extension RecipeSingleViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        viewModel.similarRecipesCount > 0 ? CGSize(width: collectionView.frame.height, height: collectionView.frame.height) : .zero
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let recipe = viewModel.similarRecipeAtIndex(indexPath.row)
        let recipeSingleViewController = RecipeSingleViewController(recipe: recipe)
        self.navigationController?.pushViewController(recipeSingleViewController, animated: true)
    }
}

extension RecipeSingleViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = collectionView.frame.size.height
        let width = collectionView.frame.size.width / 2.2
        
        return CGSize(width: width, height: height)
    }
}
