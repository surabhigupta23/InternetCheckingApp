//
//  OfflineViewController.swift
//  MultipleTabBar
//
//  Created by Surabhi Gupta on 4/17/19.
//  Copyright © 2019 Surabhi Gupta. All rights reserved.
//

import UIKit
import CoreData

class OfflineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var offlineTableView: UITableView!
    
    var jsonArray1 = [User]()
    var jsonArray = [AnyObject]()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        offlineTableView.register(UINib(nibName: "DataTableViewCell", bundle: nil), forCellReuseIdentifier: "DataTableViewCell")
        offlineTableView.register(UINib(nibName: "LoadMoreTableViewCell", bundle: nil), forCellReuseIdentifier: "LoadMoreTableViewCell")
        
        offlineTableView.delegate = self
        offlineTableView.dataSource = self
        offlineTableView.tableFooterView = UIView() // to show blank screen while loading the data
        navigationController?.isNavigationBarHidden = true
        
        fetchData()
        //to sort the data fetched
        jsonArray1.sort {
            $0.id < $1.id
        }
//        offlineTableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
           return jsonArray1.count
     
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
           let  cell = tableView.dequeueReusableCell(withIdentifier: "DataTableViewCell", for: indexPath) as! DataTableViewCell
            cell.backgroundColor = UIColor.orange
            let userObj = jsonArray1[indexPath.row]
            let id = userObj.id
            print("user ID and title ", userObj.id, userObj.title)
            cell.idLabel?.text = String(id)
            let userID = userObj.userId
            cell.userIdLabel?.text = String(userID)
            
            cell.titleLabel?.text = userObj.title

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
    func fetchData()  {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        //request.predicate = NSPredicate(format: "age = %@", "12")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let userID = data.value(forKey: "user_id") as! Int
                let id = data.value(forKey: "id") as! Int
                let title = data.value(forKey: "title") as! String
               let body = data.value(forKey: "body") as! String
                let userObj = User(userId:userID, id:id, title:title, body:body)
                jsonArray1.append(userObj)
//                print("******* jsonArray1 ******* ",jsonArray1)
                
            }
            
        } catch {
            
            print("Failed")
        }
    }
}
