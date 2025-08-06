//
//  MainViewController.swift
//  YouTube
//
//  Created by Алексей Авер on 31.07.2025.
//

import UIKit

class MainViewController: UIViewController {
    
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let viewModel: MainViewViewModel
    
    override func loadView() {
        tableView.separatorStyle = .none
        tableView.sectionHeaderTopPadding = 0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
        tableView.register(VideoCell.self, forCellReuseIdentifier: VideoCell.reuseId)
        tableView.register(ShortsCell.self, forCellReuseIdentifier: ShortsCell.reuseId)
        tableView.register(HeaderContainerView.self, forHeaderFooterViewReuseIdentifier: HeaderContainerView.reuseId)
        
        tableView.delegate = self
        tableView.dataSource = self
        view = tableView
        
        let header = HeaderContainerView(frame: CGRect(x: 0, y: 0,
                                                       width: view.bounds.width,
                                                       height: 130))
        tableView.tableHeaderView = header
    }
    
    init(viewModel: MainViewViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 1
        } else {
            return viewModel.videos.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ShortsCell.reuseId,
                                                     for: indexPath) as! ShortsCell
            cell.collectionView.delegate   = self
            cell.collectionView.dataSource = self
            cell.collectionView.reloadData()
            return cell
        } else {
            let video = viewModel.videos[indexPath.row]   
            let cell  = tableView.dequeueReusableCell(withIdentifier: VideoCell.reuseId,
                                                      for: indexPath) as! VideoCell
            cell.configure(with: video)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 { return UITableView.automaticDimension }
        return 280
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 1 else {return nil}
        let shortsLogo = UIImageView()
        shortsLogo.image = UIImage(named: "shortsLogo")
        shortsLogo.contentMode = .scaleAspectFit
        let container = UIView()
        container.backgroundColor = .white
        container.addSubview(shortsLogo)
        shortsLogo.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            shortsLogo.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            shortsLogo.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        return container
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        section == 0 ? 0 : 40
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.shorts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShortsItemCell.reuseId, for: indexPath) as! ShortsItemCell
        
        cell.configure(with: viewModel.shorts[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: 240)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("short: \(viewModel.shorts[indexPath.item].title)")
    }
}
