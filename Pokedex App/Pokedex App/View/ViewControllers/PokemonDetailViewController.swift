//
//  PokemonDetailViewController.swift
//  Pokedex App
//
//  Created by Cesar Castillo on 25-03-25.
//

import UIKit
import Combine

class PokemonDetailViewController: UIViewController {
    private let viewModel: PokemonDetailViewModel
    private var cancellables = Set<AnyCancellable>()
    private let pokemonImageURL: String?
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 35)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let numberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 35)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let pokemonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameAndNumberStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 30
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let typesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let heightStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let weightStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let heightLabel: UILabel = {
        let label = UILabel()
        label.text = "Height:"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let weightLabel: UILabel = {
        let label = UILabel()
        label.text = "Weight:"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let heightValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let weightValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let statsTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Pokemon Stats"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    init(pokemonImageURL: String, viewModel: PokemonDetailViewModel) {
        self.pokemonImageURL = pokemonImageURL
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.fetchPokemonDetails()
    }
    
    func setupUI() {
        view.backgroundColor = UIColor.systemBackground
        navigationController?.navigationBar.prefersLargeTitles = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(mainStackView)
        
        mainStackView.addArrangedSubview(nameAndNumberStackView)
        mainStackView.addArrangedSubview(typesStackView)
        mainStackView.addArrangedSubview(pokemonImageView)
        mainStackView.addArrangedSubview(heightStackView)
        mainStackView.addArrangedSubview(weightStackView)
        mainStackView.addArrangedSubview(statsTitleLabel)
        mainStackView.addArrangedSubview(statsStackView)
        
        nameAndNumberStackView.addArrangedSubview(nameLabel)
        nameAndNumberStackView.addArrangedSubview(numberLabel)
        
        heightStackView.addArrangedSubview(heightLabel)
        heightStackView.addArrangedSubview(heightValueLabel)
        
        weightStackView.addArrangedSubview(weightLabel)
        weightStackView.addArrangedSubview(weightValueLabel)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            pokemonImageView.widthAnchor.constraint(equalToConstant: 230),
            pokemonImageView.heightAnchor.constraint(equalToConstant: 230),
        ])
        
        NSLayoutConstraint.activate([
            statsTitleLabel.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            statsStackView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.$pokemonDetail
            .receive(on: DispatchQueue.main)
            .sink { [weak self] detail in
                guard let self = self, let detail = detail else { return }
                self.updateUI(with: detail)
            }
            .store(in: &cancellables)
    }
    
    private func updateUI(with detail: PokemonDetail) {
        nameLabel.text = detail.name.capitalized
        numberLabel.text = String("#\(detail.id)")
        weightValueLabel.text = String(format: "%.1f Kg", Double(detail.weight) / 10)
        heightValueLabel.text = String(format: "%.1f m", Double(detail.height) / 10)
        setupTypesUI(with: detail.types)
        setupStatsUI(with: detail.stats)
        loadImage(from: pokemonImageURL ?? "")
    }
    
    private func loadImage(from urlString: String) {
        guard let imageUrl = URL(string: urlString) else {
            pokemonImageView.image = UIImage(named: "errorImage")
            return
        }
        pokemonImageView.kf.setImage(
            with: imageUrl,
            placeholder: UIImage(named: "placeholder"),
            options: [.transition(.fade(0.3))]
        )
    }
    
    private func setupTypesUI(with types: [PokemonType]) {
        typesStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for type in types {
            let typesContainerView = UIView()
            typesContainerView.translatesAutoresizingMaskIntoConstraints = false
            typesContainerView.backgroundColor = UIColor.color(from: PokemonTypeColorHelper.color(for: type.type.name))
            typesContainerView.layer.cornerRadius = 12
            typesContainerView.layer.masksToBounds = true
            typesContainerView.layoutMargins = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)

            let typeLabel = UILabel()
            typeLabel.translatesAutoresizingMaskIntoConstraints = false
            typeLabel.text = type.type.name.capitalized
            typeLabel.textColor = .white
            typeLabel.font = UIFont.boldSystemFont(ofSize: 14)

            typesContainerView.addSubview(typeLabel)
            NSLayoutConstraint.activate([
                typeLabel.leadingAnchor.constraint(equalTo: typesContainerView.leadingAnchor, constant: 10),
                typeLabel.trailingAnchor.constraint(equalTo: typesContainerView.trailingAnchor, constant: -10),
                typeLabel.topAnchor.constraint(equalTo: typesContainerView.topAnchor, constant: 5),
                typeLabel.bottomAnchor.constraint(equalTo: typesContainerView.bottomAnchor, constant: -5)
            ])
            typesStackView.addArrangedSubview(typesContainerView)
        }
    }
    
    private func setupStatsUI(with stats: [Stats]) {
        statsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for stat in stats {
            let statStackView = UIStackView()
            statStackView.axis = .horizontal
            statStackView.spacing = 10
            statStackView.alignment = .center
            statStackView.translatesAutoresizingMaskIntoConstraints = false

            let statTitleLabel = UILabel()
            statTitleLabel.text = "\(stat.stat.name.capitalized):"
            statTitleLabel.font = UIFont.boldSystemFont(ofSize: 12)
            statTitleLabel.translatesAutoresizingMaskIntoConstraints = false

            let statValueLabel = UILabel()
            statValueLabel.text = "\(stat.base_stat)"
            statValueLabel.font = UIFont.boldSystemFont(ofSize: 12)
            statValueLabel.textColor = PokemonColorForStatHelper.colorForStat(named: stat.stat.name)
            statValueLabel.translatesAutoresizingMaskIntoConstraints = false

            statStackView.addArrangedSubview(statTitleLabel)
            statStackView.addArrangedSubview(statValueLabel)
            statsStackView.addArrangedSubview(statStackView)
        }
    }
}
