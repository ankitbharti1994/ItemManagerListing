//
//  ViewController.swift
//  ItemManagerList
//
//  Created by Ankit Kumar Bharti on 03/09/18.
//  Copyright © 2018 Exilant. All rights reserved.
//

import UIKit

class ItemListVC: UIViewController, ManagableItem {

    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    private lazy var viewModel: ItemViewModel = {
        let itemModel = ItemViewModel(tableView: tableView)
        return itemModel
    }()
    
    // MARK: - Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchController()
        viewModel.didItemSelect = {[weak self] isSelected in
            self?.configureDoneButton(isSelected)
        }
        viewModel.configureSelectedRow()
    }
    
    @IBAction func dismissVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Configure search controller
    private func configureSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "search by name"
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.searchBar.tintColor = .white
        searchController.dimsBackgroundDuringPresentation = false
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }
    
    // MARK: - Configure Done Button and commit changes
    private func configureDoneButton(_ isItemSelected: Bool) {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(commitChanges))
        navigationItem.rightBarButtonItem = isItemSelected ? doneButton : nil
    }
    
    @objc func commitChanges() {
        DataManager.updateItemList(items: viewModel.dummyItem)
        dismiss(animated: true, completion: nil)
    }
}


// MARK: - UITableViewDataSource
extension ItemListVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.isSearching ? viewModel.filteredItems.count : viewModel.dummyItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let item = viewModel.isSearching ? viewModel.filteredItems[indexPath.row] : viewModel.dummyItem[indexPath.row]
        cell.textLabel?.text = item.name
        return cell
    }
}


// MARK: - UITableViewDelegate
extension ItemListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.update(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        viewModel.update(at: indexPath, isSelected: false)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.selectedBackgroundView = UIView()
    }
}


// MARK: - UISearchControllerDelegate
extension ItemListVC: UISearchControllerDelegate {
    func willPresentSearchController(_ searchController: UISearchController) {
        viewModel.isSearching = true
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        viewModel.isSearching = false
    }
}


// MARK: - UISearchResultsUpdating
extension ItemListVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, searchText.count > 0 else {
            viewModel.filteredItems = viewModel.dummyItem
            return
        }
        viewModel.filteredItems = self.item(by: searchText, from: viewModel.dummyItem)
    }
}
