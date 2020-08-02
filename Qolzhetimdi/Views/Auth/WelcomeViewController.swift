//
//  WelcomeViewController.swift
//  Qolzhetimdi
//
//  Created by Kuanysh Anarbay on 5/10/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func signUpPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "showSignUp", sender: nil)
    }
    
    
    @IBAction func loginPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "showLogin", sender: nil)
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
