//
//  RecipesListViewController.swift
//  Recipes
//
//

import UIKit
import Combine

final class RecipesListViewController: UIViewController {
    
    // MARK: Private Properties
    
    private static let recipeCellIdentifier = "recipeCellIdentifier"
    
    private var cancellables: [AnyCancellable]
    private let viewModel: RecipeListViewModel
    
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
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = .zero
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.refreshControl = self.refreshControl
        collectionView.register(RecipeListCollectionViewCell.self, forCellWithReuseIdentifier: RecipesListViewController.recipeCellIdentifier)
        return collectionView
    }()
    
    // MARK: Lifecycle
    
    init(viewModel: RecipeListViewModel = RecipeListViewModel(), cancellables: [AnyCancellable] = [AnyCancellable]() ) {
        self.viewModel = viewModel
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
        view.addSubview(collectionView)
        view.addSubview(activityIndicatorView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc private func fetchResources() {
        
        activityIndicatorView.startAnimating()
        viewModel.fetchRecipes()
    }
    
    private func bindToViewModel() {
        
        viewModel.recipes$
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success:
                    self?.collectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                    self?.showErrorDialog(message: error.localizedDescription)
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

extension RecipesListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Self.recipeCellIdentifier, for: indexPath) as? RecipeListCollectionViewCell else {
            fatalError("Bad Recipe Cell Dequeue")
        }
        
        let selectedRecipe = viewModel.recipeAtIndex(indexPath.row)
        let recipeCellViewModel = RecipeListCollectionViewCelViewModel(recipe: selectedRecipe)
        
        cell.configureFor(viewModel: recipeCellViewModel)
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.sectionsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.recipesCount
    }
}

extension RecipesListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let recipe = viewModel.recipeAtIndex(indexPath.row)
        let recipeSingleViewController = RecipeSingleViewController(recipe: recipe)
        self.navigationController?.pushViewController(recipeSingleViewController, animated: true)
    }
}

extension RecipesListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = collectionView.frame.size.height / 3
        let width = collectionView.frame.size.width
        
        return CGSize(width: width, height: height)
    }
}
