//
//  ViewController.swift
//  Contact
//
//  Created by 김남호 on 20-10-1.
//

import Cocoa

class ViewController: NSViewController {
    
    var titleWithVersion: String?
    @IBOutlet weak var dragDropView: ADragDropView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        applicationTitleByVersion()
        dragDropSettings()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        self.view.window?.title = self.titleWithVersion!
    }
    
    private func applicationTitleByVersion() {
        let productName = Bundle.main.infoDictionary?["CFBundleName"] as? String
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        self.titleWithVersion = "\(productName!) (v\(appVersion!))"
    }
    
    private func dragDropSettings() {
        dragDropView.allowAllFileExtensions = true
        dragDropView.delegate = self
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func openDialog(_ sender: Any) {
        let urls = OpenDialog().showModal()
        if (urls.count > 0) {
            processing(urls)
        }
    }
    
    func processing(_ urls: [URL]) {
        let filename = generateTemporaryFilePath()
        let scriptGen = ScriptGenerator(urls)
        if (scriptGen.saveToFile(filename)) {
            grantExecutable(filename)
            executeShellScript(filename)
        }
        deleteFile(filename)
    }

}

extension ViewController: ADragDropViewDelegate {
    func dragDropView(_ dragDropView: ADragDropView, droppedFileWithURL URL: URL) {
        var urls: [URL] = []
        urls.append(URL)
        processing(urls)
    }
    
    func dragDropView(_ dragDropView: ADragDropView, droppedFilesWithURLs URLs: [URL]) {
        processing(URLs)
    }
}
