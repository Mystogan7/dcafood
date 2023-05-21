//
//  DescriptionCell.swift
//  DCAFood
//
//  Created by Mohamed Abdelhamid Mohamed Oshaiba on 21/05/2023.
//

import UIKit

class DescriptionTableViewCell: UITableViewCell {
    private let descriptionLabel = UILabel.createLabel()
    private let titleLabel = UILabel.createLabel()
    private let readMoreButton = UIButton(type: .system)
    var onReadMoreButtonTapped: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setTitleLabel()
        setupDescriptionLabel()
        setupReadMoreButton()
        self.selectionStyle = .none
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setTitleLabel() {
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Game Description"
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }

    private func setupDescriptionLabel() {
        descriptionLabel.font = UIFont.systemFont(ofSize: 10)
        descriptionLabel.numberOfLines = 4
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
        ])
    }


    private func setupReadMoreButton() {
        readMoreButton.setTitle("Read more", for: .normal)
        readMoreButton.setTitleColor(.black, for: .normal)
        readMoreButton.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        readMoreButton.addTarget(self, action: #selector(readMoreButtonTapped), for: .touchUpInside)
        readMoreButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(readMoreButton)
        
        NSLayoutConstraint.activate([
            readMoreButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            readMoreButton.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
            readMoreButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with text: String) {
        descriptionLabel.text = text
        descriptionLabel.numberOfLines = 4
        descriptionLabel.layoutIfNeeded()
        
        let isTruncated = descriptionLabel.isTruncated()
        readMoreButton.isHidden = text.isEmpty || !isTruncated
    }
    
    @objc private func readMoreButtonTapped() {
        if descriptionLabel.numberOfLines == 4 && descriptionLabel.isTruncated() {
            descriptionLabel.numberOfLines = 0
            readMoreButton.setTitle("Read less", for: .normal)
        } else {
            descriptionLabel.numberOfLines = 4
            readMoreButton.setTitle("Read more", for: .normal)
        }
        onReadMoreButtonTapped?()
    }
}
