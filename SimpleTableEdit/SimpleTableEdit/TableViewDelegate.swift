//
//  TableViewDelegate.swift
//  SimpleTableEdit
//
//  Created by Masa Jow on 10/7/14.
//  Copyright (c) 2014 Futomen. All rights reserved.
//

import UIKit

class TableViewDelegate: NSObject, UITableViewDelegate {

    var dataSource : DataSource?

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("didSelect")
        dataSource?.setEditOnIndex(true, index: indexPath.row)
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        println("didDeselect")
//        var selectedCell = tableView.cellForRowAtIndexPath(indexPath)
        tableView.setEditing(false, animated: true)
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, didEndEditingRowAtIndexPath indexPath: NSIndexPath) {
        println("didEndEditing")
    }
    
}
