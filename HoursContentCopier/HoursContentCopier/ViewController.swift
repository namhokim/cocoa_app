//
//  ViewController.swift
//  HoursContentCopier
//
//  Created by namho.kim on 24/09/2019.
//  Copyright © 2019 namo. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var emailField: NSTextField!
    @IBOutlet weak var passwordField: NSSecureTextField!
    @IBOutlet weak var outputPanel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func executionClicked(_ sender: Any) {
        var email = emailField.stringValue
        if email.isEmpty {
            email = "Need input email"
        }
        let output = "Hello \(email)!"
        outputPanel.stringValue = output
    }
    
}

