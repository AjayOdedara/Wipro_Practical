//
//  PhotoDetailViewController.swift
//  WiproTest
//
//  Created by Ajay Odedra on 16/08/20.
//  Copyright © 2020 Ajay Odedra. All rights reserved.
//

import UIKit

class AlbumDetailViewController: UIViewController {
    @IBOutlet weak var imageView: CacheMemoryImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var albumTitle: UILabel!
    @IBOutlet weak var artistName: UILabel!
    var viewModel: AlbumDetailViewModel?
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.largeTitleDisplayMode = .never
        loadData()
    }
    func loadData() {
        self.imageView.alpha = 0
        self.activityIndicator.startAnimating()
        guard let album = viewModel?.album else {
            return
        }
        setDetailFrom(album: album)
    }
    /**
     * Use to set data of the Album.
     * It will set the image, artist and album values.
     
     * - Parameter album: set detail data and large Image
    */
    func setDetailFrom(album: Album) {
        guard let photoUrlString = album.image.filter({$0.size == .extralarge}).first?.text,
            let highResPhotoURL = URL(string: photoUrlString) else {
                return
        }
        // Load imageView highResolution image
        imageView.loadImage(atURL: highResPhotoURL, placeHolder: false, completion: {[weak self] in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                UIView.animate(withDuration: 0.5) {
                    self?.imageView.alpha = 1
                    self?.view.layoutIfNeeded()
                }
            }
        })
        self.albumTitle.text = album.name
        self.artistName.text = "By: " + album.artist
    }
    // MARK: - Binding
    private func bindViewModel() {
        viewModel?.loadWithData.bindAndFire { [weak self] isLoaded in
            if isLoaded {
                self?.loadData()
            }
        }
    }
    deinit {
        viewModel = nil
        albumTitle = nil
        artistName = nil
        imageView.image = nil
    }
    @IBAction func closePresentAction(_ sender: Any) {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
