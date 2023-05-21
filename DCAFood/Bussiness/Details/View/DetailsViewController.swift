//
//  GameDetailsViewController.swift
//  DCAFood
//
//  Created by Mohamed Abdelhamid Mohamed Oshaiba on 21/05/2023.
//

import UIKit

class DetailsViewController: UIViewController {
    weak var coordinator: GameListCoordinator?
    private var viewModel: DetailsViewModelProtocol!
    
    private let tableView = UITableView()
    private let backgroundImageView = UIImageView.createImageView()
    private let customNavigationBar = UINavigationBar()

    var game: Game!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = DetailsViewModel(game: game)
        
        bindData()

        setupNavigationBar()
        
        setupUI()
        
        updateFavoriteButton(isFavorite: viewModel.isFavorite.value)
        
        viewModel.fetchDetails(id: game.id ?? -1)

    }
    
    // Navigation Bar
    private func setupNavigationBar() {
        customNavigationBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(customNavigationBar)
        
        // Constraints to position the navigation bar at the top of the view
        NSLayoutConstraint.activate([
            customNavigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            customNavigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customNavigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customNavigationBar.heightAnchor.constraint(equalToConstant: 44) // Height of navigation bar
        ])
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Games", style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Favorite", style: .plain, target: self, action: #selector(favoriteButtonTapped))
        customNavigationBar.setItems([navigationItem], animated: false)
    }
    
    @objc private func backButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func favoriteButtonTapped() {
        viewModel.favorite(game: game)
    }
    
    private func setupUI() {
        if let imageUrl = URL(string: game.backgroundImage ?? "") {
            backgroundImageView.image = ImageCache.shared.getImage(for: imageUrl)
        }
        
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundImageView)
    
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.heightAnchor.constraint(equalToConstant: 291),
            tableView.topAnchor.constraint(equalTo: backgroundImageView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.dataSource = self
        tableView.register(DescriptionTableViewCell.self, forCellReuseIdentifier: "descriptionCell")
        tableView.register(ExternalUrlTableViewCell.self, forCellReuseIdentifier: "externalUrl")
    }
    
    private func bindData() {
        let reloadDataObserver = ClosureObserver<GameDetails?> { [weak self] _ in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        let isFavoriteObserver = ClosureObserver<Bool> { [weak self] isFavorite in
            self?.updateFavoriteButton(isFavorite: isFavorite)
        }
        
        viewModel.details.addObserver(reloadDataObserver)
        
        viewModel.isFavorite.addObserver(isFavoriteObserver)
    }
    
    func updateFavoriteButton(isFavorite: Bool) {
        let favoriteTitle = isFavorite ? "Favorited" : "Favorite"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: favoriteTitle, style: .plain, target: self, action: #selector(favoriteButtonTapped))
    }
}

extension DetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        130
    }
}

extension DetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "descriptionCell", for: indexPath) as? DescriptionTableViewCell else {
                fatalError("The dequeued cell is not an instance of DescriptionTableViewCell.")
            }
            cell.configure(with: viewModel.details.value?.description ?? "")
            cell.onReadMoreButtonTapped = { [weak tableView] in
                tableView?.beginUpdates()
                tableView?.endUpdates()
            }
            return cell
        } else if indexPath.row == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "externalUrl", for: indexPath) as? ExternalUrlTableViewCell else {
                fatalError("The dequeued cell is not an instance of ExternalUrlTableViewCell.")
            }
            cell.configure(with: viewModel.details.value?.redditURL ?? "", text: "Visit reddit")
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "externalUrl", for: indexPath) as? ExternalUrlTableViewCell else {
                fatalError("The dequeued cell is not an instance of ExternalUrlTableViewCell.")
            }
            cell.configure(with: viewModel.details.value?.website ?? "", text: "Visit website")
            return cell
        }
    }
}
