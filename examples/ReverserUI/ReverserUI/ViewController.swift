//
//  ViewController.swift
//  ReverserUI
//
//  Created by Masa Jow on 7/1/14.
//  Copyright (c) 2014 Masa Jow. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
                            
    @IBOutlet var _input: UITextField?
    @IBOutlet var _output: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func reverse(sender: AnyObject)
    {
        let d = DReverse(string: _input?.text)
        var rev = d.reverse()
        _output?.text = rev
    }

}

