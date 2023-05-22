//
//  FavoritesViewController.swift
//  DCAFood
//
//  Created by Mohamed Abdelhamid Mohamed Oshaiba on 20/05/2023.
//

import UIKit

class FavoritesViewController: UIViewController {
    weak var coordinator: FavoritesCoordinator?
    private let tableView = UITableView()
    private let viewModel: FavoritesViewModelProtocol = FavoritesViewModel()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Favorites"
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let favouritesInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "There is no favorites found."
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
        bindData()
        
        self.view.backgroundColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
        
        // Check if viewModel.gameList already has values
        if !viewModel.gameList.value.isEmpty {
            updateView()
        }
    }
    
    private func setupTableView() {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        // Add titleLabel as subviews of containerView
        containerView.addSubview(titleLabel)
        
        // Setup constraints for containerView
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 180),
            titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
        ])
        
        view.addSubview(tableView)
        view.addSubview(favouritesInfoLabel)
        
        // Setup constraints for favouritesInfoLabel
        NSLayoutConstraint.activate([
            favouritesInfoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            favouritesInfoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            favouritesInfoLabel.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 40),
        ])
        
        // Setup constraints for tableView
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: containerView.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(GameTableViewCell.self, forCellReuseIdentifier: "gameCell")
        
        tableView.isHidden = true
    }
    
    private func updateInfoLabelVisibility() {
        let hasFavorites = viewModel.gameList.value.count > 0
        tableView.isHidden = !hasFavorites
        favouritesInfoLabel.isHidden = hasFavorites
    }
    
    private func bindData() {
        let reloadDataObserver = ClosureObserver<[Game]> { [weak self] _ in
            self?.updateView()
        }

        viewModel.gameList.addObserver(reloadDataObserver)
    }

    private func updateView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.updateInfoLabelVisibility()

            let count = self.viewModel.gameList.value.count
            let text = count > 0 ? "Favorites (\(count))" : "Favorites"
            self.titleLabel.text = text
        }
    }
}

extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 136
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let game = viewModel.gameList.value[indexPath.row]
            viewModel.removeFromFavorites(game: game)
        }
    }
}

extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.gameList.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath) as! GameTableViewCell
        let game = viewModel.gameList.value[indexPath.row]
        cell.selectionStyle = .none
        cell.configure(with: game)
        return cell
    }
}
