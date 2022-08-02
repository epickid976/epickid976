//
//  ViewController.swift
//  Project5
//
//  Created by Jose Blanco on 5/13/22.
//

import UIKit

class ViewController: UITableViewController {
    var allWords = [String]()
    var usedWords = [String]()
    var currentWord = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startGame))
        
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt"){
            if let startWords = try? String(contentsOf: startWordsURL){
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
        
        let defaults = UserDefaults.standard
        
        if let savedWords = defaults.object(forKey: "current") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                currentWord = try jsonDecoder.decode(String.self, from: savedWords)
            } catch {
                print("Failed to load people.")
            }
        }
        
        if let savedUsed = defaults.object(forKey: "used") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                usedWords = try jsonDecoder.decode([String].self, from: savedUsed)
            } catch {
                print("Failed to load people.")
            }
        }
        
        title = currentWord

    }

    @objc func startGame() {
        currentWord = allWords.randomElement() ?? "Silkworm"
        save()
        title = currentWord
        usedWords.removeAll(keepingCapacity: true)
        save2()
        tableView.reloadData()
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    
    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default){
            [weak self, weak ac] _ in
            guard let answer = ac?.textFields?[0].text else {return}
            self?.submit(answer)
        }
            
        ac.addAction(submitAction)
        present(ac, animated: true)
        }
    func submit(_ answer: String){
        let lowerAnswer = answer.lowercased()
        
        let errorTitle: String
        let errorMessage: String
        
        //Determines if a word is eligible
        if length(word: lowerAnswer){
            if isPossible(word: lowerAnswer) {
                if isOriginal(word: lowerAnswer){
                    if isReal(word: lowerAnswer){
                    usedWords.insert(lowerAnswer, at: 0)
                    save2()
                        let indexPath = IndexPath(row:0, section: 0)
                        tableView.insertRows(at: [indexPath], with: .automatic)
                    
                        return
                    } else {
                    
                        errorTitle = "Word not recognized"
                        errorMessage = "Word does not exist in the English Language."
                    }
                } else {
                    errorTitle = "Word already used"
                    errorMessage = "Please use a word not already used. Each word used must be unique. "
                }
            } else {
                errorTitle = "Word not possible"
                errorMessage = "You can't spell that word from \(title!.lowercased())."
            }
        } else {
            errorTitle = "Length or Word Incorrect"
            errorMessage = "Length cannot be shorter than three characters and word cannot be the same as start word."
        }
    
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        }
    
    func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else { return false }
        
        for letter in word {
            if let position = tempWord.firstIndex(of: letter){
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        return true
    }
    
    func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    
    func length(word: String) -> Bool {
        if word.count < 3 || word == title!.lowercased() {
            return false
        } else {
            return true
        }
        }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        
        if let savedData = try? jsonEncoder.encode(currentWord) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "current")
        } else {
            print("Failed to save words.")
        }
    }
    
    func save2() {
        let jsonEncoder = JSONEncoder()
        
        if let savedData2 = try? jsonEncoder.encode(usedWords) {
            let defaults = UserDefaults.standard
            defaults.set(savedData2, forKey: "used")
        } else {
            print("Failed to save used words.")
        }
    }
}






