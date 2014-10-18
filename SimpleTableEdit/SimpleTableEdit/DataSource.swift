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

    var sectionTitles: Array<String>?

    //public API to the array
    func add(newVal: String) {
        // We'll set the value again, but we need to set it as something
        _actualData.append(true,newVal)
        setEditMode(true, index: _actualData.count - 1)
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
        return indexPath.row
    }

    // MARK - UITableViewDataSource
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : TableViewCell?
        var index = indexPath.row

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
            return 1
        if sectionTitles != nil {
            return sectionTitles!.count
        } else {
            return 1
        }
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var header :String?
        if sectionTitles?.count > section {
            header = sectionTitles![section]
        }
        return header
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _actualData.count
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle,
        forRowAtIndexPath indexPath: NSIndexPath) {

        switch editingStyle {
        case .Delete:
            _actualData.removeAtIndex(indexPath.row)
        case .Insert:
            _actualData.insert((true,"NEW"), atIndex: indexPath.row)
        case .None:
            // Do nothing
            break
        }
        tableView.reloadData()
    }

    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        println("Moving \(sourceIndexPath.row) to \(destinationIndexPath.row)")
        let srcIndex = _getIndexFromIndexPath(sourceIndexPath)
        let dstIndex = _getIndexFromIndexPath(destinationIndexPath)
        if srcIndex < 0 || srcIndex > _actualData.count ||
            dstIndex < 0 || dstIndex > _actualData.count ||
            srcIndex == dstIndex {
                return
        }

        println("existing src: \(_actualData[srcIndex]), dst: \(_actualData[dstIndex])")
        let tmp = _actualData[srcIndex]
        if srcIndex > dstIndex {
            for var i = srcIndex ; i > dstIndex ; --i {
                _actualData[i] = _actualData[i-1]
            }
        } else { // srcIndex < dstIndex
            for var i = srcIndex ; i < dstIndex ; ++i {
                _actualData[i] = _actualData[i+1]
            }
        }
        _actualData[dstIndex] = tmp
    }

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    //////////////////////////////////
    
    
}
