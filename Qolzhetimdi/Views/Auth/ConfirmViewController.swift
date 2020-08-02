//
//  ConfirmViewController.swift
//  Qolzhetimdi
//
//  Created by Kuanysh Anarbay on 5/10/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import UIKit
import Firebase


class ConfirmViewController: UIViewController {

    @IBOutlet weak var codeField: UITextField!
    var phoneNumber: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func donePressed(_ sender: Any) {
        if let verificationCode = codeField.text,
            let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") {
            
            let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: verificationCode)
            
            
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    print(error)
                    return
                }
                print(authResult)
                self.performSegue(withIdentifier: "showMain", sender: nil)
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
