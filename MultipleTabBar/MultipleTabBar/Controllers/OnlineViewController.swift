//
//  ViewController.swift
//  MultipleTabBar
//
//  Created by Surabhi Gupta on 4/15/19.
//  Copyright © 2019 Surabhi Gupta. All rights reserved.
//

import UIKit
import Alamofire
import Reachability

class OnlineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var onlineTableView: UITableView!
    var reachability = Reachability()!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onlineTableView.register(UINib(nibName: "SignInTableViewCell", bundle: nil), forCellReuseIdentifier: "SignInTableViewCell")
        onlineTableView.register(UINib(nibName: "ImageTableViewCell", bundle: nil), forCellReuseIdentifier: "ImageTableViewCell")
        onlineTableView.register(UINib(nibName: "ButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "ButtonTableViewCell")
        onlineTableView.dataSource = self
        onlineTableView.delegate = self
        
        navigationController?.isNavigationBarHidden = true

//        networkRealtedData()
        
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var displayCell = UITableViewCell()
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageTableViewCell", for: indexPath) as! ImageTableViewCell
            displayCell = cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SignInTableViewCell", for: indexPath) as! SignInTableViewCell
            cell.signInTextField.layer.cornerRadius = 15
            cell.signInTextField.layer.borderWidth = 1.5
            cell.signInTextField.layer.borderColor = UIColor.white.cgColor
            cell.signInTextField.layer.masksToBounds = true
            cell.signInTextField.textAlignment = .center
            cell.signInTextField.placeholder = "Email"
            //            cell.signTextField.addTarget(self, action: #selector(ViewController.textFieldTapped(_:)), for: .touchUpInside)
            
            displayCell = cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SignInTableViewCell", for: indexPath) as! SignInTableViewCell
            cell.signInTextField.layer.cornerRadius = 15
            cell.signInTextField.layer.borderWidth = 1.5
            cell.signInTextField.layer.borderColor = UIColor.white.cgColor
            cell.signInTextField.layer.masksToBounds = true
            cell.signInTextField.textAlignment = .center
            cell.signInTextField.textAlignment = .center
            cell.signInTextField.placeholder = "Password"
            cell.signInTextField.isSecureTextEntry = true
            //            cell.signTextField.addTarget(self, action: #selector(ViewController.textFieldTapped(_:)), for: .touchUpInside)
            
            displayCell = cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonTableViewCell", for: indexPath) as! ButtonTableViewCell
            cell.signInButton.layer.cornerRadius = 15
            cell.signInButton.layer.masksToBounds = true
            cell.signInButton.addTarget(self, action: #selector(OnlineViewController.buttonTapped(_:)), for: .touchUpInside)
            displayCell = cell
        default:
            print("No condition")
        }
        
        return displayCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row == 0)
        {
            return 200
        }
        switch indexPath.row {
        case 0:
            return 150
        case 3:
            return 80
        default:
            break
        }
        return 50
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        //        guard let tappedIndexPath = tableView.indexPath(for: sender) else { return }
        let cell1 = onlineTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! SignInTableViewCell
        let cell2 = onlineTableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! SignInTableViewCell
        
//        let emailID = cell1.signInTextField.text
//        let password = cell2.signInTextField.text
        networkRealtedData()
//        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DataViewController") as? DataViewController
//        self.navigationController?.pushViewController(vc!, animated: true)
//        validation(emailID: emailID!,password: password!)
        
    }
    
    func validation(emailID:String,password:String)
    {
        
        if (emailID.count > 30)
        {
            validationAlert(alert: "Char limit exceeded", messageAlert: "emailID must not exceed 30 characters")
        }
        else if (emailID.count == 0 || password.count == 0)
        {
            validationAlert(alert: "Empty fields", messageAlert: "Fields cannot be empty")
        }
        else if (!(emailID.contains("@") && emailID.contains(".com")))
        {
            validationAlert(alert: "Invalid details", messageAlert: "Invalid email ID")
        }
        else if (password.count < 6) {
            if(password.count == 0)
            {
                validationAlert(alert: "Empty fields", messageAlert: "Password is required.")
            }
            else
            {
                validationAlert(alert: "Password validation", messageAlert: "The password must be of minimum length 6 characters")
            }
        }
            
        else
        {
//            let storyboard = UIStoryboard(name:"Main", bundle: nil)
//            let nextViewcontroller = storyboard.instantiateViewController(withIdentifier: "DataViewController") as! DataViewController
//            self.present(nextViewcontroller,animated: true, completion: nil)
            
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DataViewController") as? DataViewController
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    
    func validationAlert(alert:String, messageAlert:String)
    {
        let alert = UIAlertController(title: alert, message: messageAlert, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
                
            }}))
        self.present(alert, animated: true, completion: nil)
    }
    
    public func showOfflinePage() -> Void {
        DispatchQueue.main.async {
            //            self.performSegue(
            //                withIdentifier: "NetworkUnavailable",
            //                sender: self
            //            )
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "OfflineViewController") as? OfflineViewController
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    
    func networkRealtedData() -> Void {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(networkStatusChanged(_:)),
            name: .reachabilityChanged,
            object: reachability
        )
        do {
            // Start the network status notifier
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    @objc func networkStatusChanged(_ notification: Notification) {
        // Do something globally here!
        let reachability = notification.object as! Reachability
        if reachability.connection == .wifi
        {
            DispatchQueue.main.async {
                
//                self.tabBarController?.selectedIndex = 1
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DataViewController") as? DataViewController
                self.navigationController?.pushViewController(vc!, animated: true)
            }
            
        }else
        {
            DispatchQueue.main.async {
                self.validationAlert(alert: "No internet connection", messageAlert: "Please turn on Wi-Fi.")
//            self.tabBarController?.selectedIndex = 2
//            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LogoutViewController") as? LogoutViewController
//            self.navigationController?.pushViewController(vc!, animated: true)
            }
        }
        
    }
}

protocol CustomTableViewCellDelegate : class {
    func buttonTapped(_ sender: ButtonTableViewCell)
    func textFieldTapped(_ sender: SignInTableViewCell)
}

