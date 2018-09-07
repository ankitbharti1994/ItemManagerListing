//
//  DataManager.swift
//  ItemManagerList
//
//  Created by Ankit Kumar Bharti on 03/09/18.
//  Copyright © 2018 Exilant. All rights reserved.
//

import Foundation

struct DataManager: ManagableItem {
    
    private(set) static var itemList: [Item] = []
    
    static var didUpdateItem: (([Item]) -> ())?
    
    @discardableResult
    static func add(items: Item...) -> [Item] {
        for item in items {
            itemList.append(item)
        }
        return itemList
    }
    
    @discardableResult
    static func dummyItems(count: Int) -> [Item] {
        let _ = (0...10).map { add(items: Item(name: "Item \($0)", isSelected: false)) }
        return itemList
    }
    
    static func updateItemList(items: [Item]) {
        let _ = items.map {
            if let itemIndex = DataManager().index(of: $0, from: itemList) {
                itemList[itemIndex] = $0
            }
        }
        didUpdateItem?(DataManager().selectedItems(from: itemList))
    }
}
