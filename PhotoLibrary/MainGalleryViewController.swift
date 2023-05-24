//
//  MainGalleryViewController.swift
//  PhotoLibrary
//
//  Created by Noi Berg on 12.05.2023.
//

import UIKit

class MainGalleryViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupStubImage()
    }
    
}


// MARK: - Setup viewDidLoad
extension MainGalleryViewController {
    func setupView() {
        overrideUserInterfaceStyle = .dark
    
        setupNavigationBar()
    }
}





// MARK: - Setup UI Elements
extension MainGalleryViewController {
  
    
    private func setupNavigationBar() {
        title = "Gallery"
        navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    func setupStubImage() {
        let image = UIImage(named: "stub")
        let imageView = UIImageView(image: image)
        imageView.center = view.center
        view.addSubview(imageView)
        
        
    }
}



