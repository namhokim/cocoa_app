//
//  LoginViewController.swift
//  HoursContentCopier
//
//  Created by namho.kim on 30/09/2019.
//  Copyright © 2019 namo. All rights reserved.
//

import Cocoa

protocol LoginViewControllerDelegate {
    func tokenReceived(data: String)
}

class LoginViewController: NSViewController {
    var delegate: LoginViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var emailField: NSTextField!
    @IBOutlet weak var passwordField: NSSecureTextField!
    @IBOutlet weak var outputPanel: NSTextField!
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(self)
    }
    
    @IBAction func login(_ sender: Any) {
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
                let msg = error?.localizedDescription ?? "No data"
                self.outputToPanel(message: msg)
                return
            }
            
            let result = LoginResponse.fromJsonData(data: data)
            if (result.status == "ok") {
                self.closeSelfWith(token: result.result.token)
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
    
    func closeSelf() {
        DispatchQueue.main.async {
            self.dismiss(self)
        }
    }
    
    func closeSelfWith(token: String) {
        DispatchQueue.main.async {
            self.delegate?.tokenReceived(data: token)
            self.dismiss(self)
        }
    }
    
}
