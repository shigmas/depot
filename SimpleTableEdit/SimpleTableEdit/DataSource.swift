//
//  DataSource.swift
//  SimpleTableEdit
//
//  Created by Masa Jow on 10/7/14.
//  Copyright (c) 2014 Futomen. All rights reserved.
//

import UIKit

class DataSource: NSObject, UITableViewDataSource {

    private let ReuseIdentifier = "SimpleTableEdit"
    private var actualData: Array<(Bool, String)> = []
    var tableView: UITableView?
    
    //public API to the array
    func add(newVal: String) {
        // We'll set the value again, but we need to set it as something
        actualData.append(true,newVal)
        setEditOnIndex(true, index: actualData.count - 1)
    }
    
    func add() {
        add("NEW")
    }

    func clearEdit() {
        for (itIndex, val) in enumerate(actualData) {
            actualData[itIndex] = (false, val.1)
        }
    }

    func refresh() {
        if tableView != nil {
            tableView!.reloadData()
        }
    }

    func getEditValue(index: Int) -> Bool! {
        return actualData[index].0
    }
    
    func getDataValue(index: Int) -> String {
        return actualData[index].1
    }

    func setEditOnIndex(isEdit: Bool, index: Int) {
        let (lastEdit, lastString) = actualData[index]
        setDataOnIndex(isEdit, data: lastString, index: index)
    }

    func setDataOnIndex(isEdit: Bool,  data: String, index: Int) {
        let (lastEdit, lastString) = actualData[index]
        
        for (itIndex, val) in enumerate(actualData) {
            if (itIndex == index) {
                actualData[itIndex] = (isEdit, data)
            } else {
                actualData[itIndex] = (false, val.1)
            }
        }
    }
    
    // MARK - UITableViewDataSource
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : TableViewCell?
        
        cell = tableView.dequeueReusableCellWithIdentifier(ReuseIdentifier,
            forIndexPath: indexPath) as? TableViewCell
        
        if (cell == nil) {
            cell = TableViewCell(style: .Value1,
                reuseIdentifier: "SimpleTableEdit")
        }

        
        cell?.configureCell(self, index: indexPath.row)
            return cell!;
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actualData.count
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle,
        forRowAtIndexPath indexPath: NSIndexPath) {

        switch editingStyle {
        case .Delete:
            actualData.removeAtIndex(indexPath.row)
        case .Insert:
            actualData.insert((true,"NEW"), atIndex: indexPath.row)
        case .None:
            // Do nothing
            break
        }
        tableView.reloadData()
    }
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    
    
}
