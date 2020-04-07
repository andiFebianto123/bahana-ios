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

    var webView: WKWebView!
    
    var presenter: TermsAndConditionsPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let config = WKWebViewConfiguration()
        
        config.userContentController.add(self, name: "jsHandler")
        
        webView = WKWebView(frame: self.view.frame, configuration: config)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view.addSubview(webView)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 20)
        ])
        
        presenter = TermsAndConditionsPresenter(delegate: self)
        presenter.getTC()
        
        NotificationCenter.default.addObserver(self, selector: #selector(verify(notification:)), name: Notification.Name("RegisterNext"), object: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @objc func verify(notification:Notification) {
        NotificationCenter.default.post(name: Notification.Name("RegisterNextValidation"), object: nil, userInfo: ["step": 3])
    }
}

extension TermsAndConditionsViewController: WKUIDelegate {
    
}

extension TermsAndConditionsViewController: WKNavigationDelegate {
    
}

extension TermsAndConditionsViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "jsHandler" {
            NotificationCenter.default.post(name: Notification.Name("RegisterAgreement"), object: nil, userInfo: ["isChecked": message.body])
        }
    }
    
}

extension TermsAndConditionsViewController: TermsAndConditionsDelegate {
    func setData(_ data: String) {
        webView.loadHTMLString(data, baseURL: nil)
    }
}
