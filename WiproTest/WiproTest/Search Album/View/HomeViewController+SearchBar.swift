//
//  HomeViewController+SearchBar.swift
//  WiproTest
//
//  Created by Ajay Odedra on 16/08/20.
//  Copyright © 2020 Ajay Odedra. All rights reserved.
//

import UIKit

// MARK: - UISearchBarDelegate implementation
extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else {
            return
        }
        viewModel.currentPage = 0
        viewModel.searchResultData.value.removeAll()
        viewModel.getSearchDataResponse(searchText: query)
        searchController.isActive = false
        searchBar.placeholder = viewModel.searchText
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.placeholder = SearchAlbumConstant.SearchView.searchPlaceHolder
    }
}
