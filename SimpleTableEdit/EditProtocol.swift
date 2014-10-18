//
//  EditProtocol.swift
//  SimpleTableEdit
//
//  Created by Masa Jow on 10/14/14.
//  Copyright (c) 2014 Futomen. All rights reserved.
//

import Foundation

// A set of String values for edit.  Accessed by index
protocol EditProtocol {
    // Is the EditProtocol in edit mode?
    func inEditMode(index: Int) -> Bool

    func setEditMode(value: Bool, index: Int)
    
    // Get the content for the specified index.
    func getContent(index: Int) -> String

    func setContent(index: Int, content: String)
}