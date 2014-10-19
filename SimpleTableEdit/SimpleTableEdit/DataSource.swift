//
//  DataSource.swift
//  SimpleTableEdit
//
//  Created by Masa Jow on 10/7/14.
//  Copyright (c) 2014 Futomen. All rights reserved.
//

import UIKit

class DataSource: NSObject, UITableViewDataSource, EditProtocol {

    private let ReuseIdentifier = "SimpleTableEdit"
    private var _actualData: Array<(Bool, String)> = []

    // The sectionIndex to the first item.
    var rowsInSection: Dictionary<Int, Int> = [:]

    var sectionTitles: Array<String>  {
        didSet {
            for (var i = 0 ; i < sectionTitles.count ; ++i) {
                rowsInSection[i] = 0
            }
        }
    }

    override init() {
        // Need some defaults
        sectionTitles = ["Default"]
    }
    
    //public API to the array
    func add(newVal: String) {
        // We'll set the value again, but we need to set it as something
        _actualData.append(true,newVal)
        setEditMode(true, index: _actualData.count - 1)

        // It has to go in a section, so put it at the end
        let last = rowsInSection.count-1
        rowsInSection[last] = rowsInSection[last]! + 1
    }
    
    func add() {
        add("NEW")
    }

    // MARK EditProtocol
    func inEditMode(index: Int) -> Bool {
        return _actualData[index].0
    }

    func setEditMode(value: Bool, index: Int) {
        let (lastEdit, lastString) = _actualData[index]
        _setDataOnIndex(value, data: lastString, index: index)
    }

    func getContent(index: Int) -> String {
        return _actualData[index].1
    }

    func setContent(index: Int, content: String) {
        _setDataOnIndex(false, data: content, index: index)
    }
    ////////////////////

    func clearEdit() {
        for (itIndex, val) in enumerate(_actualData) {
            _actualData[itIndex] = (false, val.1)
        }
    }

    func _setDataOnIndex(isEdit: Bool,  data: String, index: Int) {
        let (lastEdit, lastString) = _actualData[index]
        
        for (itIndex, val) in enumerate(_actualData) {
            if (itIndex == index) {
                _actualData[itIndex] = (isEdit, data)
            } else {
                _actualData[itIndex] = (false, val.1)
            }
        }
    }

    func _getIndexFromIndexPath(indexPath: NSIndexPath) -> Int {
        let section = indexPath.section
        var count = 0
        var index = 0
        while index < indexPath.section && index < (rowsInSection.count - 1) {
            count += rowsInSection[index]!
            index++
        }
        count = count + indexPath.row

        println("indexPath: \(indexPath.row),\(indexPath.section) to \(count)")
        return count
    }

    // MARK - UITableViewDataSource
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : TableViewCell?
        var index = _getIndexFromIndexPath(indexPath)

        cell = tableView.dequeueReusableCellWithIdentifier(ReuseIdentifier,
            forIndexPath: indexPath) as? TableViewCell
        
        if (cell == nil) {
            cell = TableViewCell(style: .Value1,
                reuseIdentifier: "SimpleTableEdit")
        }
        
        cell?.configureCell(self, index: index, tableView: tableView)
        return cell!;
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionTitles.count
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var header :String?
        if sectionTitles.count > section {
            header = sectionTitles[section]
        }
        return header
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Sanity
        if rowsInSection.count > section {
            return rowsInSection[section]!
        }
        
        return 0
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle,
        forRowAtIndexPath indexPath: NSIndexPath) {

        let index = _getIndexFromIndexPath(indexPath)
        switch editingStyle {
        case .Delete:
            _actualData.removeAtIndex(index)
        case .Insert:
            _actualData.insert((true,"NEW"), atIndex: index)
        case .None:
            // Do nothing
            break
        }
        tableView.reloadData()
    }

    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        println("Moving \(sourceIndexPath.row), \(sourceIndexPath.section) to \(destinationIndexPath.row), \(destinationIndexPath.section)")
        let srcIndex = _getIndexFromIndexPath(sourceIndexPath)
        let dstIndex = _getIndexFromIndexPath(destinationIndexPath)
        if srcIndex < 0 || srcIndex > _actualData.count ||
            dstIndex < 0 || dstIndex > _actualData.count {
            // equal is okay - maybe it's only between sections
                return
        }
        
        let tmp = _actualData[srcIndex]
        if srcIndex > dstIndex {
            for var i = srcIndex ; i > dstIndex ; --i {
                _actualData[i] = _actualData[i-1]
            }
        } else if srcIndex < dstIndex {
            for var i = srcIndex ; i < dstIndex ; ++i {
                _actualData[i] = _actualData[i+1]
            }
        } // else, if ==, no need to move stuff around.
        _actualData[dstIndex] = tmp

        // Update the sections, if anything changed
        rowsInSection[sourceIndexPath.section] = rowsInSection[sourceIndexPath.section]!-1
        rowsInSection[destinationIndexPath.section] = rowsInSection[destinationIndexPath.section]!+1
    }

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    //////////////////////////////////
    
    
}
