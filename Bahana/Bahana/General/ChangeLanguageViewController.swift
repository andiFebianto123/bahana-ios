//
//  ChangeLanguageViewController.swift
//  Bahana
//
//  Created by Christian Chandra on /2003/10.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import UIKit

class ChangeLanguageViewController: UIViewController {

    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var navigationViewHeight: NSLayoutConstraint!
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var closeView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var languages = [
        "language_en",
        "language_id"
    ]
    
    var language: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setNavigationItems()
        
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
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
        navigationView.backgroundColor = primaryColor
        navigationViewHeight.constant = getNavigationHeight()
        let buttonFrame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        navigationTitle.textColor = .white
        navigationTitle.font = UIFont.systemFont(ofSize: 16)
        navigationTitle.text = localize("language").uppercased()
        
        closeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(close)))
    }
    
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func showConfirmationAlert(_ message: String) {
        let alert = UIAlertController(title: localize("confirmation"), message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: localize("cancel"), style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: localize("ok"), style: .default, handler: { action in
            setLocalData(["language": self.language])
            NotificationCenter.default.post(name: Notification.Name("LanguageChanged"), object: nil, userInfo: nil)
            //self.setNavigationItems()
            //self.tableView.reloadData()
            self.close()
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension ChangeLanguageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ChangeLanguageTableViewCell
        cell.name.text = localize(languages[indexPath.row])
        if getLocalData(key: "language") == languages[indexPath.row] {
            cell.checked()
        } else {
            cell.unchecked()
        }
        return cell
    }
}

extension ChangeLanguageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        language = languages[indexPath.row]
        let message = String.localizedStringWithFormat(localize("confirmation_change_language"), localize(language))
        showConfirmationAlert(message)
    }
}
