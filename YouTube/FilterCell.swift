//
//  FilterCell.swift
//  YouTube
//
//  Created by Алексей Авер on 29.07.2025.
//

import UIKit

final class FilterCell: UICollectionViewCell {
    static let reuseId = "FilterCell"
    
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.cornerRadius = 16
        
        titleLabel.font = .systemFont(ofSize: 12, weight: .regular)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
        ])
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with title: String, selected: Bool) {
        titleLabel.text = title

        if selected {
            contentView.backgroundColor = .darkGray
            titleLabel.textColor = .white
            contentView.layer.borderWidth = 0
        } else {
            contentView.backgroundColor = .white
            titleLabel.textColor = .black
            contentView.layer.borderWidth = 1
            contentView.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
}
