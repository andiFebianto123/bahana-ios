//
//  TransactionDetail2ViewController.swift
//  Bahana
//
//  Created by Christian Chandra on /2002/13.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import UIKit

class TransactionDetail2ViewController: UIViewController {

    @IBOutlet weak var testView: UIView!
    @IBOutlet weak var testStackView: UIStackView!
    @IBOutlet weak var testViewHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        testView.backgroundColor = UIColorFromHex(rgbValue: 0xfee2e1)
        
        setGeneralInformation("Fund Name", "BLP")
        setGeneralInformation("Investment (BIO)", "IDR 10")
        setGeneralInformation("Tenor", "1 month")
        setGeneralInformation("Issue Date", "21 Dec 19")
        setGeneralInformation("Maturity Date", "21 Jan 20")
        setGeneralInformation("Interest Rate (%)", "8.5 %")
        setGeneralInformation("Interest Rate (%)", "8.5 %")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func addDescriptionText(_ title: String, _ content: String) -> UIView {
        let portfolio = UIView()
        
        let titleFont = UIFont.boldSystemFont(ofSize: 10)
        let titleColor = titleLabelColor
        let contentFont = UIFont.boldSystemFont(ofSize: 14)
        
        let titleLabel = UILabel()
        titleLabel.font = titleFont
        titleLabel.textColor = titleColor
        titleLabel.text = title
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        portfolio.addSubview(titleLabel)
        let contentLabel = UILabel()
        contentLabel.text = content
        contentLabel.font = contentFont
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        portfolio.addSubview(contentLabel)
        
        NSLayoutConstraint.activate([
            portfolio.heightAnchor.constraint(equalToConstant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: portfolio.leadingAnchor, constant: 10),
            titleLabel.topAnchor.constraint(equalTo: portfolio.topAnchor, constant: 10),
            titleLabel.heightAnchor.constraint(equalToConstant: 12),
            contentLabel.leadingAnchor.constraint(equalTo: portfolio.leadingAnchor, constant: 10),
            contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0),
            contentLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
        
        return portfolio
    }
    
    func setGeneralInformation(_ title: String, _ content: String) {
        let subView = addDescriptionText(title, content)
        testStackView.addArrangedSubview(subView)
        testViewHeight.constant += CGFloat(30)
    }
}
