//
//  ForgotPasswordViewController.swift
//  Bahana
//
//  Created by Christian Chandra on /2002/05.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    var loadingView = UIView()
    
    var presenter: ForgotPasswordPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setNavigationItems()
        setupToHideKeyboardOnTapOnView()
        
        view.backgroundColor = backgroundColor
        
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
        
        emailLabel.font = UIFont.systemFont(ofSize: 12)
        emailLabel.text = localize("email")
        emailField.leftViewMode = .always
        let emailView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
        emailView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let emailImageView = UIImageView(frame: CGRect(x: 5, y: 0, width: 20, height: 20))
        emailImageView.image = UIImage(named: "users")
        emailImageView.contentMode = .scaleAspectFit
        emailView.addSubview(emailImageView)
        emailField.leftView = emailView
        emailField.placeholder = localize("email")
        submitButton.layer.cornerRadius = 3
        submitButton.layer.masksToBounds = true
        submitButton.backgroundColor = UIColor.red
        submitButton.setTitleColor(UIColor.white, for: .normal)
        submitButton.setTitle(localize("reset_password").uppercased(), for: .normal)
        
        presenter = ForgotPasswordPresenter(delegate: self)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func setNavigationItems() {
        self.navigationController?.navigationBar.barTintColor = UIColor.red
        let buttonFrame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        let label = UILabel()
        label.text = localize("forgot_password_title").uppercased()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.white
        let titleBar = UIBarButtonItem.init(customView: label)
        //navigationItem.setHidesBackButton(true, animated: false)
        navigationItem.setLeftBarButton(titleBar, animated: true)
        
        let closeButton = UIButton(type: UIButton.ButtonType.custom)
        closeButton.setImage(UIImage(named: "close"), for: .normal)
        closeButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 70, bottom: 10, right: 0)
        closeButton.frame = buttonFrame
        closeButton.addTarget(self, action: #selector(exit), for: .touchUpInside)
        let closeBarButton = UIBarButtonItem(customView: closeButton)
        //navigationItem.setHidesBackButton(true, animated: false)
        
        navigationItem.rightBarButtonItem = closeBarButton
    }
    
    @objc func exit() {
        self.dismiss(animated: true, completion: nil)
    }
    
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
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        if emailField.text!.isEmpty {
            // Email empty
            showAlert(title: localize("information"), message: localize("email_required"))
        } else if !emailField.text!.isEmpty && !isEmailValid(emailField.text!) {
            // Email not valid
            showAlert(title: localize("information"), message: localize("email_not_valid"))
        } else {
            showLoading(true)
            presenter.submit(emailField.text!)
        }
    }
}

extension ForgotPasswordViewController: ForgotPasswordDelegate {
    func isSubmitSuccess(_ isSuccess: Bool, _ message: String) {
        showLoading(false)
        showAlert(title: localize("information"), message: message)
    }
}
