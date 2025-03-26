//
//  PokemonCell.swift
//  Pokedex App
//
//  Created by Cesar Castillo on 25-03-25.
//

import UIKit
import Kingfisher

class PokemonCell: UITableViewCell {
    static let identifier = "PokemonCell"
    
    private let pokemonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    private let numberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addSubview(pokemonImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(numberLabel)
        
        pokemonImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pokemonImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            pokemonImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            pokemonImageView.widthAnchor.constraint(equalToConstant: 70),
            pokemonImageView.heightAnchor.constraint(equalToConstant: 70),
            
            nameLabel.leadingAnchor.constraint(equalTo: pokemonImageView.trailingAnchor, constant: 15),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            
            numberLabel.leadingAnchor.constraint(equalTo: pokemonImageView.trailingAnchor, constant: 15),
            numberLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            numberLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15)
        ])
    }
    
    func configure(with pokemon: Pokemon) {
        nameLabel.text = pokemon.name.capitalized
        numberLabel.text = "No. \(pokemon.id)"
        
        guard let imageUrl = URL(string: pokemon.imageUrl) else {
            pokemonImageView.image = UIImage(named: "errorImage")
            return
        }
        
        pokemonImageView.kf.setImage(
            with: imageUrl,
            placeholder: UIImage(named: "placeholder"),
            options: [.transition(.fade(0.3))]
        )
    }
}
