//
//  ViewController.swift
//  SimpleTableEdit
//
//  Created by Masa Jow on 10/7/14.
//  Copyright (c) 2014 Futomen. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    var dataSource = DataSource()
    var delegate = TableViewDelegate()
    var _barButtonItems = Array<UIBarButtonItem>()
    var _sectionTitles = ["Entries"]
    var _accessoryView : AccessoryTableView?

    @IBOutlet var _tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // We set the custom class for the table view controller to be our
        // AccessoryTableView
        if var accTableView = self.tableView as? AccessoryTableView {
            // For testing, we'll hardcode this here:
            /*
            let comps1 = ["gmail": "gmail.com", "yahoo": "yahoo.com",
            "aol": "aol.com", "compuserve": "compuserve.com",
            "googlegroups":"googlegroups.com"]
            setSymbolicCompletions(comps1, trigger: "@")
            */
            let comps2 = ["gmail.com", "yahoo.com", "aol.com","compuserve.com", "googlegroups.com"]
            accTableView.setLiteralCompletions(comps2, trigger: "@")
            accTableView.initEditAccessoryView()
        }

        // Do any additional setup after loading the view, typically from a nib.
        _initNavItems()
        _initTableViewCell()
        setSectionTitles(["First Time", "Recurring", "Out of Town"])
        tableView.dataSource = dataSource
        delegate.editSource = dataSource
        tableView.delegate = delegate
    }

    func setSectionTitles(titles: Array<String>) {
        _sectionTitles = titles
        dataSource.sectionTitles = titles
    }

    func addNode() {
        dataSource.add()
        tableView.reloadData()
    }
    
    func toggleEditMode() {
        dataSource.clearEdit()
        tableView.reloadData()
        tableView.setEditing(!tableView.editing, animated: true)
        let buttonIndex = tableView.editing ? 1 : 0
        self.navigationItem.setLeftBarButtonItem(_barButtonItems[buttonIndex], animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func _initNavItems() {
        var addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addNode")
        self.navigationItem.rightBarButtonItem = addButton
        // Set the two items
        _barButtonItems.append(UIBarButtonItem(title: "Edit", style: .Plain, target: self, action: "toggleEditMode"))
        _barButtonItems.append(UIBarButtonItem(title: "Done", style: .Plain, target: self, action: "toggleEditMode"))
        self.navigationItem.leftBarButtonItem = _barButtonItems[0]
    }

    func _initTableViewCell() {
        let nib = UINib(nibName: "TableViewCell",
            bundle: NSBundle.mainBundle())
        tableView.registerNib(nib, forCellReuseIdentifier: "SimpleTableEdit")
    }

}

