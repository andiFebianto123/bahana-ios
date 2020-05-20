//
//  AuctionDetailNormal2ViewController.swift
//  Bahana
//
//  Created by Christian Chandra on /2005/20.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import UIKit

class AuctionDetailNormal2ViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var stackView2: UIStackView!
    @IBOutlet weak var stackView3: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var auctionEndLabel: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusViewWidth: NSLayoutConstraint!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var portfolioView: UIView!
    @IBOutlet weak var fundNameTitleLabel: UILabel!
    @IBOutlet weak var fundNameLabel: UILabel!
    @IBOutlet weak var investmentTitleLabel: UILabel!
    @IBOutlet weak var investmentLabel: UILabel!
    @IBOutlet weak var placementDateTitleLabel: UILabel!
    @IBOutlet weak var placementDateLabel: UILabel!
    @IBOutlet weak var custodianBankTitleLabel: UILabel!
    @IBOutlet weak var custodianBankLabel: UILabel!
    @IBOutlet weak var picCustodianTitleLabel: UILabel!
    @IBOutlet weak var picCustodianLabel: UILabel!
    @IBOutlet weak var noteTitleLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var bidStackView: UIStackView!
    @IBOutlet weak var bidStackViewHeight: NSLayoutConstraint!
    @IBOutlet weak var interestRateParentStackView: UIStackView!
    @IBOutlet weak var interestRateTitleLabel: UILabel!
    @IBOutlet weak var interestRateStackView: UIStackView!
    @IBOutlet weak var interestRateStackViewHeight: NSLayoutConstraint!
    @IBOutlet weak var interestRateButtonStackView: UIStackView!
    @IBOutlet weak var interestRateAddDayButton: UIButton!
    @IBOutlet weak var interestRateAddMonthButton: UIButton!
    @IBOutlet weak var maxPlacementStackView: UIStackView!
    @IBOutlet weak var maxPlacementTitleLabel: UILabel!
    @IBOutlet weak var maxPlacementTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var footerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = backgroundColor
        scrollView.backgroundColor = backgroundColor
        //stackView.backgroundColor = backgroundColor
        //scrollView.contentSize = CGSize(width: view.frame.width - 40, height: view.frame.height)
        
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        stackView2.translatesAutoresizingMaskIntoConstraints = false
        stackView3.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            mainStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0),
            mainStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            mainStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0),
            stackView2.widthAnchor.constraint(equalTo: mainStackView.widthAnchor, multiplier: 0),
            stackView3.widthAnchor.constraint(equalTo: stackView2.widthAnchor, multiplier: 0),
        ])
        portfolioView.backgroundColor = .yellow
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
