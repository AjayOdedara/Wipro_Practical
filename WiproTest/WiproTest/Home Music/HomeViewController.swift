//
//  HomeViewController.swift
//  WiproTest
//
//  Created by Ajay Odedra on 15/08/20.
//  Copyright © 2020 Ajay Odedra. All rights reserved.
//

import UIKit

private struct MainViewControllerConstants{
    static let navTitle = "Last.Fm Search"
    
    struct Messages{
        static let searchDefaultPlaceholder = "Search"
    }
}


class HomeViewController: UIViewController {

    fileprivate let searchController = UISearchController(searchResultsController: nil)
    
    let viewModel: HomeViewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }

    
    func setUp(){
        
        self.title = MainViewControllerConstants.navTitle
        self.navigationController?.navigationBar.prefersLargeTitles = true
        searchController.searchBar.delegate = self
        self.definesPresentationContext = true
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.titleView = searchController.searchBar
        self.navigationItem.titleView?.tintColor = .gray
        searchController.hidesNavigationBarDuringPresentation = false
        
    }
    
    func bindViewModel() {
        
        viewModel.responseData.bindAndFire() { [weak self] _ in
            
        }
        
        viewModel.onShowError = { [weak self] alert in
            
        }
        
        viewModel.showLoadingHud.bind() { [weak self] visible in
            if let `self` = self {
                
            }
        }
        
    }
    
}

extension HomeViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar){
        searchBar.placeholder = MainViewControllerConstants.Messages.searchDefaultPlaceholder
    }
}
