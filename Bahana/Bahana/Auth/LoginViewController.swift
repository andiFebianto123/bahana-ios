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
        backgroundImageView.contentMode = .scaleToFill
        languageView.layer.borderWidth = 1
        languageView.layer.borderColor = UIColor.white.cgColor
        languageView.layer.cornerRadius = 20
        languageView.backgroundColor = UIColor.red
        languageView.layer.masksToBounds = true
        languageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToChangeLanguage)))
        languageLabel.textColor = UIColor.white
        languageLabel.text = localize("indonesia")
        emailLabel.font = UIFont.systemFont(ofSize: 10)
        emailLabel.text = localize("email")
        emailField.leftViewMode = .always
        let emailView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
        let emailImageView = UIImageView(frame: CGRect(x: 10, y: 0, width: 20, height: 20))
        //emailImageView.image = UIImage(systemName: "person.and.person")
        //emailImageView.image?.withTintColor(UIColor.black, renderingMode: .alwaysTemplate)
        emailImageView.contentMode = .center
        emailView.addSubview(emailImageView)
        emailField.leftView = emailView
        emailField.placeholder = localize("email")
        passwordLabel.font = UIFont.systemFont(ofSize: 10)
        passwordLabel.text = localize("password")
        passwordField.placeholder = localize("password")
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
        submitButton.setTitle(localize("login"), for: .normal)
        let fpTap = UITapGestureRecognizer(target: self, action: #selector(goToForgotPassword))
        forgotPasswordView.addGestureRecognizer(fpTap)
        forgotPasswordLabel.font = UIFont.italicSystemFont(ofSize: 10)
        forgotPasswordLabel.textColor = UIColor.red
        forgotPasswordLabel.text = localize("forgot_your_password")
        orLabel.font = UIFont.systemFont(ofSize: 10)
        orLabel.text = localize("or")
        registerButton.layer.cornerRadius = 3
        registerButton.layer.masksToBounds = true
        registerButton.backgroundColor = UIColor.black
        registerButton.setTitleColor(UIColor.white, for: .normal)
        registerButton.setTitle(localize("register"), for: .normal)
        versionLabel.font = UIFont.systemFont(ofSize: 10)
        versionLabel.text = String.localizedStringWithFormat(localize("app_version"), "1")
        
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
        alert.addAction(UIAlertAction(title: localize("ok"), style: .default, handler: nil))
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
    
    @objc func goToChangeLanguage() {
        let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let changeLanguageViewController : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "ChangeLanguage") as UIViewController
        self.present(changeLanguageViewController, animated: true, completion: nil)
    }
}

extension LoginViewController: LoginDelegate {
    func isLoginSuccess(_ isSuccess: Bool, _ message: String) {
        if isSuccess {
            let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let homeViewController : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "GeneralTabBar") as UIViewController
            self.present(homeViewController, animated: true, completion: nil)
        } else {
            showAlert(title: localize("information"), message: message)
        }
    }
}
