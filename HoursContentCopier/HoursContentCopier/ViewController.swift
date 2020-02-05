//
//  ViewController.swift
//  HoursContentCopier
//
//  Created by namho.kim on 24/09/2019.
//  Copyright © 2019 namo. All rights reserved.
//

import Cocoa

struct Constants {
    static let loginSeque = "loginSeque"
}

class ViewController: NSViewController, LoginViewControllerDelegate, CompletePostProcessingDelegate {

    var titleWithVersion: String?
    var postProcHistoryItems: PostProcessingHistoryItems?
    
    @IBOutlet weak var outputPanel: NSTextField!
    @IBOutlet weak var datePicker: NSDatePicker!
    @IBOutlet weak var postProcessingCmds: NSComboBox!
    
    @IBAction func setPrevDate(_ sender: Any) {
        datePicker.dateValue = datePicker.dateValue.addingTimeInterval(TimeInterval(-86400))
    }
    
    @IBAction func setToday(_ sender: Any) {
        datePicker.dateValue = Date()
    }
    
    @IBAction func setNextDate(_ sender: Any) {
        datePicker.dateValue = datePicker.dateValue.addingTimeInterval(TimeInterval(86400))
    }
    
    @IBAction func getContentClicked(_ sender: Any) {
        updatePostProcessingCommands()
        if (needLogin()) {
            self.performSegue(withIdentifier: Constants.loginSeque, sender: self)
        } else {
            let dateRange = DateRange(targetDate: datePicker.dateValue)
            getTimersPerDay(token: AppDelegate.getToken(), dateRange: dateRange)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        datePicker.locale = Locale(identifier: Locale.current.identifier)
        datePicker.dateValue = Date()
        
        let productName = Bundle.main.infoDictionary?["CFBundleName"] as? String
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        self.titleWithVersion = "\(productName!) (v\(appVersion!))"
        
        postProcHistoryItems = PostProcessingHistoryItems()
        postProcHistoryItems!.initData(initItems: HistoryItemByUserDefaults.load())
        postProcessingCmds.usesDataSource = true
        postProcessingCmds.dataSource = postProcHistoryItems
        postProcessingCmds.completes = true
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        self.view.window?.title = self.titleWithVersion!
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.loginSeque {
            let loginViewController = segue.destinationController as! LoginViewController
            loginViewController.delegate = self
        }
    }
    
    func updatePostProcessingCommands() {
        if (postProcessingCmds.stringValue.isEmpty) {
            return
        }
        
        if let items = postProcHistoryItems {
            items.add(command: postProcessingCmds.stringValue)
            HistoryItemByUserDefaults.save(data: postProcHistoryItems!.getData())
        }
    }
    
    func tokenReceived(data: String) {
        AppDelegate.setToken(token: data)
        let dateRange = DateRange(targetDate: datePicker.dateValue)
        getTimersPerDay(token: data, dateRange: dateRange)
    }
    
    func processingCompleted(data: String) {
        DispatchQueue.main.async {
            self.outputPanel.stringValue = data
        }
    }
    
    func needLogin() -> Bool {
        return !AppDelegate.hasToken()
    }
    
    func epochToTime(epoch: Int) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: Locale.current.identifier)
        formatter.dateFormat = "HH:mm"
        
        return formatter.string(from: Date(timeIntervalSince1970: Double(epoch)))
    }
    
    func getTimersPerDay(token: String, dateRange: DateRange) {
        let timersUrl = URL(string: "https://api3.hoursforteams.com/index.php/api/timers/day/\(dateRange.begin)/0/\(dateRange.end)")!
        var request = URLRequest(url: timersUrl)
        request.httpMethod = "GET"
        request.setValue(token, forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                self.outputToPanel(message: error?.localizedDescription ?? "No data")
                return
            }
            
            let result = TimersResponse.fromJsonData(data: data)
            if (result.status == "ok") {
                var message = ""
                let entryCount = result.result.time_entries.count
                let lastEntryCount = entryCount - 1
                for i in 0..<entryCount {
                    let entry = result.result.time_entries[i]
                    let begin = self.epochToTime(epoch: entry.date_entry)
                    let end = self.epochToTime(epoch: entry.date_end)
                    let task = entry.note_text.count == 0 ? entry.task_name : entry.note_text
                    
                    var line: String
                    if (i < lastEntryCount) {
                        line = "\(begin)-\(end) \(task)\n"
                    } else {
                        line = "\(begin)-\(end) \(task)"
                    }
                    message += line
                }
                self.outputToPanel(message: message)
            } else if (result.error_code == 401) {
                self.loginSeque(message: result.error_message)
            } else {
                self.outputToPanel(message: String(data: data, encoding: .utf8)!)
            }
            //self.expireToken(token: token)
        }
        task.resume()
    }
    
    func expireToken(token: String) {
        let logoutUrl = URL(string: "https://api2.hoursforteams.com/index.php/api/users/logout")!
        var request = URLRequest(url: logoutUrl)
        request.httpMethod = "GET"
        request.setValue(token, forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                self.outputToPanel(message: error?.localizedDescription ?? "No data")
                return
            }
            
            let result = LogoutResponse.fromJsonData(data: data)
            if (result.status == "ok") {
                print("logout: \(result.result)")
            } else {
                print("logout: \(result.error_message)")
            }
            
        }
        task.resume()
    }
    
    func outputToPanel(message: String) {
        DispatchQueue.main.async {
            if (!self.postProcessingCmds.stringValue.isEmpty) {
                let pp = PipeProcessing(delegate: self)
                pp.processPipe(content: message, command: self.postProcessingCmds.stringValue)
            } else {
                self.outputPanel.stringValue = message
            }
        }
    }
    
    func loginSeque(message: String) {
        DispatchQueue.main.async {
            AppDelegate.setToken(token: "")
            self.outputPanel.stringValue = message
            self.performSegue(withIdentifier: Constants.loginSeque, sender: self)
        }
    }
    
}

