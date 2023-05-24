//
//  MainTabBarController.swift
//  PhotoLibrary
//
//  Created by Noi Berg on 12.05.2023.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewControllers()
        tabBarStyle()
        
    }

}





// MARK: - Setup vieDidLoad
extension MainTabBarController {
    func tabBarStyle() {
        tabBar.tintColor = .white
        tabBar.barStyle = .black
        
        let photoVC = PhotoCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let galleryVC = MainGalleryViewController()
        
        viewControllers = [
            generateNavigationController(rootViewController: galleryVC, title: "Gallery", image: #imageLiteral(resourceName: "photos")),
            generateNavigationController(rootViewController: photoVC, title: "Find on Unsplash", image: #imageLiteral(resourceName: "search")),
        ]
    }
}





// MARK: - Setup View Controllers
extension MainTabBarController {
    func setupViewControllers() {
        let photoVC = PhotoCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let galleryVC = MainGalleryViewController()
        
        
        viewControllers = [
            generateNavigationController(rootViewController: galleryVC, title: "Gallery", image: #imageLiteral(resourceName: "photos")),
            generateNavigationController(rootViewController: photoVC, title: "Find on Unsplash", image: #imageLiteral(resourceName: "logoUnsplash")),
        ]
    }
}





// MARK: - Setup NAvigation Controllers
extension MainTabBarController {
    private func generateNavigationController(rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = image
        
        return navigationVC
    }
}
