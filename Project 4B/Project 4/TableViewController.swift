//
//  TableViewController.swift
//  Project 4
//
//  Created by Jose Blanco on 5/12/22.
//

import UIKit

class WebsiteList: UITableViewController {
var vc = ViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Websites"
        navigationController?.navigationBar.prefersLargeTitles = true



        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }

    // MARK: - Table view data source

    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return vc.websites.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath:
            IndexPath)-> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "websiteName", for:
        indexPath)
        cell.textLabel?.text = vc.websites[indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let webViewController = storyboard?.instantiateViewController(withIdentifier: "webView") as? ViewController{
            webViewController.websiteToLoad = vc.websites[indexPath.row]
            navigationController?.pushViewController(webViewController, animated: true)
            
        }
    }
}
