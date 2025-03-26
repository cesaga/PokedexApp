//
//  PokemonListViewController.swift
//  Pokedex App
//
//  Created by Cesar Castillo on 25-03-25.
//
import UIKit
import Combine

class PokemonListViewController: UIViewController {
    private var viewModel: PokemonViewModel
    private var cancellables = Set<AnyCancellable>()
    private let tableView = UITableView()
    private let searchController = UISearchController(searchResultsController: nil)
    
    init(viewModel: PokemonViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        viewModel.fetchPokemons(limit: Constants.pokemonLimit)
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupView() {
        title = "Pokédex"
        configureTableView()
        configureSearchController()
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PokemonCell.self, forCellReuseIdentifier: PokemonCell.identifier)
        tableView.frame = view.bounds
        view.addSubview(tableView)
    }
    
    private func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Pokémon"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    private func bindViewModel() {
        viewModel.$filteredPokemons
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
}
    
extension PokemonListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredPokemons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PokemonCell.identifier, for: indexPath) as? PokemonCell else {
            return UITableViewCell()
        }
        let pokemon = viewModel.filteredPokemons[indexPath.row]
        cell.configure(with: pokemon)
        return cell
    }
     
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedPokemon = viewModel.filteredPokemons[indexPath.row]
        let detailViewModel = PokemonDetailViewModel(pokemonURL: selectedPokemon.url, pokemonAPIManager: PokemonAPIManager(networkService: NetworkService(session: URLSession.shared)))
        let detailViewController = PokemonDetailViewController(pokemonImageURL: selectedPokemon.imageUrl, viewModel: detailViewModel)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension PokemonListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.searchPokemons(query: searchController.searchBar.text ?? "")
    }
}
