//
//  ItemProtocol.swift
//  ItemManagerList
//
//  Created by Ankit Kumar Bharti on 03/09/18.
//  Copyright © 2018 Exilant. All rights reserved.
//

import Foundation

enum ItemCollectionError: Error {
    case ItemNotFound
}

protocol ManagableItem {
    func item(by name: String, from list: [Item]) -> [Item]
    func updateItem(_ item: Item, to list: inout [Item])
    func selectedItems(from list: [Item]) -> [Item]
    func index(of item: Item, from: [Item]) -> Int?
}

extension ManagableItem {
    
    func item(by name: String, from list: [Item]) -> [Item] {
         return list.filter { $0.name.hasPrefix(name) }
    }
    
    func index(of item: Item, from list: [Item]) -> Int? {
        return list.index{ $0.name == item.name }
    }
    
    func updateItem(_ item: Item, to list: inout [Item]) {
        let itemIndex = list.index{ $0.name == item.name }
        guard let index = itemIndex else { return }
        list[index] = item
    }
    
    func selectedItems(from list: [Item]) -> [Item] {
        return list.filter { $0.isSelected }
    }
}
