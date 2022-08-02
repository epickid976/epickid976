//
//  ViewController.swift
//  Milestone 10-12
//
//  Created by Jose Blanco on 6/4/22.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    var photos = [Image]()
    var photoNumber: Image!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(pickerType))
        
        DispatchQueue.global(qos: .background).async {
        let defaults = UserDefaults.standard
        
        if let savedPeople = defaults.object(forKey: "photos") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                self.photos = try jsonDecoder.decode([Image].self, from: savedPeople)
            } catch {
                print("Failed to load people.")
            }
        }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    @objc func addNewPhoto(pickerType: Bool) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        if pickerType {
            picker.sourceType = .camera
        }
        present(picker, animated: true)
        
    }
    
    @objc func pickerType() {
        let ac = UIAlertController(title: "Source Type", message: "Take a picture or upload a picture?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Camera", style: .default) { [weak self] _ in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self?.addNewPhoto(pickerType: true)
            } else {
                let errorAlert = UIAlertController(title: "Error: No Camera Found", message: nil, preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "Photo", style: .default) { [weak self] _ in
                self?.addNewPhoto(pickerType: false)
            })
                errorAlert.addAction(UIAlertAction(title: "Cancel", style: .default))
                self?.present(errorAlert, animated: true)
            }
            
        })
        ac.addAction(UIAlertAction(title: "Photo", style: .default) { [weak self] _ in
            self?.addNewPhoto(pickerType: false)
        })
        
        present(ac, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
            guard let image = info[.editedImage] as? UIImage else { return }
        
        
        let imageName = UUID().uuidString
        
            let imagePath = self.getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let photo = Image(image: imageName, caption: "No Caption")
            self.photos.append(photo)
            self.save()
        
        tableView.reloadData()
        
        dismiss(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        let photo = photos[indexPath.row]
        let path = getDocumentsDirectory().appendingPathComponent(photo.image)
        
        cell.textLabel?.text = photo.caption
        cell.imageView?.image = UIImage(contentsOfFile: path.path)
        
        
        cell.imageView!.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView!.layer.borderWidth = 2
        save()
                return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController{
            let photo = photos[indexPath.row]
            let path = getDocumentsDirectory().appendingPathComponent(photo.image)
            vc.selectedImage = UIImage(contentsOfFile: path.path)
            vc.detailVCTitle = "Picture \(indexPath.row + 1) of \(photos.count)"
            navigationController?.pushViewController(vc, animated: true)
            
            vc.indexPathNumber = photos[indexPath.row]
        }
    }
    @objc func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        
        if let savedData = try? jsonEncoder.encode(photos) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "photos")
        } else {
            print("Failed to save people.")
        }
    }
    
    
}

