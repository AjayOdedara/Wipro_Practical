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
    
    var photo: Album? = nil
    
    func initWith(_ data: Album?){
        photo = data
        guard let photo = photo,
            let photoUrlString = photo.image.filter({$0.size == .large}).first?.text ,
            let thumbnailURL = URL(string:  photoUrlString) else {
            return
        }
        self.albumTitle.text = data?.name
        self.imageView.loadImage(atURL: thumbnailURL)
    }
    
    override func prepareForReuse() {
        self.albumTitle.text = ""
        self.imageView.image = nil
    }
    
    func reducePriorityOfDownloadtaskForCell(){
        guard let photo = photo,  let thumbnailURL = URL(string: photo.image.first?.text ?? "") else {
            return
        }
        AppServerClient.sharedInstance.reducePriorityOfTask(withURL: thumbnailURL)
    }
}
