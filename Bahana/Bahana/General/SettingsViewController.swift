//
//  SettingsViewController.swift
//  Bahana
//
//  Created by Christian Chandra on /2005/17.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var navigationViewHeight: NSLayoutConstraint!
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var notificationView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
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
    
    let refreshControl = UIRefreshControl()
    
    var loadingView = UIView()
    
    var viewTo = String()
    
    var presenter: SettingsPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setNavigationItems()
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
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        scrollView.refreshControl = refreshControl
        
        scrollView.backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "bg")
        backgroundImage.contentMode = .scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        
        profileView.backgroundColor = .white
        fullnameTitleLabel.textColor = .gray
        fullnameLabel.textColor = primaryColor
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
        
        presenter = SettingsPresenter(delegate: self)
        presenter.getProfile()
        
        NotificationCenter.default.addObserver(self, selector: #selector(languageChanged), name: Notification.Name("LanguageChanged"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationItems()
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

    func setNavigationItems() {
        navigationView.backgroundColor = primaryColor
        navigationViewHeight.constant = getNavigationHeight()
        //let buttonFrame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        navigationTitle.textColor = .white
        navigationTitle.font = UIFont.systemFont(ofSize: 16)
        navigationTitle.text = localize("profile").uppercased()
        
        // Set badge notification
        let badgeView = UIView()
        badgeView.backgroundColor = .lightGray
        badgeView.layer.cornerRadius = 6
        badgeView.isHidden = true
        badgeView.translatesAutoresizingMaskIntoConstraints = false
        notificationView.addSubview(badgeView)
        
        let badgeLabel = UILabel()
        getUnreadNotificationCount() { count in
            badgeView.isHidden = false
            if count > 99 {
                badgeLabel.text = "99+"
            } else if count == 0 {
                badgeView.isHidden = true
            } else {
                badgeLabel.text = "\(count)"
            }
        }
        badgeLabel.font = UIFont.systemFont(ofSize: 8)
        badgeLabel.textColor = .white
        badgeLabel.translatesAutoresizingMaskIntoConstraints = false
        badgeView.addSubview(badgeLabel)
        
        NSLayoutConstraint.activate([
            badgeView.topAnchor.constraint(equalTo: notificationView.topAnchor, constant: 0),
            badgeView.trailingAnchor.constraint(equalTo: notificationView.trailingAnchor, constant: -2),
            badgeView.heightAnchor.constraint(equalToConstant: 14),
            badgeView.widthAnchor.constraint(equalToConstant: 22),
            badgeLabel.centerXAnchor.constraint(equalTo: badgeView.centerXAnchor),
            badgeLabel.centerYAnchor.constraint(equalTo: badgeView.centerYAnchor),
        ])
        
        notificationView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showNotification)))
    }
    
    func setViewText() {
        fullnameTitleLabel.text = localize("fullname").uppercased()
        contactTitleLabel.text = localize("email_and_contact").uppercased()
        bestRateLabel.text =  localize("edit_best_rate").uppercased()
        contactLabel.text = localize("contact").uppercased()
        faqLabel.text = localize("faq").uppercased()
        languageLabel.text = localize("language").uppercased()
        logoutLabel.text = localize("logout").uppercased()
    }
    
    func showLoading(_ show: Bool) {
        if show {
            loadingView.isHidden = false
        } else {
            loadingView.isHidden = true
        }
    }
    
    @objc func refresh() {
        showLoading(true)
        presenter.getProfile()
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: localize("ok"), style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func setContent(_ name: String, _ email: String, _ phone: String) {
        fullnameLabel.text = name
        emailLabel.text = email
        phoneLabel.text = phone
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
            performSegue(withIdentifier: "showFaq", sender: self)
        case 4:
            // Change Language
            performSegue(withIdentifier: "showChangeLanguage", sender: self)
        case 5:
            // Logout
            showLoading(true)
            presenter.logout()
        default:
            break
        }
    }
    
    @objc func languageChanged() {
        setNavigationItems()
        setViewText()
    }
}

extension SettingsViewController: SettingsDelegate {
    func setProfile(_ name: String, _ email: String, _ phone: String) {
        refreshControl.endRefreshing()
        showLoading(false)
        setContent(name, email, phone)
    }
    
    func isLogoutSuccess(_ isLoggedOut: Bool, _ message: String) {
        refreshControl.endRefreshing()
        showLoading(false)
        if !isLoggedOut {
            showAlert(title: localize("information"), message: message)
        } else {
            performSegue(withIdentifier: "showLogin", sender: self)
        }
    }
    
    func getDataFail() {
        refreshControl.endRefreshing()
        showLoading(false)
        let alert = UIAlertController(title: localize("information"), message: localize("cannot_connect_to_server"), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: localize("ok"), style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func openLoginPage() {
        let authStoryboard : UIStoryboard = UIStoryboard(name: "Auth", bundle: nil)
        let loginViewController : UIViewController = authStoryboard.instantiateViewController(withIdentifier: "Login") as UIViewController
        self.present(loginViewController, animated: true, completion: nil)
    }
}
