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
    
    var presenter: ForgotPasswordPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setNavigationItems()
        setupToHideKeyboardOnTapOnView()
        
        emailLabel.font = UIFont.systemFont(ofSize: 12)
        emailLabel.text = "Email"
        emailField.leftViewMode = .always
        let emailImageView = UIImageView(frame: CGRect(x: 10, y: 0, width: 20, height: 20))
        //emailImageView.image = UIImage(systemName: "person.and.person")
        emailField.leftView = emailImageView
        emailField.placeholder = "Email"
        submitButton.layer.cornerRadius = 3
        submitButton.layer.masksToBounds = true
        submitButton.backgroundColor = UIColor.red
        submitButton.setTitleColor(UIColor.white, for: .normal)
        submitButton.setTitle("ATUR ULANG SANDI", for: .normal)
        
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
        label.text = "LUPA SANDI"
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
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        presenter.submit(emailField.text!)
    }
}

extension ForgotPasswordViewController: ForgotPasswordDelegate {
    func isSubmitSuccess(_ isSuccess: Bool, _ message: String) {
        showAlert(title: "Informasi", message: message)
    }
}
