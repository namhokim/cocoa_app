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
        let output = requestApi(email: email, password: password);
        outputPanel.stringValue = output
    }
    
    func requestApi(email: String, password: String) -> String {
        let loginData = LoginRequest(email: email, password: password)
        let encoder = JSONEncoder()
        let loginJson = try? encoder.encode(loginData)
        if (loginJson == nil) {
            return "Cannot serialize"
        }
        let jsonString = String(data: loginJson!, encoding: .utf8)
        let jsonData = jsonString?.data(using: .utf8, allowLossyConversion: false)
        
        
        let loginUrl = URL(string: "https://api2.hoursforteams.com/index.php/api/users/login")!
        var request = URLRequest(url: loginUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
            }
        }
        task.resume()
        
        let output = "Hello \(email)!"
        return output
    }
    
}

