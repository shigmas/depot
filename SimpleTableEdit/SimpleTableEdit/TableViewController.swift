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

    @IBOutlet var _tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addNode")
        self.navigationItem.rightBarButtonItem = addButton;
        var editButton = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "toggleEditMode")
        self.navigationItem.leftBarButtonItem = editButton;

        let nib = UINib(nibName: "TableViewCell",
            bundle: NSBundle.mainBundle())
        tableView.registerNib(nib, forCellReuseIdentifier: "SimpleTableEdit")

        // Do any additional setup after loading the view, typically from a nib.
        dataSource.tableView = _tableView
        tableView.dataSource = dataSource
        delegate.dataSource = dataSource
        tableView.delegate = delegate
    }

    func addNode() {
        dataSource.add()
        tableView.reloadData()
    }
    
    func toggleEditMode() {
        dataSource.clearEdit()
        tableView.reloadData()
        tableView.setEditing(!tableView.editing, animated: true)
        if tableView.editing {
            self.navigationItem.leftBarButtonItem?.title = "Done"
        } else {
            self.navigationItem.leftBarButtonItem?.title = "Edit"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

