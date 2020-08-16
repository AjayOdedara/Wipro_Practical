//
//  PhotoDetailViewController.swift
//  Mindera Test
//
//  Created by Ajay Odedra on 11/06/19.
//  Copyright © 2019 Ajay Odedra. All rights reserved.
//

import UIKit

    
    
class AlbumDetailViewController: UIViewController {
    
    
    @IBOutlet weak var imageView: CacheMemoryImageView!
    @IBOutlet weak var albumTitle: UILabel!
    @IBOutlet weak var artistName: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var viewModel: AlbumDetailViewModel? = nil
    
    override func viewDidLoad() {
        self.navigationItem.largeTitleDisplayMode = .never
        
        loadData()
    }
    
    /**
      Use to set data of the Album.
      It will set the image, artist and album values.
    */
    func loadData() {
        
        guard let photo = viewModel?.album,
            let photoUrlString = photo.image.filter({$0.size == .extralarge}).first?.text ,
            let highResPhotoURL = URL(string:  photoUrlString) else {
                return
        }
        
        self.activityIndicator.startAnimating()
        
        // Load ImageView HighResolution Image
        if CachedMemoryManager.shared.isImageCached(for: highResPhotoURL.absoluteString){
            imageView.loadImage(atURL: highResPhotoURL)
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
        } else{
            imageView.loadImage(atURL: highResPhotoURL)
            activityIndicator.startAnimating()
            imageView.loadImage(atURL: highResPhotoURL, placeHolder: false, completion: {[weak self] in
                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating()
                }
            })
        }
        
        
        self.albumTitle.text = photo.name
        self.artistName.text = "By: " + photo.artist
    }
    
    // MARK: - Binding
    private func bindViewModel() {
        
        viewModel?.loadWithData.bindAndFire() { [weak self] isLoaded in
            if isLoaded{
                self?.loadData()
            }
        }
    }
    
    @IBAction func closePresentAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
