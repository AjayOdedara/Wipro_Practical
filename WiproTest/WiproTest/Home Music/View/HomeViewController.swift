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


class HomeViewController: UICollectionViewController {

    fileprivate let searchController = UISearchController(searchResultsController: nil)
    fileprivate let viewModel: HomeMusicViewModel = HomeMusicViewModel()

    
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
            //MARK:Todo - Show Alert
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? ImageCollectionViewCell,
            let indexPath = self.collectionView?.indexPath(for: cell) {
            
            guard let detailViewController = segue.destination as? AlbumDetailViewController else{ return }
            detailViewController.photo = viewModel.searchResultData.value[indexPath.item]
        }
    }
}

// MARK: - UISearchBarDelegate implementation
extension HomeViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else {
            return
        }
        viewModel.currentPage = 0
        viewModel.searchResultData.value.removeAll()
        viewModel.getSearchDataResponse(searchText: query)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar){
        searchBar.placeholder = MainViewControllerConstants.Messages.searchDefaultPlaceholder
    }
}

// MARK: - UICollectionViewDataSource implementation
extension HomeViewController{
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return viewModel.searchResultData.value.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: viewModel.reuseIdentifier, for: indexPath)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let photo = viewModel.searchResultData.value[indexPath.item]
        (cell as! ImageCollectionViewCell).initWith(photo)
        
        if viewModel.isLastIndex(index:indexPath.row){
            viewModel.getSearchDataResponse()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as! ImageCollectionViewCell).reducePriorityOfDownloadtaskForCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: 55)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: viewModel.footerIdentifier, for: indexPath) as! CustomFooterView
        viewModel.showLoadingHud.value ? footerView.loader.startAnimating(): footerView.loader.stopAnimating()
        return footerView
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return viewModel.countCellSizeForIndexPath()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return viewModel.cellPadding
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: viewModel.cellPadding, left: viewModel.cellPadding, bottom: viewModel.cellPadding, right: viewModel.cellPadding)
    }
}
