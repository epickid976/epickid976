//
//  DetailViewController.swift
//  Milestone 10-12
//
//  Created by Jose Blanco on 6/5/22.
//z

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    
    var selectedImage: UIImage!
    var detailVCTitle: String?
    var indexPathNumber: Image!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = detailVCTitle!
        navigationItem.largeTitleDisplayMode = .never
        
        let share = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        let caption = UIBarButtonItem(title: "Caption", style: .plain, target: self, action: #selector(caption))
        
        navigationItem.rightBarButtonItems = [share, caption]
        
        if let imageToLoad = selectedImage {
            imageView.image = imageToLoad
        }
    }
    
    @objc func caption() {
        let ac = UIAlertController(title: "Change Caption?", message: "Current Caption: \(indexPathNumber.caption)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Change Caption", style: .default) {
            [weak self] _ in
            let ac = UIAlertController(title: "New Caption", message: "Type new Caption", preferredStyle: .alert)
            ac.addTextField()
            ac.addAction(UIAlertAction(title: "Done", style: .default) {
                [weak self] _ in
                guard let newCaption = ac.textFields?[0].text else { return }
                self?.indexPathNumber.caption = newCaption
                self?.save()
            })
            self?.present(ac, animated: true)
        
            })
        present(ac, animated: true)
        }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    @objc func shareTapped() {
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8)
        else{
            print("No image found")
            return
        }
        let vc = UIActivityViewController(activityItems: [image, "\(selectedImage!)" ], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
}
    
    func save() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "View") as? ViewController{
        let jsonEncoder = JSONEncoder()
        
            if let savedData = try? jsonEncoder.encode(vc.photos) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "photos")
        } else {
            print("Failed to save people.")
        }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
