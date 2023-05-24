//
//  PhotoCollectionViewController.swift
//  PhotoLibrary
//
//  Created by Noi Berg on 12.05.2023.
//

import UIKit

class PhotoCollectionViewController: UICollectionViewController {
    
    var networkDataFetcher = NetworkDataFetcher()
    
    static var photos = [UnsplashPhoto]()
    static var selectedImages = [UIImage]()
    private var timer: Timer?
    private var logoStubView = UIImageView()
    private let itemsPerRow: CGFloat = 1
    private let sectionInserts = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    
    private lazy var actionBarButtonItem: UIBarButtonItem = {
        let image = UIImage(named: "action")
        let barButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(actionBarButtonTapped))
        
        return barButtonItem
    }()
    
    private var numberOfSelectedPhotos: Int {
        return collectionView.indexPathsForSelectedItems?.count ?? 0
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
}





// MARK: - Setup viewDidLoad
extension PhotoCollectionViewController {
    func setupView() {
        overrideUserInterfaceStyle = .dark
        
        updateNavigationButtonsState()
        setupStubImage()
        setupCollectionView()
        setupNavigationBar()
        setupSearchBar()
    }
}





// MARK: - Setup UI Elements
extension PhotoCollectionViewController {
    private func setupStubImage() {
        let logoStub = UIImage(named: "logoUnsplash")
        logoStubView = UIImageView(image: logoStub)
        logoStubView.center = view.center
        view.addSubview(logoStubView)
    }
    
    private func setupCollectionView() {
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CellID")
        collectionView.register(PhotosCell.self, forCellWithReuseIdentifier: PhotosCell.reuseId)
        collectionView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.contentInsetAdjustmentBehavior = .automatic
        collectionView.allowsMultipleSelection = true
        
    }
    
    private func setupNavigationBar() {
        title = "Find on Unsplash"
        navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.tintColor = .white
        navigationItem.rightBarButtonItem = actionBarButtonItem
        
    }
    
    private func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search photo"
        
    }
}





//MARK: - Setup NavigationBar Items
extension PhotoCollectionViewController {
    private func updateNavigationButtonsState() {
        actionBarButtonItem.isEnabled = numberOfSelectedPhotos > 0
    }
    
    func refresh() {
        PhotoCollectionViewController.selectedImages.removeAll()
        self.collectionView.selectItem(at: nil, animated: true, scrollPosition: [])
        updateNavigationButtonsState()
        imageItemDisappearing()
    }
    
    
    @objc func actionBarButtonTapped(sender: UIBarButtonItem) {
        let shareController = UIActivityViewController(activityItems: PhotoCollectionViewController.selectedImages, applicationActivities: nil)
        
        shareController.completionWithItemsHandler = { _, bool, _, _ in
            if bool {
                self.refresh()
            }
        }
        shareController.popoverPresentationController?.barButtonItem = sender
        shareController.popoverPresentationController?.permittedArrowDirections = .any
        present(shareController, animated: true)
    }
    
    
    func imageItemDisappearing() {
        if !PhotoCollectionViewController.photos.isEmpty {
            logoStubView.alpha = 0.0
        }
    }
}





// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension PhotoCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PhotoCollectionViewController.photos.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCell.reuseId, for: indexPath) as! PhotosCell
        let unsplashPhoto = PhotoCollectionViewController.photos[indexPath.item]
        cell.unsplashPhotoSearch = unsplashPhoto
        
        
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        updateNavigationButtonsState()
        let cell = collectionView.cellForItem(at: indexPath) as! PhotosCell
        guard let image = cell.photoImageView.image else { return }
        PhotoCollectionViewController.selectedImages.append(image)
        navigationItem.searchController?.isActive = false
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        updateNavigationButtonsState()
        let cell = collectionView.cellForItem(at: indexPath) as! PhotosCell
        guard let image = cell.photoImageView.image else { return }
        if let index = PhotoCollectionViewController.selectedImages.firstIndex(of: image) {
            PhotoCollectionViewController.selectedImages.remove(at: index)
        }
    }
}





// MARK: - UISearchBarDelegate
extension PhotoCollectionViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
            self.networkDataFetcher.fetchImages(searchTerm: searchText) { [weak self] (searchResults) in
                guard let fetchedPhotos = searchResults else { return }
                PhotoCollectionViewController.photos = fetchedPhotos.results
                self?.collectionView.reloadData()
                self?.refresh()
            }
        })
    }
}





// MARK: - View Layout
extension PhotoCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let photo = PhotoCollectionViewController.photos[indexPath.item]
        let paddingSpace = sectionInserts.left * (itemsPerRow + 1)
        let availableWidtch = view.frame.width - paddingSpace
        let widthPerItem = availableWidtch / itemsPerRow
        let height = CGFloat(photo.height) * widthPerItem / CGFloat(photo.width)
        
        return CGSize(width: widthPerItem, height: height)
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInserts
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInserts.left
    }
}

