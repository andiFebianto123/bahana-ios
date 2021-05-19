//
//  MultifoundConfirmationViewController.swift
//  Bahana
//
//  Created by RECTmedia MD102 on 07/05/21.
//  Copyright © 2021 Rectmedia. All rights reserved.
//

import UIKit

class MultifoundConfirmationViewController: UIViewController {

    @IBOutlet weak var navigationView: UIView! // untuk box navigasi
    @IBOutlet weak var navigationViewHeight: NSLayoutConstraint! // untuk navigation heigth constraint
    @IBOutlet weak var closeView: UIView! // tombol close view
    @IBOutlet weak var navigationTitle: UILabel! // judul navigation
    
    var id = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationTitle.text = localize("confirmation").uppercased()
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
