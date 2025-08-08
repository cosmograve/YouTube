//
//  HeaderContainerView.swift
//  YouTube
//
//  Created by Алексей Авер on 31.07.2025.
//

import UIKit

final class MainHeaderView: UICollectionReusableView {
        
    static let reuseId = "MainHeaderView"
        
    private let navigationBar = UIView()
    private let logoImageView = UIImageView()
    private let rightStack = UIStackView()
    
    private let dividerHorizontal = UIView()
    
    private let filterBar = UIView()
    private let exploreButton = UIButton(type: .system)
    private let dividerVertical = UIView()
    private lazy var filterCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 4
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .clear
        cv.register(FilterCell.self,
                    forCellWithReuseIdentifier: FilterCell.reuseId)
        cv.delegate = self
        cv.dataSource = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
        
    private let filters = ["All", "Mixes", "Music", "Graphic"]
    private var selected = IndexPath(item: 0, section: 0)
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupNavigationBar()
        setupDividerHorizontal()
        setupFilterBar()
    }
    required init?(coder: NSCoder) { fatalError() }

    private func setupNavigationBar() {
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        addSubview(navigationBar)
        
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            navigationBar.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        logoImageView.image = UIImage(named: "ulogo")
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.addSubview(logoImageView)
        NSLayoutConstraint.activate([
            logoImageView.leadingAnchor.constraint(equalTo: navigationBar.leadingAnchor, constant: 14),
            logoImageView.centerYAnchor.constraint(equalTo: navigationBar.centerYAnchor)
        ])
        
        rightStack.axis = .horizontal
        rightStack.alignment = .center
        rightStack.spacing = 12
        rightStack.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.addSubview(rightStack)
        
        ["share", "bell", "search", "person"].forEach { icon in
            let btn = UIButton(type: .system)
            btn.setImage(UIImage(named: icon), for: .normal)
            btn.accessibilityLabel = icon
            btn.addTarget(self, action: #selector(iconTapped(_:)), for: .touchUpInside)
            rightStack.addArrangedSubview(btn)
        }
        
        NSLayoutConstraint.activate([
            rightStack.centerYAnchor.constraint(equalTo: navigationBar.centerYAnchor),
            rightStack.trailingAnchor.constraint(equalTo: navigationBar.trailingAnchor, constant: -12)
        ])
    }
    
    private func setupDividerHorizontal() {
        dividerHorizontal.backgroundColor = .systemGray4
        dividerHorizontal.translatesAutoresizingMaskIntoConstraints = false
        addSubview(dividerHorizontal)
        
        NSLayoutConstraint.activate([
            dividerHorizontal.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            dividerHorizontal.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 12),
            dividerHorizontal.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -12),
            dividerHorizontal.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    private func setupFilterBar() {
        filterBar.translatesAutoresizingMaskIntoConstraints = false
        addSubview(filterBar)
        
        NSLayoutConstraint.activate([
            filterBar.topAnchor.constraint(equalTo: dividerHorizontal.bottomAnchor, constant: 12),
            filterBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            filterBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            filterBar.bottomAnchor.constraint(equalTo: bottomAnchor),   // задаёт итоговую высоту хедера
            filterBar.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        exploreButton.setTitle(" Explore", for: .normal)
        exploreButton.setTitleColor(.black, for: .normal)
        exploreButton.setImage(UIImage(named: "explore"), for: .normal)
        exploreButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        exploreButton.backgroundColor  = .gray.withAlphaComponent(0.2)
        exploreButton.layer.cornerRadius = 4
        exploreButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        exploreButton.addTarget(self, action: #selector(exploreTapped), for: .touchUpInside)
        exploreButton.translatesAutoresizingMaskIntoConstraints = false
        filterBar.addSubview(exploreButton)
        
        // vertical divider
        dividerVertical.backgroundColor = .systemGray4
        dividerVertical.translatesAutoresizingMaskIntoConstraints = false
        filterBar.addSubview(dividerVertical)
        
        // collection
        filterBar.addSubview(filterCV)
        
        NSLayoutConstraint.activate([
            exploreButton.leadingAnchor.constraint(equalTo: filterBar.leadingAnchor, constant: 16),
            exploreButton.centerYAnchor.constraint(equalTo: filterBar.centerYAnchor),
            
            dividerVertical.leadingAnchor.constraint(equalTo: exploreButton.trailingAnchor, constant: 12),
            dividerVertical.centerYAnchor.constraint(equalTo: filterBar.centerYAnchor),
            dividerVertical.widthAnchor.constraint(equalToConstant: 1),
            dividerVertical.heightAnchor.constraint(equalToConstant: 20),
            
            filterCV.topAnchor.constraint(equalTo: filterBar.topAnchor),
            filterCV.leadingAnchor.constraint(equalTo: dividerVertical.trailingAnchor, constant: 16),
            filterCV.trailingAnchor.constraint(equalTo: filterBar.trailingAnchor, constant: -12),
            filterCV.bottomAnchor.constraint(equalTo: filterBar.bottomAnchor)
        ])
    }
        
    @objc private func iconTapped(_ sender: UIButton) {
        print("tapped:", sender.accessibilityLabel ?? "unknown")
    }
    @objc private func exploreTapped() {
        print("Explore tapped")
    }
}

extension MainHeaderView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ cv: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        filters.count
    }
    
    func collectionView(_ cv: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cv.dequeueReusableCell(withReuseIdentifier: FilterCell.reuseId,
                                          for: indexPath) as! FilterCell
        cell.configure(with: filters[indexPath.item],
                       selected: indexPath == selected)
        return cell
    }
    
    func collectionView(_ cv: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selected = indexPath
        cv.reloadData()
        print("filter:", filters[indexPath.item])
    }
    
    func collectionView(_ cv: UICollectionView,
                        layout layoutCV: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = filters[indexPath.item] as NSString
        let w    = text.size(withAttributes: [.font: UIFont.systemFont(ofSize: 14)]).width
        return CGSize(width: w + 24, height: 32)
    }
}
