//
//  ContactViewController.swift
//  Bahana
//
//  Created by Christian Chandra on /2003/09.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import UIKit

class ContactViewController: UIViewController {

    @IBOutlet weak var contact1View: UIView!
    @IBOutlet weak var contact1Title: UILabel!
    @IBOutlet weak var contact1Name: UILabel!
    @IBOutlet weak var contact1Phone: UILabel!
    @IBOutlet weak var contact2View: UIView!
    @IBOutlet weak var contact2Title: UILabel!
    @IBOutlet weak var contact2Name: UILabel!
    @IBOutlet weak var contact2Phone: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = backgroundColor
        
        contact1Title.textColor = primaryColor
        contact1Phone.textColor = .blue
        contact2Title.textColor = primaryColor
        contact2Phone.textColor = .blue
        
        setNavigationItems()
        setContent()
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
        //self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.barTintColor = UIColor.red
        let buttonFrame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        let label = UILabel()
        label.text = "CONTACT"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.white
        let titleBar = UIBarButtonItem.init(customView: label)
        //navigationItem.setHidesBackButton(true, animated: false)
        navigationItem.setLeftBarButton(titleBar, animated: true)
        
        let closeButton = UIButton(type: UIButton.ButtonType.custom)
        closeButton.setImage(UIImage(named: "close"), for: .normal)
        closeButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 70, bottom: 10, right: 0)
        //closeButton.frame = buttonFrame
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        let closeBarButton = UIBarButtonItem(customView: closeButton)
        //navigationItem.setHidesBackButton(true, animated: false)
        
        navigationItem.rightBarButtonItem = closeBarButton
    }
    
    func setContent() {
        contact1View.layer.cornerRadius = 5
        contact1View.backgroundColor = .white
        contact1Title.text = "Fund Manager"
        contact1Name.text = "Tono"
        contact1Phone.text = "040404"
        
        contact2View.layer.cornerRadius = 5
        contact2View.backgroundColor = .white
        contact2Title.text = "Manager"
        contact2Name.text = "ANI"
        contact2Phone.text = "5550505"
    }
    
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
}
