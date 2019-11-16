//
//  PostProcessingHistoryItems.swift
//  HoursContentCopier
//
//  Created by namo on 19-11-16.
//  Copyright © 2019 namo. All rights reserved.
//

import Foundation
import Cocoa

class PostProcessingHistoryItems : NSObject, NSComboBoxDataSource {
    let ITEM_SIZE_MAX = 5
    
    private var items = Array<String>()
    
    override init() {
        items = Array<String>()
    }
    
    func initData(initItems: Array<String>) {
        items = initItems
        ensureLimitSize()
    }
    
    func size() -> Int {
        return items.count
    }
    
    func getData() -> Array<String> {
        return items
    }
    
    func add(command : String) {
        removeElem(value: command)
        items.append(command)
        ensureLimitSize()
    }
    
    private func removeElem(value: String) {
        let indexOpt = items.firstIndex(of: value)
        if let index = indexOpt {
            items.remove(at: index)
        }
    }
    
    private func ensureLimitSize() {
        if (items.count > ITEM_SIZE_MAX) {
            items.remove(at: 0)
        }
    }
    
    // overrides
    func numberOfItems(in comboBox: NSComboBox) -> Int {
        return items.count
    }

    func comboBox(_ comboBox: NSComboBox, objectValueForItemAt index: Int) -> Any? {
        return items[index] as String
    }

    
    func comboBox(_ comboBox: NSComboBox, indexOfItemWithStringValue string: String) -> Int {
        if let index = items.firstIndex(of: string) {
            return index
        }
        return NSNotFound
    }

    func comboBox(_ comboBox: NSComboBox, completedString string: String) -> String? {
        if let matchedFirst = items.first(where: {$0.caseInsensitiveCompare(string) == .orderedSame}) {
            return matchedFirst
        }
        return nil
    }
}
