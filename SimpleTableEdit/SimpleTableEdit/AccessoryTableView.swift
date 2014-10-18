//
//  AccessoryTableView.swift
//  SimpleTableEdit
//
//  Created by Masa Jow on 10/15/14.
//  Copyright (c) 2014 Futomen. All rights reserved.
//

import UIKit

class AccessoryTableView: UITableView, UIScrollViewDelegate {

    var accessoryView: UIScrollView?
    var _buttonRow : ButtonRowView?
    var _completions: Dictionary<String, String>?
    var completionsTrigger: String = ""

    // Constants
    let Height: CGFloat = 40.0

    func setLiteralCompletions(completions: Array<String>,
        trigger: String) {
            _completions = [:]
            completionsTrigger = trigger
            
            for v in completions {
                _completions![v] = v
            }
    }

    func getbuttonView() -> UIView {
        return _buttonRow!
    }

    func setSymbolicCompletions(completions: Dictionary<String,String>, trigger: String) {
        _completions = completions
        completionsTrigger = trigger
    }
    
    func initEditAccessoryView() {
        if _completions != nil {
            println("comps: \(_completions)")
            accessoryView = UIScrollView(frame: CGRect(x: 0, y: 0, width: frame.width, height: Height))
            accessoryView?.delegate = self
            var buttonRow = ButtonRowView(frame:CGRect(x: 0, y: 0, width: frame.width, height: Height))
            buttonRow.addButtons(_completions!)
            _buttonRow = buttonRow
            accessoryView?.addSubview(buttonRow)
        }
    }

    // MARK - UIScrollViewDelegate
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return _buttonRow
    }

}
