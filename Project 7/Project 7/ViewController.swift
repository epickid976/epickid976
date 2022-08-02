//
//  ViewController.swift
//  Project 7
//
//  Created by Jose Blanco on 5/19/22.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    var petitionsFilter = [Petition]()
    var currentFilter = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "White House petitions"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(credits))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(askFilter))
        
        let urlString: String
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }
        
        showError()
    }
    
    func showError() {
        let ac = UIAlertController(title: "Loading Error", message: "There was a problem loading the feed. Please check your network connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            filter()
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitionsFilter.count
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = petitionsFilter[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitionsFilter[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func credits() {
        let ac = UIAlertController(title: "Credits", message: "This information comes from the 'We The People API of the White House'", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    @objc func askFilter() {
        let ac = UIAlertController(title: "Filter", message: "Filter the petitions on the following keyword (leave empty to reset filtering)", preferredStyle: .alert)
        ac.addTextField()

        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "OK", style: .default) {
            [weak self, weak ac] _ in
            self?.currentFilter = ac?.textFields?[0].text ?? ""
            self?.filter()
            self?.tableView.reloadData()
        })
        
        present(ac, animated: true)
    }
    func filter(){
        if currentFilter == "" {
            petitionsFilter = petitions
            navigationItem.leftBarButtonItem?.title = "Filter"
            return
            }
        
        navigationItem.leftBarButtonItem?.title = "Current Filter: \(currentFilter)"
        
        petitionsFilter = petitions.filter() {
            petition in
            
            if let _ = petition.title.range(of: currentFilter, options: .caseInsensitive){
                return true
            }
            if let _ = petition.body.range(of: currentFilter, options: .caseInsensitive){
                return true
            }
            return false
        }
        }
}
