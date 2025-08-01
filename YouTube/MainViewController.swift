//
//  MainViewController.swift
//  YouTube
//
//  Created by Алексей Авер on 31.07.2025.
//

import UIKit

class MainViewController: UIViewController {

    private let tableView = UITableView(frame: .zero, style: .grouped)

    private var videos: [Video] = []
    private var showShorts = true
    
    let mockShorts: [ShortVideo] = [
        ShortVideo(title: "DIY Toys | Satisfying And Relaxing", views: "24M views", imageName: "short1"),
        ShortVideo(title: "Sunset Cinematic Vibes", views: "18M views", imageName: "short2"),
        ShortVideo(title: "Mountain Drone Compilation", views: "12M views", imageName: "short3")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupTableView()

    }
    
    private func setupData() {
        videos = (1...3).map { i in
            Video(id: UUID(),
                  title: "Видео \(i)",
                  subtitle: "Канал \(i) • \(Int.random(in: 5...100))K views",
                  thumbnailURL: "avatarVideo",
                  avatarURL: "avatarVideo")
        }
    }

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.register(VideoCell.self, forCellReuseIdentifier: VideoCell.reuseId)
        tableView.register(ShortsCell.self, forCellReuseIdentifier: ShortsCell.reuseId)
        tableView.register(HeaderContainerView.self, forHeaderFooterViewReuseIdentifier: HeaderContainerView.reuseId)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        tableView.sectionHeaderTopPadding = 0
    }
    
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return showShorts ? 2 : 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if showShorts && section == 1 {
            return 1
        } else {
            return videos.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if showShorts && indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ShortsCell.reuseId, for: indexPath) as! ShortsCell
            cell.configure(with: mockShorts)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: VideoCell.reuseId, for: indexPath) as! VideoCell
            cell.configure(with: videos[indexPath.row])
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if showShorts && indexPath.section == 1 {
            return 280
        } else {
            return 300
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderContainerView.reuseId) as! HeaderContainerView
            return header
        } else {
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
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 { return 130 }
        return 40
    }
}
