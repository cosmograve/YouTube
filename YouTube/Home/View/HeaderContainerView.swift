//
//  HeaderContainerView.swift
//  YouTube
//
//  Created by Алексей Авер on 31.07.2025.
//

import UIKit

final class HeaderContainerView: UITableViewHeaderFooterView {
    static let reuseId = "HeaderContainerView"

    private let navigationBar = UIView()
    private let logoImageView = UIImageView()
    private let rightStack = UIStackView()

    private let verticalDivider = UIView()
    private let filterBar = UIView()
    private let exploreButton = UIButton(type: .system)
    private let divider = UIView()
    private var filterCollectionView: UICollectionView!

    private let filters = ["All", "Mixes", "Music", "Graphic"]
    private var selectedFilterIndex: IndexPath? = IndexPath(item: 0, section: 0)

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        setupNavigationBar()
        setupVerticalDivider()
        setupFilterBar()
        setupDivider()
        setupFilterCollectionView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupNavigationBar() {
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(navigationBar)

        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: contentView.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
            navigationBar.heightAnchor.constraint(equalToConstant: 60)
        ])

        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = UIImage(named: "ulogo")
        navigationBar.addSubview(logoImageView)

        NSLayoutConstraint.activate([
            logoImageView.leadingAnchor.constraint(equalTo: navigationBar.leadingAnchor, constant: 14),
            logoImageView.centerYAnchor.constraint(equalTo: navigationBar.centerYAnchor)
        ])

        rightStack.translatesAutoresizingMaskIntoConstraints = false
        rightStack.axis = .horizontal
        rightStack.alignment = .center
        rightStack.spacing = 12
        navigationBar.addSubview(rightStack)

        let iconNames = ["share", "bell", "search", "person"]

        for icon in iconNames {
            let button = UIButton(type: .system)
            button.setImage(UIImage(named: icon), for: .normal)
            button.addTarget(self, action: #selector(iconTapped(_:)), for: .touchUpInside)
            button.accessibilityLabel = icon
            rightStack.addArrangedSubview(button)
        }

        NSLayoutConstraint.activate([
            rightStack.centerYAnchor.constraint(equalTo: navigationBar.centerYAnchor),
            rightStack.trailingAnchor.constraint(equalTo: navigationBar.trailingAnchor, constant: -12)
        ])
    }

    private func setupVerticalDivider() {
        verticalDivider.translatesAutoresizingMaskIntoConstraints = false
        verticalDivider.backgroundColor = .systemGray4
        contentView.addSubview(verticalDivider)

        NSLayoutConstraint.activate([
            verticalDivider.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            verticalDivider.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            verticalDivider.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            navigationBar.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -12),
            verticalDivider.heightAnchor.constraint(equalToConstant: 1)
        ])
    }

    private func setupFilterBar() {
        filterBar.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(filterBar)

        NSLayoutConstraint.activate([
            filterBar.topAnchor.constraint(equalTo: verticalDivider.bottomAnchor, constant: 12),
            filterBar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            filterBar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            filterBar.heightAnchor.constraint(equalToConstant: 44)
        ])

        exploreButton.setTitle(" Explore", for: .normal)
        exploreButton.setTitleColor(.black, for: .normal)
        exploreButton.backgroundColor = .gray.withAlphaComponent(0.2)
        exploreButton.setImage(UIImage(named: "explore"), for: .normal)
        exploreButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        exploreButton.layer.cornerRadius = 4
        exploreButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        exploreButton.translatesAutoresizingMaskIntoConstraints = false
        exploreButton.addTarget(self, action: #selector(exploreTapped), for: .touchUpInside)

        filterBar.addSubview(exploreButton)

        NSLayoutConstraint.activate([
            exploreButton.leadingAnchor.constraint(equalTo: filterBar.leadingAnchor, constant: 16),
            exploreButton.centerYAnchor.constraint(equalTo: filterBar.centerYAnchor)
        ])
    }

    private func setupDivider() {
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.backgroundColor = .systemGray4
        filterBar.addSubview(divider)

        NSLayoutConstraint.activate([
            divider.leadingAnchor.constraint(equalTo: exploreButton.trailingAnchor, constant: 12),
            divider.centerYAnchor.constraint(equalTo: filterBar.centerYAnchor),
            divider.widthAnchor.constraint(equalToConstant: 1),
            divider.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    private func setupFilterCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 4
        filterCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        filterCollectionView.translatesAutoresizingMaskIntoConstraints = false
        filterCollectionView.backgroundColor = .clear
        filterCollectionView.showsHorizontalScrollIndicator = false
        filterCollectionView.delegate = self
        filterCollectionView.dataSource = self
        filterCollectionView.register(FilterCell.self, forCellWithReuseIdentifier: FilterCell.reuseId)

        filterBar.addSubview(filterCollectionView)

        NSLayoutConstraint.activate([
            filterCollectionView.topAnchor.constraint(equalTo: filterBar.topAnchor),
            filterCollectionView.leadingAnchor.constraint(equalTo: divider.trailingAnchor, constant: 16),
            filterCollectionView.trailingAnchor.constraint(equalTo: filterBar.trailingAnchor, constant: -12),
            filterCollectionView.bottomAnchor.constraint(equalTo: filterBar.bottomAnchor)
        ])
    }

    @objc private func iconTapped(_ sender: UIButton) {
        if let label = sender.accessibilityLabel {
            print("🔘 Нажата кнопка: \(label)")
        }
    }

    @objc private func exploreTapped() {
        print("🌍 Explore tapped")
    }
}

extension HeaderContainerView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCell.reuseId, for: indexPath) as! FilterCell
        let isSelected = indexPath == selectedFilterIndex
        cell.configure(with: filters[indexPath.item], selected: isSelected)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedFilterIndex = indexPath
        collectionView.reloadData()
        print("🎛 Выбран фильтр: \(filters[indexPath.item])")
    }

    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = filters[indexPath.item]
        let size = (text as NSString).size(withAttributes: [.font: UIFont.systemFont(ofSize: 14)])
        return CGSize(width: size.width + 24, height: 32)
    }
}
