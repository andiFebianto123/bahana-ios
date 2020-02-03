//
//  RegisterTabBarViewController.swift
//  Bahana
//
//  Created by Christian Chandra on /2002/01.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import UIKit

class RegisterTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tabBar.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeTab(notification:)), name: Notification.Name("RegisterTab"), object: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @objc func changeTab(notification:Notification) {
        if let data = notification.userInfo as? [String: Int] {
            let idx = data["idx"]!
            self.selectedIndex = idx
        }
    }
}
