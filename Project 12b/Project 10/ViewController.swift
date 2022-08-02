//
//  ViewController.swift
//  Project 10
//
//  Created by Jose Blanco on 5/27/22.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var people = [Person]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(pickerType))
        
        let defaults = UserDefaults.standard
        
        if let savedPeople = defaults.object(forKey: "people") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                people = try jsonDecoder.decode([Person].self, from: savedPeople)
            } catch {
                print("Failed to load people.")
            }
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
            fatalError("Unable to dequeue PersonCell.")
        }
        
        let person = people[indexPath.item]
        
        cell.name.text = person.name
        
        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        
        return cell
    }
    
    @objc func addNewPerson(pickerType: Bool) {
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
                self?.addNewPerson(pickerType: true)
            } else {
                let errorAlert = UIAlertController(title: "Error: No Camera Found", message: nil, preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "Photo", style: .default) { [weak self] _ in
                self?.addNewPerson(pickerType: false)
            })
                errorAlert.addAction(UIAlertAction(title: "Cancel", style: .default))
                self?.present(errorAlert, animated: true)
            }
            
        })
        ac.addAction(UIAlertAction(title: "Photo", style: .default) { [weak self] _ in
            self?.addNewPerson(pickerType: false)
        })
        
        present(ac, animated: true)
    }
                     
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else { return }
        
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let person = Person(name: "Unknown", image: imageName)
        people.append(person)
        save()
        collectionView.reloadData()
        
        dismiss(animated: true)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]
        
        let ac1 = UIAlertController(title: "Rename or Delete", message: "Do you want to rename this person or delete it?", preferredStyle: .alert)
        let ac = UIAlertController(title: "Rename person", message: nil, preferredStyle: .alert)
        
        ac.addTextField()
        
        ac1.addAction(UIAlertAction(title: "Rename", style: .default, handler: renamePerson))
        ac1.addAction(UIAlertAction(title: "Delete", style: .default, handler: deletePerson))
        ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] _ in
            guard let newName = ac?.textFields?[0].text else { return }
            person.name = newName
            self?.save()
            self?.collectionView.reloadData()
        })
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(ac1, animated: true)
        
        func renamePerson(alert: UIAlertAction) {
            present(ac, animated: true)
        }
        
        func deletePerson(alert: UIAlertAction) {
            people.remove(at: indexPath.item)
            collectionView.reloadData()
        }
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        
        if let savedData = try? jsonEncoder.encode(people) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "people")
        } else {
            print("Failed to save people.")
        }
    }
    
}

