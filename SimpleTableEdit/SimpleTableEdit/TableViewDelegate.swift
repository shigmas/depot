//
//  TableViewDelegate.swift
//  SimpleTableEdit
//
//  Created by Masa Jow on 10/7/14.
//  Copyright (c) 2014 Futomen. All rights reserved.
//

import UIKit

class TableViewDelegate: NSObject, UITableViewDelegate {

    var editSource : EditProtocol?

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        editSource?.setEditMode(true, index: indexPath.row)
        tableView.reloadData()
    }

    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        editSource?.setEditMode(false, index: indexPath.row)
        tableView.reloadData()
    }

    func tableView(tableView: UITableView, didEndEditingRowAtIndexPath indexPath: NSIndexPath) {
        println("didEndEditing")
    }
    
}
