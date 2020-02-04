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
        let config = WKWebViewConfiguration()
        let js = test()
        let script = WKUserScript(source: js, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
        
        config.userContentController.addUserScript(script)
        //config.userContentController.add(self, name: "clickListener")
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
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

    func test() -> String {
        return "hello world"
    }
}

extension TermsAndConditionsViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        //
    }
}

extension TermsAndConditionsViewController: WKUIDelegate {
    
}

extension TermsAndConditionsViewController: TermsAndConditionsDelegate {
    func setData(_ data: String) {
        webView.loadHTMLString(data, baseURL: nil)
    }
}
