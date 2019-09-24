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
        displayContentByPickupDate(email: email, password: password)
    }
    
    func displayContentByPickupDate(email: String, password: String) {
        accessToken(email: email, password: password)
    }
    
    func accessToken(email: String, password: String) {
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
                self.outputToPanel(message: result.result.token)
                self.expireToken(token: result.result.token)
            } else {
                self.outputToPanel(message: result.error_message)
            }
            
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
                self.outputToPanel(message: result.result)
            } else {
                self.outputToPanel(message: result.error_message)
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

