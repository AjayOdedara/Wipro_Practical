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
    fileprivate let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)

    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
     
        
        setUp()
        configureCollectionView()
        //viewModel.getSearchDataResponse()
        bindViewModel()
        
    }
    private func configureCollectionView() {
      guard let collectionView = collectionView else {
        fatalError("collectionView could not be found")
      }

      collectionView.delegate = self
      collectionView.dataSource = self
//      collectionView.backgroundColor = Color.backgroundColor

      //collectionView.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: viewModel.reuseIdentifier)
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
//    // MARK: - Lazy Loading
//
//    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//      let itemsPerPage = viewModel.itemsPerPage
//      let itemsPerSection = viewModel.itemsPerSection
//      let itemsTreshold = viewModel.itemsTreshold
//
//      let currentItem = indexPath.row + (indexPath.section * itemsPerSection)
//      let treshHoldItem = (viewModel.currentPage * itemsPerPage) - itemsTreshold
//
//      if (currentItem > treshHoldItem) && (viewModel.currentPage < viewModel.totalPages) {
//        viewModel.getSearchDataResponse()
//      }
//    }

    private func updateCollectionView() {
      DispatchQueue.main.async{
        guard let collectionView = self.collectionView else {
          fatalError("self.collectionView could not be found")
        }

//        if collectionView.numberOfSections == 0 {
          collectionView.reloadData()
//        } else {
//          let numberOfSections = collectionView.numberOfSections
//          let lastIndexOfNewSections = numberOfSections + 2
//          let indexSet = IndexSet(integersIn: numberOfSections...lastIndexOfNewSections)
//
//          collectionView.insertSections(indexSet)
//        }
      }
    }
    
    func bindViewModel() {
        
        viewModel.searchResultData.bindAndFire() { [weak self] _ in
            self?.updateCollectionView()
        }
        
        viewModel.onShowError = { [weak self] alert in
            
        }
        
        viewModel.showLoadingHud.bind() { [weak self] visible in
            if let `self` = self {
                
            }
        }
        
    }
    
    @objc fileprivate func searchNextPage(){
        let currentPage = viewModel.searchResultData.value.count/viewModel.itemsPerPage
        viewModel.currentPage = currentPage + 1
        viewModel.getSearchDataResponse()
    }
}

extension HomeViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else {
            return
        }
        viewModel.currentPage = 1
        viewModel.searchResultData.value.removeAll()
        viewModel.getSearchDataResponse(searchText: query)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar){
        searchBar.placeholder = MainViewControllerConstants.Messages.searchDefaultPlaceholder
    }
}// MARK: - UICollectionViewDataSource implementation
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
        
//        guard let currentDataSourceSize = viewModel.searchResultData.value.count else{return}
        if viewModel.searchResultData.value.count - indexPath.row == (2 * viewModel.itemsPerRow){
            searchNextPage()
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
