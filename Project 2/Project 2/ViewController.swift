//
//  ViewController.swift
//  Project 2
//
//  Created by Jose Blanco on 5/2/22.
//

import UIKit

class ViewController: UIViewController, UNUserNotificationCenterDelegate {
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var score = 0
    var streak = 0
    var highScore = 0
    var correctAnswer = 0
    var questionNumber = 0
    var currentAnimation = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        countries += ["Estonia", "France", "Germany", "Ireland", "Italy", "Monaco", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"]
        print(countries)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(currentScore))
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        button2.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        button3.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        
        askQuestion()
        registerLocal()
        scheduleLocal()
        
        let defaults = UserDefaults.standard
        print("1")
        
        if let savedScore = defaults.object(forKey: "scoreHigh") as? Data {
            print("2")
            let jsonDecoder = JSONDecoder()
            print("3")
            do {
                highScore = try jsonDecoder.decode(Int.self, from: savedScore)
                print("4")
                print(highScore)
            } catch {
                print("5")
                print("Failed to load score.")
            }
        }
        
        if let savedStreak = defaults.object(forKey: "streak") as? Data {
            print("2")
            let jsonDecoder = JSONDecoder()
            print("3")
            do {
                streak = try jsonDecoder.decode(Int.self, from: savedStreak)
                print("4")
                print(highScore)
            } catch {
                print("5")
                print("Failed to load score.")
            }
        }
    }
    
    func askQuestion(action: UIAlertAction! = nil) {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        
        button1.setImage(UIImage(named: countries[0]),
                         for: .normal)
        button2.setImage(UIImage(named: countries[1]),
                         for: .normal)
        button3.setImage(UIImage(named: countries[2]),
                         for: .normal)
        
        title = "\(countries[correctAnswer])"
        questionNumber += 1
        if questionNumber == 11 {
            print("Hi")
            print(highScore)
            if highScore < score {
                highScore = score
                print(highScore)
                let ac = UIAlertController(title: "Congratulations!", message: "This is your new high score!", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
                present(ac, animated: true)
                save()
                score = 0
                questionNumber = 0
                print(score)
            } else {
                let ac = UIAlertController(title: "Congrats!", message: "You scored \(score)/10", preferredStyle: .alert)
            
                ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
            
                present(ac, animated: true)
                score = 0
                questionNumber = 0
            }
        }

    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String = "Blank"
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: [], animations: {
                sender.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
            if sender.tag == self.correctAnswer {
            title = "Correct"
                self.score +=  1
            
        } else {
            title = "Wrong! That's the flag of \(self.countries[sender.tag])!"
            self.score -= 1
            
        }
            let ac = UIAlertController(title: title, message: "Your score is \(self.score)", preferredStyle: .alert)
        
            ac.addAction(UIAlertAction(title: "Continue", style: .default) { [weak self] _ in
                self?.askQuestion()
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: {
                    sender.transform = CGAffineTransform(scaleX: 1, y: 1)})
            })
        
            self.present(ac, animated: true)
        }, completion: { finished in
                
        })
        
    }
   @objc func currentScore(){
        let ac = UIAlertController(title: "Score", message: "Your score is \(score)", preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil))
        
        present(ac, animated: true)
       
   }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        
        if let savedData = try? jsonEncoder.encode(highScore) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "scoreHigh")
        } else {
            print("Failed to save high score.")
        }
    }
    
    func save2() {
        let jsonEncoder = JSONEncoder()
        
        if let savedData = try? jsonEncoder.encode(streak) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "streak")
        } else {
            print("Failed to save streak.")
        }
    }
    
    @objc func registerLocal() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) {
            granted, error in
            if granted {
                print("Yay!")
            } else {
                print("D'oh!")
            }
        }
    }
    
    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
    }
    @objc func scheduleLocal() {
        registerCategories()
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "Time to play!"
        content.body = "It seems you haven't played today. Time to play and create a streak!"
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 0
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print("We got here")
        if let customData = userInfo["customData"] as? String {
            print("Custom data received: \(customData)")
            
            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                //the user swiped to unlock
                print("Default identifier")
                streak += 1
                print("Streak updated")
                save2()
                print("Streak Saved")
                
                let ac = UIAlertController(title: "New Streak", message: "Your new streak is \(streak) days.", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(ac, animated: true)
                
            default:
                break
            }
        }
        
        completionHandler()
    }
}

