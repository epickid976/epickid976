//
//  ActionViewController.swift
//  Extension
//
//  Created by Jose Blanco on 6/22/22.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

class ActionViewController: UIViewController, PopupVCDelegate {
    @IBOutlet var script: UITextView!
    
    var pageTitle = ""
    var pageURL = ""
    var allSavedScripts = [Scripts]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Scripts", style: .plain, target: self, action: #selector(savedScripts))
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        let defaults = UserDefaults.standard
        
        if let savedScripts = defaults.object(forKey: "scripts") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                allSavedScripts = try jsonDecoder.decode([Scripts].self, from: savedScripts)
            } catch {
                print("Failed to load scripts.")
            }
        }

        
        
        
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            if let itemProvider = inputItem.attachments?.first {
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [weak self] (dict, error) in
                    guard let itemDictionary = dict as? NSDictionary else { return }
                    guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
                    //print(javaScriptValues)
                    
                    self?.pageTitle = javaScriptValues["title"] as? String ?? ""
                    self?.pageURL = javaScriptValues["URL"] as? String ?? ""
                    
                    DispatchQueue.main.async {
                        self?.title = self?.pageTitle
                        if let index = self?.allSavedScripts.lastIndex(where: { Scripts in Scripts.url == self?.pageURL}) {
                            self?.script.text = self?.allSavedScripts[index].script
                        }
                    }
                    self?.save()
                }
            }
        }
    }

    @IBAction func done() {
        let item = NSExtensionItem()
        let argument: NSDictionary = ["customJavaScript": script.text]
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
        item.attachments = [customJavaScript]
        extensionContext?.completeRequest(returningItems: [item])
        
        let site = Scripts(title: pageTitle, url: pageURL, script: script.text)
        allSavedScripts.append(site)
        save()
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, to: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            script.contentInset = .zero
        } else {
            script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        script.scrollIndicatorInsets = script.contentInset
        
        let selectedRange = script.selectedRange
        script.scrollRangeToVisible(selectedRange)
    }
    
    @objc func savedScripts(){
        let scripts = ["alert(document.title);", "alert(document.URL);"]
        let ac = UIAlertController(title: "Quick Scripts", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Alert Title Script", style: .default) {
            [weak self] _ in
            self?.script.text += scripts[0]
    })
        ac.addAction(UIAlertAction(title: "Alert URL Script", style: .default) {
            [weak self] _ in
            self?.script.text += scripts[1]
    })
        ac.addAction(UIAlertAction(title: "View All Saved Scripts", style: .default) {
            [weak self] _ in
            if let vc = self?.storyboard?.instantiateViewController(withIdentifier: "Table") as? TableTableViewController{
                vc.allSavedScripts = self?.allSavedScripts ?? [Scripts(title: "", url: "", script: "")]
                vc.modalPresentationStyle = .popover
                vc.delegate = self
                let newNavigationController = UINavigationController(rootViewController: vc)
                self?.present(newNavigationController, animated: true)
                //self?.navigationController?.present(vc, animated: true)
            }
    })
        ac.addAction(UIAlertAction(title: "Cancel", style: .default))
        ac.popoverPresentationController?.barButtonItem = navigationItem.leftBarButtonItem
        present(ac, animated: true)
}
    
    
    func save() {
        let jsonEncoder = JSONEncoder()
        
        if let savedData = try? jsonEncoder.encode(allSavedScripts) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "scripts")
            print("Done Saving")
        } else {
            print("Failed to save scripts.")
        }
    }
    
    func popupDidDisappear(indexPath: Int){
        script.text += allSavedScripts[indexPath].script
    }

}
