//
//  ViewController.swift
//  Project 18
//
//  Created by Jose Blanco on 6/19/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Print function can print multiple things at once and stays in the code when it is shipped, although invisible
        //IE the user doesn't see the print messages
//        print("I'm inside the viewDidLoad() method.")
//        print(1,2,3,4,5)
//
//        print(1,2,3,4,5, separator: "-")
//
//        print("Some message", terminator: "")
//
            //assert crashes if the argument isn't true. It also prints the condition.
//        assert(1 == 1, "Math failure!")
//        assert(1 == 2, "Math failure!")
//
//        assert(myReallySlowMethod() == true, "The slow method returned false, which is a bad thing.")
        
        for i in 1...100 {
            print("Got number \(i)")
        }
        
    }


}

