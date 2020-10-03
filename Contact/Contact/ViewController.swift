//
//  ViewController.swift
//  Contact
//
//  Created by 김남호 on 20-10-1.
//

import Cocoa

class ViewController: NSViewController {
    
    private var titleWithVersion: String?
    private var trackingArea: NSTrackingArea?
    @IBOutlet weak var dragDropView: ADragDropView!
    @IBOutlet weak var openButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        applicationTitleByVersion()
        dragDropSettings()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        view.window?.title = self.titleWithVersion!
        openButton.isHidden = true
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
    
    override var acceptsFirstResponder: Bool {
        return true
    }

    @IBAction func showHelp(_ sender: Any) {
        let url = URL(string: "https://namocom.tistory.com/901")!
        NSWorkspace.shared.open(url)
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
    
    private func processing(_ urls: [URL]) {
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
    
    func mouseEntered(_ dragDropView: ADragDropView, with event: NSEvent) {
        openButton.isHidden = false
    }
    
    func mouseExited(_ dragDropView: ADragDropView, with event: NSEvent) {
        openButton.isHidden = true
    }
}
