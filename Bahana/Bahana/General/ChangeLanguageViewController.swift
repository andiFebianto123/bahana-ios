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
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var closeView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var languages = [
        "language_en",
        "language_id"
    ]
    
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
        let buttonFrame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        navigationTitle.textColor = .white
        navigationTitle.font = UIFont.systemFont(ofSize: 16)
        //navigationTitle.text = localize("home").uppercased()
        
        //let notificationButton = UIButton(type: UIButton.ButtonType.custom)
        //notificationButton.setImage(UIImage(named: "notification"), for: .normal)
        //notificationButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        //notificationButton.frame = buttonFrame
        //notificationButton.addTarget(self, action: #selector(showNotification), for: .touchUpInside)
        closeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(close)))
        
    }
    
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
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
        setLocalData(["language": languages[indexPath.row]])
        tableView.reloadData()
    }
}
