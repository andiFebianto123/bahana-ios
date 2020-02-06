//
//  LoginViewController.swift
//  Bahana
//
//  Created by Christian Chandra on /2001/30.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var languageView: UIView!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var orLabel: UILabel!
    @IBOutlet weak var forgotPasswordView: UIView!
    @IBOutlet weak var forgotPasswordLabel: UILabel!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var versionLabel: UILabel!
    
    var presenter: LoginPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupToHideKeyboardOnTapOnView()
        
        backgroundImageView.image = UIImage(named: "bg")
        languageView.layer.borderWidth = 1
        languageView.layer.borderColor = UIColor.white.cgColor
        languageView.layer.cornerRadius = 20
        languageView.backgroundColor = UIColor.red
        languageView.layer.masksToBounds = true
        languageLabel.textColor = UIColor.white
        languageLabel.text = "ID"
        emailLabel.font = UIFont.systemFont(ofSize: 10)
        emailLabel.text = "Email"
        emailField.leftViewMode = .always
        let emailView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
        let emailImageView = UIImageView(frame: CGRect(x: 10, y: 0, width: 20, height: 20))
        //emailImageView.image = UIImage(systemName: "person.and.person")
        //emailImageView.image?.withTintColor(UIColor.black, renderingMode: .alwaysTemplate)
        emailImageView.contentMode = .center
        emailView.addSubview(emailImageView)
        emailField.leftView = emailView
        emailField.placeholder = "Email"
        passwordLabel.font = UIFont.systemFont(ofSize: 10)
        passwordLabel.text = "Sandi"
        passwordField.placeholder = "Sandi"
        passwordField.isSecureTextEntry = true
        let passwordView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
        let passwordImageView = UIImageView(frame: CGRect(x: 10, y: 0, width: 20, height: 20))
        //passwordImageView.image = UIImage(systemName: "person.and.person")
        passwordImageView.contentMode = .center
        passwordView.addSubview(passwordImageView)
        passwordField.leftViewMode = .always
        passwordField.leftView = passwordView
        submitButton.layer.cornerRadius = 3
        submitButton.layer.masksToBounds = true
        submitButton.backgroundColor = UIColor.red
        submitButton.setTitleColor(UIColor.white, for: .normal)
        submitButton.setTitle("MASUK", for: .normal)
        let fpTap = UITapGestureRecognizer(target: self, action: #selector(goToForgotPassword))
        forgotPasswordView.addGestureRecognizer(fpTap)
        forgotPasswordLabel.font = UIFont.italicSystemFont(ofSize: 10)
        forgotPasswordLabel.textColor = UIColor.red
        forgotPasswordLabel.text = "LUPA SANDI ANDA?"
        orLabel.font = UIFont.systemFont(ofSize: 10)
        orLabel.text = "Atau"
        registerButton.layer.cornerRadius = 3
        registerButton.layer.masksToBounds = true
        registerButton.backgroundColor = UIColor.black
        registerButton.setTitleColor(UIColor.white, for: .normal)
        registerButton.setTitle("DAFTAR", for: .normal)
        versionLabel.font = UIFont.systemFont(ofSize: 10)
        versionLabel.text = "VERSI APP - 1.0"
        
        presenter = LoginPresenter(delegate: self)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        presenter.submit(emailField.text!, passwordField.text!)
    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "showRegister", sender: self)
    }
    
    @objc func goToForgotPassword() {
        performSegue(withIdentifier: "showForgotPassword", sender: self)
    }
}

extension LoginViewController: LoginDelegate {
    func isLoginSuccess(_ isSuccess: Bool, _ message: String) {
        if isSuccess {
            let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let homeViewController : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "GeneralTabBar") as UIViewController
            self.present(homeViewController, animated: true, completion: nil)
        } else {
            showAlert(title: "Informasi", message: message)
        }
    }
}
