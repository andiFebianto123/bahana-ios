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
        secondViewController.pageType = "auction"
        let thirdViewController = auctionStoryboard.instantiateViewController(withIdentifier: "AuctionList") as! AuctionListViewController
        thirdViewController.pageType = "history"
        let fourthViewController = auctionStoryboard.instantiateViewController(withIdentifier: "TransactionList") as! TransactionListViewController
        let fifthViewController = auctionStoryboard.instantiateViewController(withIdentifier: "TransactionList") as! TransactionListViewController
        
        viewControllers = [firstViewController, secondViewController, thirdViewController, fourthViewController, fifthViewController]
        
        let iconSize = CGSize(width: 30, height: 30)
        let inset = UIEdgeInsets(top: 100, left: 100, bottom: 100, right: 100)
        
        tabBar.tintColor = primaryColor
        
        tabBar.items![0].image = resizeImage(image: UIImage(named: "home")!, targetSize: iconSize)
        tabBar.items![0].title = "Home"
        tabBar.items![1].image = resizeImage(image: UIImage(named: "auction")!, targetSize: iconSize)
        tabBar.items![1].title = "Auction"
        tabBar.items![2].image = resizeImage(image: UIImage(named: "history")!, targetSize: iconSize)
        tabBar.items![2].title = "History"
        tabBar.items![3].image = resizeImage(image: UIImage(named: "transaction")!, targetSize: iconSize)
        tabBar.items![3].title = "Transaction"
        tabBar.items![4].image = resizeImage(image: UIImage(named: "profile")!, targetSize: iconSize)
        tabBar.items![4].title = "Profile"
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
