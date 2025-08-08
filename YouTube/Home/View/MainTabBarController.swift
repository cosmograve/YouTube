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
        let videoRepo = MockVideoRepository()
        let mainVM = MainViewViewModel(videoUseCase: videoRepo)
        
        let homeVC = HomeViewController(viewModel: mainVM)
        let navHome = UINavigationController(rootViewController: homeVC)
        navHome.tabBarItem = UITabBarItem(title: "Home",
                                          image: UIImage(systemName: "house.fill"), tag: 0)
        
        viewControllers = [navHome]
    }
}
