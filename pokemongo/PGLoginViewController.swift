//
//  PGLoginViewController.swift
//  pokemongo
//
//  Created by Lawrence Tan on 19/7/16.
//  Copyright © 2016 2359 Media Pte Ltd. All rights reserved.
//

import UIKit
import FirebaseAuth

class PGLoginViewController: UIViewController {
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLogin: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        txtEmail.text = "@pokemongo.com"
        txtPassword.text = "poke2359"
        btnLogin.layer.cornerRadius = 5.0
        btnLogin.clipsToBounds = true
    }

    @IBAction func onLogin(sender: AnyObject) {
        if let email = txtEmail.text, let password = txtPassword.text {
            LoadingOverlay.shared.showOverlay(view)
            FIRAuth.auth()?.signInWithEmail(email, password: password, completion: { (user, error) in
                if (user != nil) {
                    let trainerName = user?.email?.componentsSeparatedByString("@").first
                    let trainerId = trainerName?.stringByReplacingOccurrencesOfString("trainer", withString: "") ?? ""
                    PGClient.getTrainer(trainerId, completionHandler: { (hasResult, error) -> Void in
                        
                    })                    
                    let destionationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("PGMenuViewController") as! PGMenuViewController
                    self.presentViewController(destionationVC, animated: true, completion: nil)
                    LoadingOverlay.shared.hideOverlayView()
                }else{
                    LoadingOverlay.shared.hideOverlayView()
                    let alert = UIAlertView(title: "Login Failed", message: "Please try again.", delegate: self, cancelButtonTitle: "Ok")
                    alert.show()
                }
            })
        }
    }

}
