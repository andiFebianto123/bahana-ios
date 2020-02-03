//
//  TermsAndConditionsViewController.swift
//  Bahana
//
//  Created by Christian Chandra on /2001/31.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import UIKit
import WebKit

class TermsAndConditionsViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    var presenter: TermsAndConditionsPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        presenter = TermsAndConditionsPresenter(delegate: self)
        presenter.getTC()
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

extension TermsAndConditionsViewController: TermsAndConditionsDelegate {
    func setData(_ data: String) {
        webView.loadHTMLString(data, baseURL: nil)
    }
}
