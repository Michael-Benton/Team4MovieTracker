//
//  LoginViewController.swift
//  Team4ProjectApp
//
//  Created by Logan Harvell on 11/22/17.
//  Copyright © 2017 Logan Harvell. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

  private let appDelegate = UIApplication.shared.delegate as! AppDelegate
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var emailTF: UITextField!
  @IBOutlet weak var passwordTF: UITextField!
  @IBOutlet weak var submitButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.backgroundColor = UIColor.darkGray
    
//    titleLabel.layer.addBorder(edge: .bottom, color: UIColor.black, thickness: 2)
    titleLabel.layer.borderWidth = 2
    titleLabel.layer.borderColor = UIColor.black.cgColor
    
    submitButton.layer.backgroundColor = UIColor.lightGray.cgColor
    submitButton.layer.borderWidth = 1
    submitButton.layer.borderColor = UIColor.black.cgColor
    submitButton.layer.cornerRadius = 15

  }
  
  override func viewDidLayoutSubviews() {
    titleLabel.layer.frame = titleLabel.frame
  }
  
  @IBAction func submitButton(_ sender: UIButton) {
    appDelegate.user = AppUser.initUserFromWebApp(email: emailTF.text!,
                                                  password: passwordTF.text!)
    if appDelegate.user != nil {
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      let nextViewController = storyboard.instantiateViewController(withIdentifier: "WatchlistViewController")
      self.present(nextViewController, animated: true, completion: nil)
    }
    else {
      
      let alert = UIAlertController(
        title: "Login Failed",
        message: "Please try again.",
        preferredStyle: UIAlertControllerStyle.alert)
      
      let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
        var beginning = self.emailTF.beginningOfDocument
        var end = self.emailTF.endOfDocument
        self.emailTF.selectedTextRange = self.emailTF.textRange(from: beginning,
                                                                to: end)
        beginning = self.passwordTF.beginningOfDocument
        end = self.passwordTF.endOfDocument
        self.passwordTF.selectedTextRange = self.passwordTF.textRange(from: beginning,
                                                                      to: end)
      }
      
      alert.addAction(OKAction)
      present(alert, animated: true, completion: nil)

      return
    }
  }
}

