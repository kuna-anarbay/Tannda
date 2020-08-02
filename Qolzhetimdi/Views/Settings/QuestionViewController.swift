//
//  QuestionViewController.swift
//  Qolzhetimdi
//
//  Created by Kuanysh Anarbay on 5/8/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import UIKit

class QuestionViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var textView: UITextView!
    var newQuestion = Question()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.textColor = UIColor.lightGray
        textView.text = "Write your question here"
        textView.delegate = self
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    @IBAction func sendPressed(_ sender: Any) {
        let newQuestion = Question()
        newQuestion.body = textView.text!
        newQuestion.create() { (arg0) in
            if arg0.0 == .success {
                // notify user
            } else {
                // notify user
            }
        }
    }
    
}
