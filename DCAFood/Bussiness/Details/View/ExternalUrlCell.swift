//
//  ExternalUrlCell.swift
//  DCAFood
//
//  Created by Mohamed Abdelhamid Mohamed Oshaiba on 21/05/2023.
//

import UIKit

class ExternalUrlTableViewCell: UITableViewCell {
    private let openUrlButton = UIButton(type: .system)
    private var url: URL?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupOpenUrlButton()
        self.selectionStyle = .none
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupOpenUrlButton()
    }

    private func setupOpenUrlButton() {
        openUrlButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        openUrlButton.setTitleColor(.black, for: .normal)
        openUrlButton.addTarget(self, action: #selector(openUrlButtonTapped), for: .touchUpInside)
        openUrlButton.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(openUrlButton)

        NSLayoutConstraint.activate([
            openUrlButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            openUrlButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }

    @objc private func openUrlButtonTapped() {
        guard let url = self.url else { return }
        UIApplication.shared.open(url)
    }

    func configure(with url: String, text: String) {
        self.openUrlButton.setTitle(text, for: .normal)
        guard let url = URL(string: url) else {
            return
        }
        self.url = url
    }
}

