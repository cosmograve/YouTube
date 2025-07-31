//
//  HomeViewController.swift
//  YouTube
//
//  Created by Алексей Авер on 23.07.2025.
//

import UIKit

class HomeViewController: UIViewController {
    
    private let navigationBar = UIView()
    private let logoImageView = UIImageView()
    private let rightStack = UIStackView()
    
    private let verticalDivider = UIView()
    
    private let filterBar = UIView()
    private let exploreButton = UIButton(type: .system)
    private let divider = UIView()
    private var fitlerCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = .black
        setupNavigationBar()
        setupVerticalDivider()
        setupFilterBar()
        setupDivider()
    }
    
    private func setupNavigationBar() {
        view.addSubview(navigationBar)
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.backgroundColor = .white
        
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            navigationBar.centerYAnchor.constraint(equalTo: navigationBar.safeAreaLayoutGuide.centerYAnchor),
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
        view.addSubview(verticalDivider)
        
        NSLayoutConstraint.activate([
            verticalDivider.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            verticalDivider.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            verticalDivider.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            navigationBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12),
            verticalDivider.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    private func setupFilterBar() {
        filterBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(filterBar)
        
        NSLayoutConstraint.activate([
            filterBar.topAnchor.constraint(equalTo: verticalDivider.bottomAnchor, constant: 12),
            filterBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            filterBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
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
        
        let filters = ["All", "Mixes", "Music", "Graphic"]
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
        
        
    }
    
    @objc private func iconTapped(_ sender: UIButton) {
        if let label = sender.accessibilityLabel {
            print("Нажата кнопка: \(label)")
        }
    }
    
    @objc private func exploreTapped() {
        print("🌍 Explore tapped")
    }
}
