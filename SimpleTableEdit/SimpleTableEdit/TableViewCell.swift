//
//  TableViewCell.swift
//  SimpleTableEdit
//
//  Created by Masa Jow on 10/7/14.
//  Copyright (c) 2014 Futomen. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var _textCell: UITextField!
    var _dataSource : DataSource?
    var currentIndex = 0

    func configureCell(dataSource: DataSource,
        index: Int) {
        _dataSource = dataSource
        currentIndex = index
        let edit = _dataSource?.getEditValue(index)
        let displayText = _dataSource?.getDataValue(index)

        println("Configure \(index) as \(edit)")
        if (edit == true) {
            _textCell.text = displayText
            textLabel?.hidden = true
            _textCell.hidden = false
        } else {
            textLabel?.text = displayText
            _textCell.hidden = true
            textLabel?.hidden = false
        }
        _textCell.delegate = self
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        _textCell.resignFirstResponder()
        println("textFieldShouldReturn")
        if _dataSource != nil {
            _dataSource!.setDataOnIndex(false, data: _textCell.text,
            index: currentIndex)
            _dataSource!.refresh()
        }

        return true
    }
    
}
