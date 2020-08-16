//
//  HomeViewController.swift
//  WiproTest
//
//  Created by Ajay Odedra on 15/08/20.
//  Copyright © 2020 Ajay Odedra. All rights reserved.
//

import UIKit

class HomeViewController: UICollectionViewController {

    let searchController = UISearchController(searchResultsController: nil)
    
    let viewModel: HomeMusicViewModel = HomeMusicViewModel()

    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
     
        setUp()
        configureCollectionView()
        bindViewModel()
        
    }
    private func configureCollectionView() {
        guard let collectionView = collectionView else {
            fatalError("collectionView could not be found")
        }

        collectionView.delegate = self
        collectionView.dataSource = self
    }
    private func setUp(){
        
        self.title = viewModel.navTitle
        self.navigationController?.navigationBar.prefersLargeTitles = true
        searchController.searchBar.delegate = self
        self.definesPresentationContext = true
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = true
        self.navigationItem.titleView?.tintColor = .gray
        
    }
    private func updateCollectionView() {
      DispatchQueue.main.async{
        guard let collectionView = self.collectionView else {
          fatalError("self.collectionView could not be found")
        }
        collectionView.reloadData()
      }
    }
    
    // MARK: - Binding
    private func bindViewModel() {
        
        viewModel.searchResultData.bindAndFire() { [weak self] _ in
            self?.updateCollectionView()
        }
        
        viewModel.onShowError = { [weak self] alert in
            DispatchQueue.main.async{
                self?.presentSingleButtonDialog(alert: alert)
            }
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? ImageCollectionViewCell,
            let indexPath = self.collectionView?.indexPath(for: cell) {
            
            guard let detailViewController = segue.destination as? AlbumDetailViewController else{ return }
            detailViewController.viewModel = AlbumDetailViewModel(album: viewModel.searchResultData.value[indexPath.item]) 
        }
    }
}

extension HomeViewController: SingleButtonDialogPresenter { }
