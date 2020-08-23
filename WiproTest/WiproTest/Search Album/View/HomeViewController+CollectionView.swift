//
//  HomeViewController+CollectionView.swift
//  WiproTest
//
//  Created by Ajay Odedra on 16/08/20.
//  Copyright © 2020 Ajay Odedra. All rights reserved.
//

import UIKit

// MARK: - UICollectionViewDataSource implementation
extension HomeViewController {
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return viewModel.searchResultData.value.count
    }
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchAlbumConstant.Identifier.collectionViewCellReuseIdentifier,
                                                      for: indexPath)
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView,
                                 willDisplay cell: UICollectionViewCell,
                                 forItemAt indexPath: IndexPath) {
        guard let cell = cell as? ImageCollectionViewCell else {
            return
        }
        let photo = viewModel.searchResultData.value[indexPath.item]
        cell.initWith(photo)
        if viewModel.isLastIndex(index: indexPath.row) {
            viewModel.getSearchDataResponse()
        }
    }
    override func collectionView(_ collectionView: UICollectionView,
                                 didEndDisplaying cell: UICollectionViewCell,
                                 forItemAt indexPath: IndexPath) {
        guard let cell = cell as? ImageCollectionViewCell else {
            return
        }
        cell.reducePriorityOfDownloadtaskForCell()
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: 55)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    override func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
        // Footer Loader View
        guard let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                               withReuseIdentifier: SearchAlbumConstant.Identifier.collectionViewfooterIdentifier,
                                                                               for: indexPath) as? CustomFooterView else {
            return UICollectionReusableView()
        }
        viewModel.showLoadingHud.value ? footerView.loader.startAnimating(): footerView.loader.stopAnimating()
        return footerView
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return viewModel.countCellSizeForIndexPath()
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        // Return collection padding
        return SearchAlbumConstant.CollectionView.cellPadding
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        // Return collection padding as edges to make it even spacing from all sides
        let padding = SearchAlbumConstant.CollectionView.cellPadding
        return UIEdgeInsets(top: padding,
                            left: padding,
                            bottom: padding,
                            right: padding)
    }
}
