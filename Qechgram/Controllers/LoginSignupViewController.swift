//
//  LoginSignupViewController.swift
//  Qechgram
//
//  Created by Eyoel Wendwosen on 3/25/22.
//

import UIKit
import Parse

class LoginSignupViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let showPasswordButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // overrideDefault color
        
        overrideUserInterfaceStyle = .light
        
        // tap to remove keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
        // show passowrd Icon
        setUpShowPasswordbutton()
        // Do any additional setup after loading the view.
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func onSignup(_ sender: Any) {
        
        let user = PFUser()
        
        user.username = usernameTextField.text
        user.password = passwordTextField.text
        
        user.signUpInBackground { success, error in
            if (success) {
                NotificationCenter.default.post(name: Notification.Name("login"), object: nil)
            } else {
                print("Error couldn't signup: \(error?.localizedDescription ?? "")")
            }
        }
        
    }
    
    @IBAction func onLogin(_ sender: Any) {
    
        
        let username = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        PFUser.logInWithUsername(inBackground: username,
                                 password: password) { success, error in
            if(success != nil) {
                NotificationCenter.default.post(name: Notification.Name("login"), object: nil)
            } else {
                print("Error couldn't login: \(error?.localizedDescription ?? "")")
            }
        }
    }
    
    
    func setUpShowPasswordbutton() {

        passwordTextField.rightViewMode = .unlessEditing
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "eye.slash")
//        config.imagePadding = 4
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(scale: .medium)
        showPasswordButton.configuration = config
        showPasswordButton.frame = CGRect(x: passwordTextField.frame.size.width - 30,
                                          y: passwordTextField.frame.size.height / 2,
                                          width: CGFloat(15),
                                          height: CGFloat(15))
        showPasswordButton.addTarget(self, action: #selector(self.showPasswordVisibilityChanged), for: .touchUpInside)
        passwordTextField.rightView = showPasswordButton
        passwordTextField.rightViewMode = .whileEditing
    }
    

    
    @objc func showPasswordVisibilityChanged(_ sender: Any) {
        let visibilityButton = sender as! UIButton
        visibilityButton.isSelected = !visibilityButton.isSelected
        
        if (visibilityButton.isSelected) {
            passwordTextField.isSecureTextEntry = false
            showPasswordButton.setImage(UIImage(systemName: "eye"), for: .normal)
        } else {
            passwordTextField.isSecureTextEntry = true
            showPasswordButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
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
