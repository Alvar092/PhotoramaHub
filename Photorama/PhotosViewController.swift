//
//  PhotosViewController.swift
//  Photorama
//
//  Created by Álvaro Entrena Casas on 30/5/24.
//

import UIKit

class PhotosViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    var store: PhotoStore!
    var photosCollection: [Photo] = []
    var currentIndex = 0
    var interestingIndex = 0
    var recentIndex = 0
    var showingInteresting: Bool = false
    
    @IBAction func photoTypeChanged(_ sender: UISegmentedControl) {
        let fetchPhotos: (@escaping (Result<[Photo], Error>) -> Void) -> Void
        
        switch sender.selectedSegmentIndex {
        case 0:
            fetchPhotos = store.fetchInterestingPhotos
            showingInteresting = true
        case 1:
            fetchPhotos = store.fetchRecentPhotos
            showingInteresting = false
        default:
            return
        }
        
        fetchPhotos { (photosResult: Result<[Photo], Error>) in
            switch photosResult {
            case let .success(photos):
                print("Succesfully found \(photos.count) photos.")
                DispatchQueue.main.async {
                    self.photosCollection = photos
                    if self.showingInteresting {
                        self.currentIndex = self.interestingIndex
                    } else {
                        self.currentIndex = self.recentIndex
                    }
                    let currentPhoto = photos[self.currentIndex]
                    self.updateImageView(for: currentPhoto)
                }
            case let .failure(error):
                print("Error fetching interesting photos: \(error)")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapScreen))
        
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGesture)
        
        showingInteresting = true
        
        store.fetchInterestingPhotos { (photosResult) in
            switch photosResult {
            case let .success(photos):
                DispatchQueue.main.async {
                    self.photosCollection = photos
                    self.currentIndex = 0
                    if let firstPhoto = photos.first {
                        self.updateImageView(for: firstPhoto)
                    }
                }
            case let .failure(error):
                print("Error fetching photos: \(error)")
            }
        }
    }
    
    func updateImageView(for photo: Photo) {
        store.fetchImage(for: photo) {
            (ImageResult) -> Void in
            
            switch ImageResult {
            case let .success(image):
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            case let .failure(error):
                print("Error downloading image: \(error)")
            }
        }
    }
    
    @objc func didTapScreen() {
        guard !photosCollection.isEmpty else {
            print("Error, photos is empty")
            return
        }
        if showingInteresting {
            interestingIndex += 1
            currentIndex = interestingIndex
            print("Showing interesting picture \(currentIndex)")
        } else {
            recentIndex += 1
            currentIndex = recentIndex
            print("Showing recent picture \(currentIndex)")
        }
        
        let nextPhoto = photosCollection[currentIndex]
        updateImageView(for: nextPhoto)
    }
}

