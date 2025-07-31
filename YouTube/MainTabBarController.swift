//
//  MainTabBarController.swift
//  YouTube
//
//  Created by Алексей Авер on 23.07.2025.
//

import UIKit

final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }
    
    private func setupTabs() {
        let home = UINavigationController(rootViewController: HomeViewController())
        home.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)
        
        let shorts = UINavigationController(rootViewController: HomeViewController())
        shorts.tabBarItem = UITabBarItem(title: "Shorts", image: UIImage(systemName: "play.rectangle.fill"), tag: 1)
        
        viewControllers = [home, shorts]
    }

}
