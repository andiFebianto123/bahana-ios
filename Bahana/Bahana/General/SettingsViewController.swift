//
//  SettingsViewController.swift
//  Bahana
//
//  Created by Christian Chandra on /2002/26.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var notificationView: UIView!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var fullnameView: UIView!
    @IBOutlet weak var fullnameTitleLabel: UILabel!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var fullnameViewWidth: NSLayoutConstraint!
    @IBOutlet weak var editImageView: UIImageView!
    @IBOutlet weak var contactTitleLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var bestRateView: UIView!
    @IBOutlet weak var bestRateLabel: UILabel!
    @IBOutlet weak var contactView: UIView!
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var faqView: UIView!
    @IBOutlet weak var faqLabel: UILabel!
    @IBOutlet weak var languageView: UIView!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var logoutView: UIView!
    @IBOutlet weak var logoutLabel: UILabel!
    
    var viewTo = String()
    
    var presenter: SettingsPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "bg")
        backgroundImage.contentMode = .scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        
        navigationView.backgroundColor = primaryColor
        navigationTitle.textColor = .white
        notificationView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showNotification)))
        profileView.backgroundColor = .white
        fullnameTitleLabel.textColor = .gray
        contactTitleLabel.textColor = .gray
        
        fullnameView.tag = 0
        fullnameView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(menuPressed(_:))))
        
        let borderColor = UIColor.systemGray.cgColor
        let borderWidth: CGFloat = 0.5
        
        bestRateView.layer.borderWidth = borderWidth
        bestRateView.layer.borderColor = borderColor
        bestRateView.tag = 1
        bestRateView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(menuPressed(_:))))
        
        contactView.layer.borderWidth = borderWidth
        contactView.layer.borderColor = borderColor
        contactView.tag = 2
        contactView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(menuPressed(_:))))
        
        faqView.layer.borderWidth = borderWidth
        faqView.layer.borderColor = borderColor
        faqView.tag = 3
        faqView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(menuPressed(_:))))
        
        languageView.layer.borderWidth = borderWidth
        languageView.layer.borderColor = borderColor
        languageView.tag = 4
        languageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(menuPressed(_:))))
        
        logoutView.layer.borderWidth = borderWidth
        logoutView.layer.borderColor = borderColor
        logoutView.tag = 5
        logoutView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(menuPressed(_:))))
        
        setContent()
        
        presenter = SettingsPresenter(delegate: self)
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showRegister" {
            if let navigation = segue.destination as? UINavigationController {
                if let destinationVC = navigation.topViewController as? RegisterViewController {
                    destinationVC.viewTo = viewTo
                }
            }
        }
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: localize("ok"), style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func setContent() {
        fullnameLabel.text = getLocalData(key: "name")
        emailLabel.text = getLocalData(key: "email")
        phoneLabel.text = getLocalData(key: "phone")
    }
    
    @objc func showNotification() {
        performSegue(withIdentifier: "showNotification", sender: self)
    }
    
    @objc func menuPressed(_ sender: UITapGestureRecognizer) {
        let tag = sender.view?.tag
        switch tag {
        case 0:
            // Edit Profile
            viewTo = "profile"
            performSegue(withIdentifier: "showRegister", sender: self)
        case 1:
            // Edit Best Rate
            viewTo = "best_rate"
            performSegue(withIdentifier: "showRegister", sender: self)
        case 2:
            // Contact
            performSegue(withIdentifier: "showContact", sender: self)
        case 3:
            // FAQ
            print("faq")
            //performSegue(withIdentifier: "", sender: self)
        case 4:
            // Change Language
            print("language")
            //performSegue(withIdentifier: "", sender: self)
        case 5:
            // Logout
            presenter.logout()
        default:
            break
        }
    }
}

extension SettingsViewController: SettingsDelegate {
    func isLogoutSuccess(_ isLoggedOut: Bool, _ message: String) {
        if !isLoggedOut {
            showAlert(title: localize("information"), message: message)
        } else {
            performSegue(withIdentifier: "showLogin", sender: self)
        }
    }
}
