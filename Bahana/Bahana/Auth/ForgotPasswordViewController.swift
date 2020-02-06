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
        emailLabel.font = UIFont.systemFont(ofSize: 12)
        emailLabel.text = "Email"
        emailField.leftViewMode = .always
        let emailImageView = UIImageView(frame: CGRect(x: 10, y: 0, width: 20, height: 20))
        emailImageView.image = UIImage(systemName: "person.and.person")
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
