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
    var currentIndex: Int = 0
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapScreen))
        
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGesture)
        
        store.fetchInterestingPhotos {
            (photosResult) -> Void in
            
            switch photosResult {
            case let .success(photos):
                print("Succesfully found \(photos.count) photos.")
                self.photosCollection = photos
                if let firstPhoto = self.photosCollection.first {
                    self.updateImageView(for: firstPhoto)
                }
            case let .failure(error):
                print("Error fetching interesting photos: \(error)")
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
        currentIndex = (currentIndex + 1) % photosCollection.count
        
        let nextPhoto = photosCollection[currentIndex]
        updateImageView(for: nextPhoto)
    }
}

