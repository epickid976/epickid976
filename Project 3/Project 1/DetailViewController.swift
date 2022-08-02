//
//  DetailViewController.swift
//  Project 1
//
//  Created by Jose Blanco on 4/30/22.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var selectedImage: String?
    var detailVCTitle: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = detailVCTitle!
        navigationItem.largeTitleDisplayMode = .never
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
        }
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
        guard let imageChosen = imageView.image
        else{
            print("No image found")
            return
        }
        
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: imageChosen.size.width, height: imageChosen.size.width))
        
        let imageCanvas = renderer.image { ctx in
            //awesome drawing code
            imageChosen.draw(at: CGPoint(x: 5, y: 5))
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .left
            
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 20),
                .paragraphStyle: paragraphStyle
            ]
            
            let string = "From Storm Viewer"
            
            let attributedString = NSAttributedString(string: string, attributes: attrs)
            attributedString.draw(with: CGRect(x: 0, y: 0, width: 448, height: 448), options: .usesLineFragmentOrigin, context: nil)
            
            
        }
        
        
        let vc = UIActivityViewController(activityItems: [imageCanvas, "\(selectedImage!)" ], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
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


