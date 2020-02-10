//
//  GeneralTabBarViewController.swift
//  Bahana
//
//  Created by Christian Chandra on /2002/06.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import UIKit

class GeneralTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let firstViewController : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "Dashboard")
        
        let auctionStoryboard: UIStoryboard = UIStoryboard(name: "Auction", bundle: nil)
        let secondViewController = auctionStoryboard.instantiateViewController(withIdentifier: "AuctionList") as! AuctionListViewController
        secondViewController.test = "auction"
        let thirdViewController = auctionStoryboard.instantiateViewController(withIdentifier: "AuctionList") as! AuctionListViewController
        thirdViewController.test = "history"
        
        viewControllers = [firstViewController, secondViewController, thirdViewController]
        
        //tabBar.items![0].image = UIImage(systemName: "home")
        tabBar.items![0].title = "Home"
        //tabBar.items![1].image = UIImage(systemName: "compose")
        tabBar.items![1].title = "Auction"
        //tabBar.items![2].image = UIImage(systemName: "history")
        tabBar.items![2].title = "History"
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
