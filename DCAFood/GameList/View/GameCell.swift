//
//  GameCell.swift
//  DCAFood
//
//  Created by Mohamed Abdelhamid Mohamed Oshaiba on 20/05/2023.
//

import UIKit

import UIKit

class GameTableViewCell: UITableViewCell {
    static let imageCache = NSCache<NSURL, UIImage>()
    private var currentImageLoadingTask: URLSessionDataTask?
    private let imageObservable = Observable<UIImage?>(nil)
    private var imageObserver: ClosureObserver<UIImage?>?
    let gameImageView = UIImageView.createImageView()
    let titleLabel = UILabel.createLabel(fontName: "SFProDisplay-Bold", fontSize: 20)
    let metacriticLabel = UILabel.createLabel()
    let genresLabel = UILabel.createLabel()

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
        titleLabel.text = game.name
        metacriticLabel.text = "Metacritic: \(String(describing: game.metacritic))"
        
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
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),

            metacriticLabel.leadingAnchor.constraint(equalTo: gameImageView.trailingAnchor, constant: 8),
            metacriticLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            genresLabel.leadingAnchor.constraint(equalTo: metacriticLabel.trailingAnchor, constant: 8),
            genresLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        bindImageView()
    }
    
    private func resetCell() {
        currentImageLoadingTask?.cancel()
        currentImageLoadingTask = nil

        gameImageView.image = nil
        titleLabel.text = nil
        metacriticLabel.text = nil
        genresLabel.text = nil
    }
    
    private func bindImageView() {
        imageObserver = ClosureObserver { [weak self] image in
            DispatchQueue.main.async {
                self?.gameImageView.image = image ?? UIImage(named: "placeholderImage")
            }
        }
        imageObservable.addObserver(imageObserver!)
    }

    private func loadImage(for url: URL, into imageView: UIImageView) {
        currentImageLoadingTask?.cancel()

        if let cachedImage = GameTableViewCell.imageCache.object(forKey: url as NSURL) {
            imageView.image = cachedImage
            return
        }

        currentImageLoadingTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil, let image = UIImage(data: data) else {
                print("Error loading image: \(error?.localizedDescription ?? "Unknown error")")
                self?.imageObservable.value = nil
                return
            }

            GameTableViewCell.imageCache.setObject(image, forKey: url as NSURL)
            self?.imageObservable.value = image
            self?.currentImageLoadingTask = nil
        }
        currentImageLoadingTask?.resume()
    }
}

extension UIImageView {
    static func createImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
}

extension UILabel {
    static func createLabel(fontName: String = "SFProDisplay-Regular", fontSize: CGFloat = 17) -> UILabel {
        let label = UILabel()
        label.font = UIFont(name: fontName, size: fontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}

extension UIView {
    func addSubviews(_ subviews: UIView...) {
        for subview in subviews {
            addSubview(subview)
        }
    }
}
