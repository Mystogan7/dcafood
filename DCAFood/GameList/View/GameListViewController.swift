//
//  GameListViewController.swift
//  DCAFood
//
//  Created by Mohamed Abdelhamid Mohamed Oshaiba on 20/05/2023.
//

import UIKit

class GameListViewController: UIViewController {
    weak var coordinator: GameListCoordinator?
    private var viewModel: GameListViewModelProtocol = GameListViewModel()
    private let tableView = UITableView()
    private var debounceTimer: Timer?

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Games"
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search for the games"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    private let searchInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "No game has been searched."
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
        
        updateSearchInfoLabelVisibility()
                
        searchBar.delegate = self
        
        self.view.backgroundColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
    }
    
    private func setupTableView() {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)

        // Add searchBar and titleLabel as subviews of containerView
        containerView.addSubview(searchBar)
        containerView.addSubview(titleLabel)

        // Setup constraints for containerView
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 235),
            searchBar.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            searchBar.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            searchBar.heightAnchor.constraint(equalToConstant: 56),
            titleLabel.bottomAnchor.constraint(equalTo: searchBar.topAnchor, constant: -8),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
        ])
        
        view.addSubview(tableView)
        view.addSubview(searchInfoLabel)
        
        // Setup constraints for searchInfoLabel
        NSLayoutConstraint.activate([
            searchInfoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchInfoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchInfoLabel.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 40),
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
    }
    
    private func bindData() {
        let reloadDataObserver = ClosureObserver<[Game]> { [weak self] _ in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.updateSearchInfoLabelVisibility()
            }
        }
        
        viewModel.gameList.addObserver(reloadDataObserver)
        viewModel.filteredGames.addObserver(reloadDataObserver)
    }
    
    private func updateSearchInfoLabelVisibility() {
        searchInfoLabel.isHidden = !viewModel.currentQuery.isEmpty
        tableView.isHidden = !searchInfoLabel.isHidden
    }
    
    private func debounce(_ interval: TimeInterval, block: @escaping () -> Void) {
        debounceTimer?.invalidate()
        debounceTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { _ in
            block()
        }
    }
}

extension GameListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 136
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.filteredGames.value.count - 1 {
            viewModel.currentPage += 1
            debounce(0.5) { [weak self] in
                self?.viewModel.fetchGames(query: self?.viewModel.currentQuery ?? "", page: self?.viewModel.currentPage ?? 1)
            }
        }
    }
}

extension GameListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredGames.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath) as? GameTableViewCell else {
            fatalError("The dequeued cell is not an instance of GameTableViewCell.")
        }
        
        let game = viewModel.filteredGames.value[indexPath.row]
        cell.configure(with: game)
        return cell
    }
}

extension GameListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        debounce(0.5) { [weak self] in
            self?.viewModel.searchGames(query: searchText)
        }
    }
}
