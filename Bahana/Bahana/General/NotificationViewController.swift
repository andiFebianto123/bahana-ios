//
//  NotificationViewController.swift
//  Bahana
//
//  Created by Christian Chandra on /2003/09.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController {

    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var navigationBackView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var presenter: NotificationPresenter!
    
    var data = [NotificationModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = backgroundColor
        //tableView.estimatedRowHeight = CGFloat()
        
        setNavigationItems()
        
        presenter = NotificationPresenter(delegate: self)
        presenter.getData()
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
        
        navigationBackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(close)))
        
    }
    
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension NotificationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NotificationTableViewCell
        let notification = data[indexPath.row]
        cell.notificationTitle.text = notification.title
        cell.notificationContent.text = notification.message
        cell.notificationDate.text = notification.created_at
        if notification.is_read == 0 {
            cell.isUnread()
        }
        return cell
    }
}

extension NotificationViewController: UITableViewDelegate {
    /*func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }*/
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //return UITableView.automaticDimension
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
}

extension NotificationViewController: NotificationDelegate {
    func setData(_ data: [NotificationModel]) {
        self.data = data
        tableView.reloadData()
    }
    
    func isMarkAsRead(_ isRead: Bool) {
        //
    }
}
