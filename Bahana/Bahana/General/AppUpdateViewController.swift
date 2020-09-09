//
//  AppUpdateViewController.swift
//  Bahana
//
//  Created by Christian Chandra on /2005/29.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import UIKit

class AppUpdateViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var updateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleLabel.text = localize("app_update_information_title")
        titleLabel.font = UIFont.boldSystemFont(ofSize: 13)
        contentLabel.text = localize("app_update_information_content")
        contentLabel.font = UIFont.systemFont(ofSize: 11)
        updateButton.setTitle(localize("app_update_information_button").uppercased(), for: .normal)
        updateButton.setTitleColor(UIColor.white, for: .normal)
        updateButton.backgroundColor = primaryColor
        updateButton.layer.cornerRadius = 3
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func updateButtonPressed(_ sender: Any) {
        if let url = URL(string: APP_STORE_URL) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                if UIApplication.shared.canOpenURL(url as URL) {
                    UIApplication.shared.openURL(url as URL)
                }
            }
        } else {
            print("Can't open URL")
        }
    }
}
