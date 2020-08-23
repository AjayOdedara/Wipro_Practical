//
//  SearchAlbumConstant.swift
//  WiproTest
//
//  Created by Ajay Odedra on 23/08/20.
//  Copyright © 2020 Ajay Odedra. All rights reserved.
//

import UIKit
public struct SearchAlbumConstant {
    // MARK: - Current Implementation
    struct SearchView {
        static let searchPlaceHolder = NSLocalizedString("album_search_bar_placeholder", comment: "Search bar place holder")
        static let navigationTitle = NSLocalizedString("album_search_navigation_bar_title", comment: "Album search navigation large title")
    }
    struct Identifier {
        static let collectionViewCellReuseIdentifier = "ImageCollectionViewCell"
        static let collectionViewfooterIdentifier = "CustomFooterView"
    }
    struct CollectionView {
        static let itemsPerPage = 30
        static let itemsPerRow = 3
        static let cellPadding: CGFloat = 5.0
    }
}
