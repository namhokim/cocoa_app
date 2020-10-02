//
//  ViewController.swift
//  Contact
//
//  Created by 김남호 on 20-10-1.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func openDialog(_ sender: Any) {
        let urls = OpenDialog().showModal()
        if (urls.count <= 0) {
            return
        }
        
        let filename = generateTemporaryFilePath()
        let scriptGen = ScriptGenerator(urls)
        if (scriptGen.saveToFile(filename)) {
            grantExecutable(filename)
            executeShellScript(filename)
        }
        deleteFile(filename)
    }

}
