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
    var _tableView: AccessoryTableView?
    var _editSource : EditProtocol?
    var _currentIndex = 0

    func configureCell(editSource: EditProtocol, index: Int, tableView: UITableView) {
        _editSource = editSource
        _currentIndex = index
        _tableView = tableView as? AccessoryTableView
        let edit = _editSource?.inEditMode(index)
        let displayText = _editSource?.getContent(index)

        println("Configure \(index) as \(edit)")
        if (edit == true) {
            _textCell.text = displayText
            // Start it out hidden
            _tableView?.accessoryView?.hidden = true
            _textCell.inputAccessoryView = _tableView?.accessoryView
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

    @IBAction func _onValueChanged(sender: AnyObject) {
        println("text: \(_textCell.text)")
        _editSource!.setContent(_currentIndex, content: _textCell.text)
        let selRange = _textCell.selectedTextRange
        // This is placed after the last text entered (if we're just typing
        // l->r
        let cursorPos = selRange?.start
        let accessoryView = _tableView?.accessoryView!
        if cursorPos != nil && accessoryView != nil {
            // Get the character one to the left of the current position
            let posBeforeCursor = _textCell.positionFromPosition(cursorPos!, inDirection: .Left, offset: 1)
            let rangeForCharBeforeCursor = _textCell.textRangeFromPosition(cursorPos!, toPosition: posBeforeCursor)
            let prevChar = _textCell.textInRange(rangeForCharBeforeCursor)
            if prevChar == _tableView?.completionsTrigger {
                _showAccessoryView()
            }
        }
    }

    func _showAccessoryView() {
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector: "_onCompletionChosen:",
            name: ButtonRowView_CompletionChosenNotification,
            object: _tableView?.getbuttonView())
        _tableView?.accessoryView?.hidden = false
    }

    func _hideAccessoryView() {
        let nc = NSNotificationCenter.defaultCenter()
        nc.removeObserver(self)
        _tableView?.accessoryView?.hidden = true
    }

    func _onCompletionChosen(notification: NSNotification) {
        let selRange = _textCell.selectedTextRange
        let cursorPos = selRange?.start

        // Substitute the selRange with the notification's contents
        let notInfo = notification.userInfo
        if notInfo != nil {
            let posAfterCursor = _textCell.positionFromPosition(cursorPos!, inDirection: .Right, offset: 1)
            let rangeForCharAfterCursor = _textCell.textRangeFromPosition(cursorPos!, toPosition: posAfterCursor)

            let contents = notInfo as Dictionary<String,String>
            let completion = contents[ButtonRowView_CompletionKey]
            _textCell.replaceRange(rangeForCharAfterCursor, withText: completion!)
            _editSource!.setContent(_currentIndex, content: _textCell.text)
        }
        _hideAccessoryView()
    }

    // MARK UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        _textCell.resignFirstResponder()
        println("textFieldShouldReturn")
        if _editSource != nil {
            _editSource!.setContent(_currentIndex, content: _textCell.text)
            _tableView!.reloadData()
        }

        return true
    }
    
}
