//
//  SelectedItemListVC.swift
//  ItemManagerList
//
//  Created by Ankit Kumar Bharti on 03/09/18.
//  Copyright © 2018 Exilant. All rights reserved.
//

import UIKit

class SelectedItemListVC: UIViewController {

    private var selectedItems: [Item] = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DataManager.dummyItems(count: 10)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DataManager.didUpdateItem = { [weak self] items in
            self?.selectedItems = items
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
}


// MARK: - UITableViewDataSource
extension SelectedItemListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = selectedItems[indexPath.row].name
        return cell
    }
}
