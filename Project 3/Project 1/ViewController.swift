//
//  ViewController.swift
//  Project 1
//
//  Created by Jose Blanco on 4/29/22.
//

import UIKit

class ViewController: UITableViewController {
    var pictures = [String]()
    var numbersShown = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(recommendIt))
        
        performSelector(inBackground: #selector(loadImages), with: nil)
        
        

        let defaults = UserDefaults.standard
        
        if let savedNumbers = defaults.object(forKey: "timesShown") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                numbersShown = try jsonDecoder.decode([Int].self, from: savedNumbers)
            } catch {
                print("Failed to load people.")
            }
        }

    }
    
    @objc func loadImages() {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items{
            if item.hasPrefix("nssl"){
                //this is a picture to load!
                pictures.append(item)
            }
        }
        for _ in 0..<pictures.count {
            numbersShown.append(0)
        }
        pictures.sort()
        print(pictures)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection
        section: Int) -> Int {
        return pictures.count
    
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath:
            IndexPath)-> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for:
        indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController{
            numbersShown[indexPath.row] += 1
            print(numbersShown[indexPath.row])
            print(numbersShown)
            save()
            vc.selectedImage = pictures[indexPath.row]
            vc.detailVCTitle = "Picture \(indexPath.row + 1) of \(pictures.count)"
            navigationController?.pushViewController(vc, animated: true)
            
        }
        
    }
    @objc func recommendIt() {
        let vc = UIActivityViewController(activityItems: ["I have been using the Storm Viewer app, please download it on the App Store. https://www.link.com",], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        
        if let savedData = try? jsonEncoder.encode(numbersShown) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "timesShown")
        } else {
            print("Failed to save number.")
        }
    }
}




