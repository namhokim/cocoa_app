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
    @IBOutlet weak var datePicker: NSDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        datePicker.locale = Locale(identifier: Locale.current.identifier)
        datePicker.dateValue = Date()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func executionClicked(_ sender: Any) {
        let email = emailField.stringValue
        if email.isEmpty {
            outputPanel.stringValue = "Need input email"
            return
        }
        let password = passwordField.stringValue
        if password.isEmpty {
            outputPanel.stringValue = "Need input password"
            return
        }
        let dateRange = DateRange(targetDate: datePicker.dateValue)
        accessToken(email: email, password: password, dateRange: dateRange)
    }
    
    func accessToken(email: String, password: String, dateRange: DateRange) {
        let loginUrl = URL(string: "https://api2.hoursforteams.com/index.php/api/users/login")!
        var request = URLRequest(url: loginUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = LoginRequest(email: email, password: password)
            .toJsonString().data(using: .utf8, allowLossyConversion: false)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                self.outputToPanel(message: error?.localizedDescription ?? "No data")
                return
            }
            
            let result = LoginResponse.fromJsonData(data: data)
            if (result.status == "ok") {
                self.getTimersPerDay(token: result.result.token, dateRange: dateRange)
            } else {
                self.outputToPanel(message: result.error_message)
            }
            
        }
        task.resume()
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
                for i in 0..<result.result.time_entries.count {
                    let entry = result.result.time_entries[i]
                    let begin = self.epochToTime(epoch: entry.date_entry)
                    let end = self.epochToTime(epoch: entry.date_end)
                    let task = entry.note_text.count == 0 ? entry.task_name : entry.note_text
                    let line = "\(begin)-\(end) \(task)\n"
                    message += line
                }
                self.outputToPanel(message: message)
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
            self.outputPanel.stringValue = message
        }
    }
    
}

