//
//  ItemViewModel.swift
//  ItemManagerList
//
//  Created by Ankit Kumar Bharti on 06/09/18.
//  Copyright © 2018 Exilant. All rights reserved.
//

import UIKit

class ItemViewModel: ManagableItem {
    
    // MARK: - Properties
    private var tableView: UITableView
    var dummyItem: [Item] = DataManager.itemList
    var isSearching = false
    var filteredItems: [Item] = [] {
        didSet {
            tableView.reloadData()
            configureSelectedRow()
        }
    }
    
    var didItemSelect: ((Bool) -> ())?
    
    private var isSelectedItem = false {
        didSet {
            didItemSelect?(isSelectedItem)
        }
    }
    
    var selectedIndexPaths: [IndexPath] {
        guard let indexPaths = tableView.indexPathsForSelectedRows else { return [] }
        return indexPaths
    }
    
    // MARK: - Class initialization
    init(tableView: UITableView) {
        self.tableView = tableView
        self.tableView.setEditing(true, animated: true)
    }
    
    // MARK: - Configure tableview for pre-selected row
    func configureSelectedRow() {
        let items = isSearching ? filteredItems : dummyItem
        for (index, item) in items.enumerated() {
            if item.isSelected {
                let indexPath = IndexPath(row: index, section: 0)
                tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            }
        }
    }
    
    // MARK: - update the selection of items
    func update(at indexPath: IndexPath, isSelected: Bool = true) {
        if isSearching {
            let item = filteredItems[indexPath.row]
            if let itemIndex = index(of: item, from: dummyItem) {
                dummyItem[itemIndex].isSelected = isSelected
            }
        }else {
            dummyItem[indexPath.row].isSelected = isSelected
        }
        isSelectedItem = selectedIndexPaths.count > 0
    }
}
