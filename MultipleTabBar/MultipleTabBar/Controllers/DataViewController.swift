//
//  DataViewController.swift
//  MultipleTabBar
//
//  Created by Surabhi Gupta on 4/17/19.
//  Copyright © 2019 Surabhi Gupta. All rights reserved.
//

import UIKit
import Alamofire
import CoreData
import Reachability

class DataViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var dataTableView: UITableView!
    
    var jsonArray = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataTableView.register(UINib(nibName: "DataTableViewCell", bundle: nil), forCellReuseIdentifier: "DataTableViewCell")
        dataTableView.register(UINib(nibName: "LoadMoreTableViewCell", bundle: nil), forCellReuseIdentifier: "LoadMoreTableViewCell")
        
        dataTableView.delegate = self
        dataTableView.dataSource = self
        dataTableView.tableFooterView = UIView() // to show blank screen while loading the data
        navigationController?.isNavigationBarHidden = true
        jsonParsing()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (section == 0)
        {
            return jsonArray.count
        }
        else
        {
            return 1
        }
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell1 = UITableViewCell()
        
        if (indexPath.section == 1)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LoadMoreTableViewCell", for: indexPath) as! LoadMoreTableViewCell
            cell1 = cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "DataTableViewCell", for: indexPath) as! DataTableViewCell
//            let userObj = User(userId:"userId", id:"id",title:"title",body:"body")
            let id = jsonArray[indexPath.row]["id"] as! Int
            cell.idLabel?.text = String(id)
            let userID = jsonArray[indexPath.row]["userId"] as! Int
            cell.userIdLabel?.text = String(userID)
            cell.titleLabel?.text = jsonArray[indexPath.row]["title"] as? String
           
            cell1 = cell
        }
        return cell1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func jsonParsing ()
    {
        
        let url = "https://jsonplaceholder.typicode.com/posts"
        Alamofire.request(url).responseJSON { response in
            if let result = response.result.value {
                self.jsonArray = (result as! NSArray) as [AnyObject]
                
                //              print("*********",self.jsonArray)
//                                self.saveData()
                self.dataTableView.reloadData()
            }
        }
        
    }
    //save data in Core data
    func saveData()
    {
        var userID:Int
        var id:Int
        var title:String
        var body:String
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Users", in: context)

        for user in jsonArray {
            userID = user["userId"] as! Int
            id = user["id"] as! Int
            title = user["title"] as! String
            body = user["body"] as! String
            let userObj = User(userId:userID, id:id, title:title, body:body)
            let newUser = NSManagedObject(entity: entity!, insertInto: context)
            newUser.setValue(userObj.userId, forKey: "user_id")
            newUser.setValue(userObj.id, forKey: "id")
            newUser.setValue(userObj.title, forKey: "title")
            newUser.setValue(userObj.body, forKey: "body")
            
        }
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
        
    }
    
    private func showOfflinePage() -> Void {
        DispatchQueue.main.async {
//            self.performSegue(
//                withIdentifier: "NetworkUnavailable",
//                sender: self
//            )
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "OfflineViewController") as? OfflineViewController
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }

}
