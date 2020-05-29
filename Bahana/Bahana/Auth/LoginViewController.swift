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
    
    var loadingView = UIView()
    
    var presenter: LoginPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupToHideKeyboardOnTapOnView()
        
        setViewText()
        
        // Set loading view
        loadingView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingView)
        view.bringSubviewToFront(loadingView)
        
        let spinner = UIActivityIndicatorView()
        spinner.color = .black
        spinner.startAnimating()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        loadingView.addSubview(spinner)
        
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            spinner.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor)
        ])
        
        showLoading(false)
        
        backgroundImageView.image = UIImage(named: "bg")
        backgroundImageView.contentMode = .scaleToFill
        languageView.layer.borderWidth = 1
        languageView.layer.borderColor = UIColor.white.cgColor
        languageView.layer.cornerRadius = 20
        languageView.backgroundColor = UIColor.red
        languageView.layer.masksToBounds = true
        languageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToChangeLanguage)))
        languageLabel.textColor = UIColor.white
        emailLabel.font = UIFont.systemFont(ofSize: 12)
        emailField.layer.borderWidth = 1
        emailField.layer.borderColor = UIColor.white.cgColor
        emailField.layer.cornerRadius = 3
        emailField.layer.masksToBounds = true
        emailField.backgroundColor = .white
        emailField.leftViewMode = .always
        let emailView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
        emailView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let emailImageView = UIImageView(frame: CGRect(x: 5, y: 0, width: 20, height: 20))
        emailImageView.image = UIImage(named: "users")
        emailImageView.contentMode = .scaleAspectFit
        emailView.addSubview(emailImageView)
        emailField.leftView = emailView
        passwordLabel.font = UIFont.systemFont(ofSize: 12)
        passwordField.layer.borderWidth = 1
        passwordField.layer.borderColor = UIColor.white.cgColor
        passwordField.layer.cornerRadius = 3
        passwordField.backgroundColor = .white
        passwordField.isSecureTextEntry = true
        let passwordView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
        let passwordImageView = UIImageView(frame: CGRect(x: 5, y: 0, width: 20, height: 20))
        passwordImageView.image = UIImage(named: "key")
        passwordImageView.contentMode = .scaleAspectFit
        passwordView.addSubview(passwordImageView)
        passwordField.leftViewMode = .always
        passwordField.leftView = passwordView
        submitButton.layer.cornerRadius = 3
        submitButton.layer.masksToBounds = true
        submitButton.backgroundColor = UIColor.red
        submitButton.setTitleColor(UIColor.white, for: .normal)
        let fpTap = UITapGestureRecognizer(target: self, action: #selector(goToForgotPassword))
        forgotPasswordView.addGestureRecognizer(fpTap)
        forgotPasswordLabel.font = UIFont.italicSystemFont(ofSize: 11)
        forgotPasswordLabel.textColor = UIColor.red
        orLabel.font = UIFont.systemFont(ofSize: 12)
        registerButton.layer.cornerRadius = 3
        registerButton.layer.masksToBounds = true
        registerButton.backgroundColor = UIColor.black
        registerButton.setTitleColor(UIColor.white, for: .normal)
        versionLabel.font = UIFont.boldSystemFont(ofSize: 11)
        
        presenter = LoginPresenter(delegate: self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(languageChanged), name: .languageChanged, object: nil)
    }
    
    func setViewText() {
        if getLocalData(key: "language") == "language_id" {
            languageLabel.text = localize("indonesia")
        } else if getLocalData(key: "language") == "language_en" {
            languageLabel.text = localize("english")
        }
        emailLabel.text = localize("email")
        emailField.placeholder = localize("email")
        passwordLabel.text = localize("password")
        passwordField.placeholder = localize("password")
        submitButton.setTitle(localize("login").uppercased(), for: .normal)
        forgotPasswordLabel.text = localize("forgot_your_password").uppercased()
        orLabel.text = localize("or")
        registerButton.setTitle(localize("register").uppercased(), for: .normal)
        versionLabel.text = String.localizedStringWithFormat(localize("app_version"), getAppVersion())
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
    
    func showLoading(_ show: Bool) {
        if show {
            loadingView.isHidden = false
        } else {
            loadingView.isHidden = true
        }
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        showLoading(true)
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
    
    @objc func languageChanged() {
        setViewText()
    }
}

extension LoginViewController: LoginDelegate {
    func isLoginSuccess(_ isSuccess: Bool, _ message: String) {
        showLoading(false)
        if isSuccess {
            let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let homeViewController : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "GeneralTabBar") as UIViewController
            self.present(homeViewController, animated: true, completion: nil)
        } else {
            showAlert(title: localize("information"), message: message)
        }
    }
}
