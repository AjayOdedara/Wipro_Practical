//
//  ImageCollectionViewCell.swift
//  WiproTest
//
//  Created by Ajay Odedra on 15/08/20.
//  Copyright © 2020 Ajay Odedra. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell{
    @IBOutlet weak var imageView: CacheMemoryImageView!
    @IBOutlet weak var albumTitle: UILabel!
    @IBOutlet weak var artistName: UILabel!
    
    var photo: Album? = nil
    
    func initWith(_ data: Album?){
        photo = data
        guard let photo = photo, let thumbnailURL = URL(string: photo.image.last?.text ?? "") else {
            return
        }
        self.albumTitle.text = data?.name
        self.artistName.text = "By: " + ( data?.artist ?? "Unknown" )
        print(thumbnailURL)
        self.imageView.loadImage(atURL: thumbnailURL)
    }
    
    override func prepareForReuse() {
        self.albumTitle.text = ""
        self.artistName.text = ""
        self.imageView.image = nil
    }
    
    func reducePriorityOfDownloadtaskForCell(){
        guard let photo = photo,  let thumbnailURL = URL(string: photo.image.first?.text ?? "") else {
            return
        }
        AppServerClient.sharedInstance.reducePriorityOfTask(withURL: thumbnailURL)
    }
}
