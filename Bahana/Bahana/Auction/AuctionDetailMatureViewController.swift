//
//  AuctionDetailMatureViewController.swift
//  Bahana
//
//  Created by Christian Chandra on /2003/26.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import UIKit

class AuctionDetailMatureViewController: UIViewController {

    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var navigationViewHeight: NSLayoutConstraint!
    @IBOutlet weak var navigationBackView: UIView!
    @IBOutlet weak var navigationBackImageView: UIImageView!
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var auctionEndLabel: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusViewWidth: NSLayoutConstraint!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var portfolioView: UIView!
    @IBOutlet weak var fundNameTitleLabel: UILabel!
    @IBOutlet weak var fundNameLabel: UILabel!
    @IBOutlet weak var custodianBankTitleLabel: UILabel!
    @IBOutlet weak var custodianBankLabel: UILabel!
    @IBOutlet weak var picCustodianTitleLabel: UILabel!
    @IBOutlet weak var picCustodianLabel: UILabel!
    @IBOutlet weak var detailTitleLabel: UILabel!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var tenorTitleLabel: UILabel!
    @IBOutlet weak var tenorLabel: UILabel!
    @IBOutlet weak var interestRateTitleLabel: UILabel!
    @IBOutlet weak var interestRateLabel: UILabel!
    @IBOutlet weak var investmentTitleLabel: UILabel!
    @IBOutlet weak var investmentLabel: UILabel!
    @IBOutlet weak var periodTitleLabel: UILabel!
    @IBOutlet weak var periodLabel: UILabel!
    @IBOutlet weak var footerLabel: UILabel!
    
    //notes
    @IBOutlet weak var noteTitle: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    
    // winner stack
    
    @IBOutlet weak var winnerView: AuctionWinnerDetailView!
    
    
    var loadingView = UIView()
    
    var presenter: AuctionDetailMaturePresenter!
    
    var id = Int()
    var data: AuctionDetailMature!
    
    var dataMultifund: AuctionDetailMatureMultifund!
    
    var backToRoot = false
    
    var multifundAuction:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setNavigationItems()
        
        setupToHideKeyboardOnTapOnView()
        
