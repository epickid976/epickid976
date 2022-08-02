//
//  TableTableViewController.swift
//  Extension
//
//  Created by Jose Blanco on 6/24/22.
//

import UIKit

class TableTableViewController: UITableViewController {
    var allSavedScripts = [Scripts]()
    
    public var delegate: PopupVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        //navigationItem.leftBarButtonItem = UIBarButtonItem(title: "New Script", style: .plain, target: self, action: #selector(goToViewController))
        
        tableView.reloadData()
        title = "Saved Scripts"
        
        let defaults = UserDefaults.standard
        
        if let savedScripts = defaults.object(forKey: "scripts") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                allSavedScripts = try jsonDecoder.decode([Scripts].self, from: savedScripts)
            } catch {
                print("Failed to load scripts.")
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allSavedScripts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath:
            IndexPath)-> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Script", for:
        indexPath)
        cell.textLabel?.text = allSavedScripts[indexPath.row].title
        cell.detailTextLabel?.text = allSavedScripts[indexPath.row].url
        cell.textLabel?.isUserInteractionEnabled = true
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            dismiss(animated: true, completion: nil)
            delegate?.popupDidDisappear(indexPath: indexPath.row)
        }
    
    @objc func done() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? ActionViewController{
            vc.save()
            dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func goToViewController(){
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let item = UIContextualAction(style: .normal, title: "Rename") {  (contextualAction, view, boolValue) in
                let ac = UIAlertController(title: "Rename Script", message: "Type the new name in the text box below.", preferredStyle: .alert)
                ac.addTextField()
                ac.addAction(UIAlertAction(title: "OK", style: .default) {
                    [weak self] _ in
                    guard let newName = ac.textFields?[0].text else { return }
                    self?.allSavedScripts[indexPath.row].title = newName
                    self?.tableView.reloadData()
                    if let vc = self?.storyboard?.instantiateViewController(withIdentifier: "Detail") as? ActionViewController{
                        vc.save()
                    }
                })
                self.present(ac, animated: true)
            }
        
        let item2 = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
            self.allSavedScripts.remove(at: indexPath.row)
            self.tableView.reloadData()
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "Detail") as? ActionViewController{
                vc.save()
            }
            
            
        }

            let swipeActions = UISwipeActionsConfiguration(actions: [item2, item])
        
            return swipeActions
        }
}
