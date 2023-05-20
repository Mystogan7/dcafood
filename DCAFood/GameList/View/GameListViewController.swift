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
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 34)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search for the games"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
        bindData()
        
        viewModel.fetchGames(query: "", page: 1)
        
        searchBar.delegate = self
        
        self.view.backgroundColor = .white
    }
    
    private func setupTableView() {
        view.addSubview(titleLabel)
        view.addSubview(searchBar)
        view.addSubview(tableView)
        
        // Setup constraints for titleLabel
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor, constant: 58),
            titleLabel.widthAnchor.constraint(equalToConstant: 180),
            titleLabel.heightAnchor.constraint(equalToConstant: 41)
        ])
        
        // Setup constraints for searchBar
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 56)
        ])
        
        // Setup constraints for tableView
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
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
            }
        }
        
        viewModel.gameList.addObserver(reloadDataObserver)
        viewModel.filteredGames.addObserver(reloadDataObserver)
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
        viewModel.currentPage += 1
        debounce(0.5) { [weak self] in
            self?.viewModel.fetchGames(query: self?.viewModel.currentQuery ?? "", page: self?.viewModel.currentPage ?? 0)
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
        viewModel.currentQuery = searchText
        viewModel.currentPage = 1
        debounce(0.5) { [weak self] in
            self?.viewModel.searchGames(query: searchText)
        }
    }
}

