//
//  GameCell.swift
//  DCAFood
//
//  Created by Mohamed Abdelhamid Mohamed Oshaiba on 20/05/2023.
//

import UIKit

class GameTableViewCell: UITableViewCell {
    static let imageCache = ImageCache()
    private var currentImageLoadingTask: URLSessionDataTask?
    
    let gameImageView = UIImageView.createImageView()
    let titleLabel = UILabel.createLabel()
    let metacriticLabel = UILabel.createLabel()
    let genresLabel = UILabel.createLabel(color: UIColor(red: 0x8A / 255.0, green: 0x8A / 255.0, blue: 0x8F / 255.0, alpha: 1.0))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetCell()
    }
    
    func configure(with game: Game) {
        titleLabel.text = game.name ?? ""
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        let metacriticText = "metacritic: "
        let metacriticScore = String(describing: game.metacritic ?? 0)

        let metacriticTextAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14, weight: .medium),
            .foregroundColor: UIColor.black
        ]
        let metacriticScoreAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 18, weight: .bold),
            .foregroundColor: UIColor.red
        ]

        let metacriticAttributedString = NSMutableAttributedString(string: metacriticText, attributes: metacriticTextAttributes)
        let metacriticScoreAttributedString = NSAttributedString(string: metacriticScore, attributes: metacriticScoreAttributes)
        metacriticAttributedString.append(metacriticScoreAttributedString)

        metacriticLabel.attributedText = metacriticAttributedString
        
        if let genres = game.genres {
            let arr: [String] = genres.map({
                $0.name ?? ""
            })
            genresLabel.text = arr.joined(separator: ", ")
            genresLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        }
        
        if let imageUrl = URL(string: game.backgroundImage ?? "") {
            loadImage(for: imageUrl, into: gameImageView)
        }
    }
    
    private func setupSubviews() {
        contentView.addSubviews(gameImageView, titleLabel, metacriticLabel, genresLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            gameImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            gameImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            gameImageView.widthAnchor.constraint(equalToConstant: 120),
            gameImageView.heightAnchor.constraint(equalToConstant: 104),

            titleLabel.leadingAnchor.constraint(equalTo: gameImageView.trailingAnchor, constant: 8),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),

            metacriticLabel.leadingAnchor.constraint(equalTo: gameImageView.trailingAnchor, constant: 8),
            metacriticLabel.bottomAnchor.constraint(equalTo: genresLabel.topAnchor, constant: -8),

            genresLabel.leadingAnchor.constraint(equalTo: gameImageView.trailingAnchor, constant: 8),
            genresLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
        ])
    }
    
    private func resetCell() {
        currentImageLoadingTask?.cancel()
        currentImageLoadingTask = nil
        
        gameImageView.image = nil
        titleLabel.text = nil
        metacriticLabel.text = nil
        genresLabel.text = nil
    }
    
    private func loadImage(for url: URL, into imageView: UIImageView) {
        imageView.image = nil
        imageView.imageURL = url
        
        if let cachedImage = GameTableViewCell.imageCache.getImage(for: url) {
            imageView.image = cachedImage
            return
        }
        
        currentImageLoadingTask?.cancel()
        let task = URLSession.shared.dataTask(with: url) { [weak imageView] data, response, error in
            guard let data = data, error == nil, let image = UIImage(data: data) else {
                print("Error loading image: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            DispatchQueue.main.async {
                if let currentURL = imageView?.imageURL, currentURL == url {
                    imageView?.image = image
                    GameTableViewCell.imageCache.cacheImage(image, for: url)
                }
            }
        }
        currentImageLoadingTask = task
        task.resume()
    }
}