        view.backgroundColor = backgroundColor
        scrollView.backgroundColor = backgroundColor
        scrollView.alwaysBounceHorizontal = false
        
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            mainStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            mainStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            mainStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0)
        ])
        
        // Set loading view
        loadingView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingView)
        view.bringSubviewToFront(loadingView)
        
        let spinner = UIActivityIndicatorView()
        spinner.color = .black
        spinner.startAnimating()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        loadingView.addSubview(spinner)
        
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: navigationView.bottomAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            spinner.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor)
        ])
        
        let titleFont = UIFont.systemFont(ofSize: 11)
        let contentFont = UIFont.boldSystemFont(ofSize: 12)
        
        
        
        if self.multifundAuction {
            titleLabel.text = localize("multifund_mature").uppercased()
            winnerView.isHidden = false
        }else{
            titleLabel.text = localize("mature").uppercased()
            winnerView.isHidden = true
        }
        
        titleLabel.textColor = primaryColor
        statusView.layer.cornerRadius = 10
        let cardBackgroundColor = lightRedColor
        portfolioView.backgroundColor = cardBackgroundColor
        portfolioView.layer.cornerRadius = 5
        portfolioView.layer.shadowColor = UIColor.gray.cgColor
        portfolioView.layer.shadowOffset = CGSize(width: 0, height: 0)
        portfolioView.layer.shadowRadius = 4
        portfolioView.layer.shadowOpacity = 0.5
        
        fundNameTitleLabel.font = titleFont
        fundNameTitleLabel.textColor = titleLabelColor
        fundNameTitleLabel.text = localize("fund_name")
        fundNameLabel.font = contentFont
        custodianBankTitleLabel.font = titleFont
        custodianBankTitleLabel.textColor = titleLabelColor
        custodianBankTitleLabel.text = localize("custodian_bank")
        custodianBankLabel.font = contentFont
        picCustodianTitleLabel.font = titleFont
        picCustodianTitleLabel.textColor = titleLabelColor
        picCustodianTitleLabel.text = localize("pic_custodian")
        picCustodianLabel.font = contentFont
        detailTitleLabel.textColor = primaryColor
        
        noteTitle.textColor = primaryColor
        noteTitle.text = localize("notes").uppercased()
        
        detailView.backgroundColor = cardBackgroundColor
        detailView.layer.cornerRadius = 5
        detailView.layer.shadowColor = UIColor.gray.cgColor
        detailView.layer.shadowOffset = CGSize(width: 0, height: 0)
        detailView.layer.shadowRadius = 4
        detailView.layer.shadowOpacity = 0.5
        tenorTitleLabel.font = titleFont
        tenorTitleLabel.text = localize("tenor")
        tenorLabel.font = contentFont
        interestRateTitleLabel.font = titleFont
        interestRateTitleLabel.text = localize("interest_rate")
        interestRateLabel.font = contentFont
        investmentTitleLabel.font = titleFont
        investmentTitleLabel.text = localize("investment")
        investmentLabel.font = contentFont
        periodTitleLabel.font = titleFont
        periodTitleLabel.text = localize("period")
        periodLabel.font = contentFont
        
        scrollView.isHidden = true
        
        presenter = AuctionDetailMaturePresenter(delegate: self)
        if self.multifundAuction {
            presenter.getAuctionMultifund(id)
        }else{
            presenter.getAuction(id)

        }
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
        //navigationBar.barTintColor = UIColor.red
        //navigationController?.navigationBar.barTintColor = primaryColor
        navigationView.backgroundColor = primaryColor
        navigationViewHeight.constant = getNavigationHeight()
        navigationTitle.text = localize("auction_detail").uppercased()
        let _ = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        let backTap = UITapGestureRecognizer(target: self, action: #selector(backButtonPressed))
        navigationBackImageView.image = UIImage(named: "icon_left")
        navigationBackView.addGestureRecognizer(backTap)
    }

    @objc func backButtonPressed() {
        if backToRoot {
            self.presentingViewController?.presentingViewController!.dismiss(animated: true, completion: nil)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }

    func showLoading(_ show: Bool) {
        loadingView.isHidden = !show
    }
    
    
    func setContent() {
        // Check status
        if data.status == "-" {
            statusView.isHidden = true
        } else {
            statusView.backgroundColor = primaryColor
            statusLabel.text = data.status
            statusViewWidth.constant = statusLabel.intrinsicContentSize.width + 20
        }
        
        auctionEndLabel.isHidden = true
       
        // Portfolio
        fundNameLabel.text = data.portfolio
        custodianBankLabel.text = data.custodian_bank != nil ? data.custodian_bank : "-"
        picCustodianLabel.text = data.pic_custodian != nil ? data.pic_custodian : "-"
        
        // Detail
        tenorLabel.text = data.period
        interestRateLabel.text = "\(checkPercentage(data.coupon_rate)) %"
        investmentLabel.text = "IDR \(toIdrBio(data.quantity))"
        periodLabel.text = "\(convertDateToString(convertStringToDatetime(data.issue_date)!)!) - \(convertDateToString(convertStringToDatetime(data.maturity_date)!)!)"
        
        // Notes
        noteLabel.text = data.notes
        print("Isi notes : \(data.notes)")
        
        // Footer
        let mutableAttributedString = NSMutableAttributedString()
        
        let topTextAttribute = [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        let bottomTextAttribute = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 8), NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        
        let topText = NSAttributedString(string: localize("auction_detail_footer"), attributes: topTextAttribute)
        mutableAttributedString.append(topText)
        let bottomText = NSAttributedString(string: "\n\(localize("ref_code"))\(data.auction_name)", attributes: bottomTextAttribute)
        mutableAttributedString.append(bottomText)
        
        footerLabel.attributedText = mutableAttributedString
    }
    
    func setContentMultifund(){
        // Check status
         if dataMultifund.status == "-" {
             statusView.isHidden = true
         } else {
             statusView.backgroundColor = primaryColor
             statusLabel.text = dataMultifund.status
             statusViewWidth.constant = statusLabel.intrinsicContentSize.width + 20
         }
         
         auctionEndLabel.isHidden = true
        
//         // Portfolio
//         fundNameLabel.text = data.portfolio
//         custodianBankLabel.text = data.custodian_bank != nil ? data.custodian_bank : "-"
//         picCustodianLabel.text = data.pic_custodian != nil ? data.pic_custodian : "-"
         portfolioView.isHidden = true
         // Detail
         tenorLabel.text = dataMultifund.tenor
         interestRateLabel.text = "\(checkPercentage(dataMultifund.coupon_rate)) %"
         investmentLabel.text = dataMultifund.total_investment
         periodLabel.text = dataMultifund.period
         
         // Notes
         noteLabel.text = dataMultifund.notes_auction
        
        // winner detail
        winnerView.layer.cornerRadius = 5
        winnerView.layer.shadowColor = UIColor.gray.cgColor
        winnerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        winnerView.layer.shadowRadius = 4
        winnerView.layer.shadowOpacity = 0.5
        winnerView.detailsMature = dataMultifund.details
        winnerView.setContentForMature()
         
         // Footer
         let mutableAttributedString = NSMutableAttributedString()
         
         let topTextAttribute = [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
         let bottomTextAttribute = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 8), NSAttributedString.Key.foregroundColor: UIColor.darkGray]
         
         let topText = NSAttributedString(string: localize("auction_detail_footer"), attributes: topTextAttribute)
         mutableAttributedString.append(topText)
         let bottomText = NSAttributedString(string: "\n\(localize("ref_code"))\(dataMultifund.auction_name)", attributes: bottomTextAttribute)
         mutableAttributedString.append(bottomText)
         
         footerLabel.attributedText = mutableAttributedString
    }
    
    func showAlert(_ message: String, _ isBackToList: Bool) {
        let alert = UIAlertController(title: localize("information"), message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: localize("ok"), style: .default, handler: { action in
            if isBackToList {
                self.dismiss(animated: true, completion: nil)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
}


extension AuctionDetailMatureViewController: AuctionDetailMatureDelegate {
    func setData(_ data: AuctionDetailMature) {
        self.data = data
        setContent()
        scrollView.isHidden = false
        showLoading(false)
    }
    
    func setDataMultifund(_ data: AuctionDetailMatureMultifund){
        self.dataMultifund = data
        setContentMultifund()
        scrollView.isHidden = false
        showLoading(false)
    }
    
    func getDataFail(_ message: String?) {
        showLoading(false)
        var msg = localize("cannot_connect_to_server")
        if message != nil {
            msg = message!
        }
        showAlert(msg, false)
    }
    
    func openLoginPage() {
        let authStoryboard : UIStoryboard = UIStoryboard(name: "Auth", bundle: nil)
        let loginViewController : UIViewController = authStoryboard.instantiateViewController(withIdentifier: "Login") as UIViewController
        self.present(loginViewController, animated: true, completion: nil)
    }
}
