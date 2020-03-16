//
//  AuctionDetailViewController.swift
//  Bahana
//
//  Created by Christian Chandra on /2002/05.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import UIKit

class AuctionDetailViewController: UIViewController {

    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var navigationBackView: UIView!
    @IBOutlet weak var navigationBackImageView: UIImageView!
    @IBOutlet weak var navigationTitle: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    
    var scrollView = UIScrollView()
    var mainView = UIView()
    
    var presenter: AuctionDetailPresenter!
    
    var auctionID: Int!
    var auctionType: String!
    var auctionRequestMaturityDate: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setNavigationItems()
        
        presenter = AuctionDetailPresenter(delegate: self)
        
        let auctionStoryboard : UIStoryboard = UIStoryboard(name: "Auction", bundle: nil)
        switch auctionType {
        case "auction":
            let viewController = auctionStoryboard.instantiateViewController(withIdentifier: "AuctionDetailNormal") as! AuctionDetailNormalViewController
            viewController.id = self.auctionID
            containerView.addSubview(viewController.view)
            viewController.view.frame = containerView.bounds
        case "direct-auction":
            let viewController = auctionStoryboard.instantiateViewController(withIdentifier: "AuctionDetailDirect") as! AuctionDetailDirectViewController
            viewController.id = self.auctionID
            containerView.addSubview(viewController.view)
            viewController.view.frame = containerView.bounds
        case "break":
            let viewController = auctionStoryboard.instantiateViewController(withIdentifier: "AuctionDetailBreak") as! AuctionDetailBreakViewController
            viewController.id = self.auctionID
            containerView.addSubview(viewController.view)
            viewController.view.frame = containerView.bounds
        case "rollover":
            let viewController = auctionStoryboard.instantiateViewController(withIdentifier: "AuctionDetailRollover") as! AuctionDetailRolloverViewController
            viewController.id = self.auctionID
            containerView.addSubview(viewController.view)
            viewController.view.frame = containerView.bounds
        default:
            break
        }
        /*let viewController = auctionStoryboard.instantiateViewController(withIdentifier: "AuctionDetailNormal") as! AuctionDetailNormalViewController
        viewController.id = self.auctionID
        containerView.addSubview(viewController.view)
        viewController.view.frame = containerView.bounds*/
        
        /*
        let screenSize = contentView.bounds
        scrollView.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        scrollView.contentSize = CGSize(width: screenSize.width, height: screenSize.height * 2)
        contentView.addSubview(scrollView)
        scrollView.addSubview(mainView)
        
        mainView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            mainView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            mainView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
        ])*/
        
        // Confirmation button pressed
        NotificationCenter.default.addObserver(self, selector: #selector(showConfimation(notification:)), name: Notification.Name("AuctionDetailConfirmation"), object: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showConfirmation" {
            if let destinationVC = segue.destination as? AuctionDetailConfirmationViewController {
                destinationVC.auctionID = auctionID
                destinationVC.auctionType = auctionType
                destinationVC.auctionRequestMaturityDate = auctionRequestMaturityDate
            }
        }
    }
    
    func setNavigationItems() {
        //navigationBar.barTintColor = UIColor.red
        //navigationController?.navigationBar.barTintColor = primaryColor
        navigationView.backgroundColor = primaryColor
        navigationTitle.text = localize("auction_detail").uppercased()
        let buttonFrame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        let backTap = UITapGestureRecognizer(target: self, action: #selector(backButtonPressed))
        navigationBackImageView.image = UIImage(named: "icon_left")
        navigationBackView.addGestureRecognizer(backTap)
    }

    @objc func backButtonPressed() {
        self.dismiss(animated: true, completion: nil)
        //
    }
    
    @objc func showConfimation(notification: Notification) {
        if let data = notification.userInfo as? [String: String] {
            let date = data["date"]
            if date != "" {
                auctionRequestMaturityDate = date
            }
            
            self.performSegue(withIdentifier: "showConfirmation", sender: self)
        }
    }
    /*
    func setStatus(_ status: String) {
        let subView = UIView()
        subView.backgroundColor = primaryColor
        subView.layer.cornerRadius = 8
        mainView.addSubview(subView)
        subView.translatesAutoresizingMaskIntoConstraints = false
        
        let statusLabel = UILabel()
        statusLabel.font = UIFont.systemFont(ofSize: 14)
        statusLabel.textColor = .white
        statusLabel.text = status
        subView.addSubview(statusLabel)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            subView.widthAnchor.constraint(equalToConstant: 50),
            subView.heightAnchor.constraint(equalToConstant: 20),
            subView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 20),
            subView.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: 0),
            statusLabel.centerXAnchor.constraint(equalTo: subView.centerXAnchor),
            statusLabel.centerYAnchor.constraint(equalTo: subView.centerYAnchor),
        ])
    }
    
    func setType(_ type: String) {
        let typeLabel = UILabel()
        typeLabel.textColor = primaryColor
        typeLabel.font = UIFont.systemFont(ofSize: 14)
        typeLabel.text = type
        mainView.addSubview(typeLabel)
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            typeLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 20),
            typeLabel.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 20)
        ])
    }
    
    func setPortfolio(_ data: [Detail]) -> NSLayoutYAxisAnchor {
        let portfolioView = UIView()
        portfolioView.backgroundColor = UIColorFromHex(rgbValue: 0xffe0e0)
        portfolioView.layer.cornerRadius = 5
        mainView.addSubview(portfolioView)
        portfolioView.translatesAutoresizingMaskIntoConstraints = false
        
        let portfolioStackView = UIStackView()
        portfolioStackView.axis = .vertical
        portfolioView.addSubview(portfolioStackView)
        portfolioStackView.translatesAutoresizingMaskIntoConstraints = false
        
        for dt in data {
            let portfolio = UIView()
            
            let titleFont = UIFont.boldSystemFont(ofSize: 10)
            let titleColor = titleLabelColor
            let contentFont = UIFont.boldSystemFont(ofSize: 14)
            
            let titleLabel = UILabel()
            titleLabel.font = titleFont
            titleLabel.textColor = titleColor
            titleLabel.text = dt.title
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            portfolio.addSubview(titleLabel)
            let contentLabel = UILabel()
            contentLabel.text = dt.content
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
            portfolioStackView.addArrangedSubview(portfolio)
        }
        
        NSLayoutConstraint.activate([
            portfolioView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 70),
            portfolioView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 20),
            portfolioView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -60),
            portfolioView.heightAnchor.constraint(equalToConstant: CGFloat(80 + (20 * data.count))),
            portfolioStackView.topAnchor.constraint(equalTo: portfolioView.topAnchor),
            portfolioStackView.bottomAnchor.constraint(equalTo: portfolioView.bottomAnchor),
            portfolioStackView.leadingAnchor.constraint(equalTo: portfolioView.leadingAnchor),
            portfolioStackView.trailingAnchor.constraint(equalTo: portfolioView.trailingAnchor),
        ])
        
        return portfolioView.bottomAnchor
    }
    
    func setDetail(_ data: [Detail], _ anchor: NSLayoutYAxisAnchor) -> NSLayoutYAxisAnchor {
        let detailTitleLabel = UILabel()
        detailTitleLabel.textColor = primaryColor
        detailTitleLabel.font = UIFont.systemFont(ofSize: 12)
        detailTitleLabel.text = "DETAIL"
        mainView.addSubview(detailTitleLabel)
        detailTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let detailView = UIView()
        detailView.backgroundColor = UIColorFromHex(rgbValue: 0xffe0e0)
        detailView.layer.cornerRadius = 5
        mainView.addSubview(detailView)
        detailView.translatesAutoresizingMaskIntoConstraints = false
        
        let detailStackView = UIStackView()
        detailStackView.axis = .vertical
        detailView.addSubview(detailStackView)
        detailStackView.translatesAutoresizingMaskIntoConstraints = false
        
        for dt in data {
            let detail = UIView()
            
            let titleFont = UIFont.boldSystemFont(ofSize: 10)
            let titleColor = titleLabelColor
            let contentFont = UIFont.boldSystemFont(ofSize: 14)
            
            let titleLabel = UILabel()
            titleLabel.font = titleFont
            titleLabel.textColor = titleColor
            titleLabel.text = dt.title
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            detail.addSubview(titleLabel)
            let contentLabel = UILabel()
            contentLabel.text = dt.content
            contentLabel.font = contentFont
            contentLabel.translatesAutoresizingMaskIntoConstraints = false
            detail.addSubview(contentLabel)
            
            NSLayoutConstraint.activate([
                detail.heightAnchor.constraint(equalToConstant: 30),
                titleLabel.leadingAnchor.constraint(equalTo: detail.leadingAnchor, constant: 10),
                titleLabel.topAnchor.constraint(equalTo: detail.topAnchor, constant: 10),
                titleLabel.heightAnchor.constraint(equalToConstant: 12),
                contentLabel.leadingAnchor.constraint(equalTo: detail.leadingAnchor, constant: 150),
                contentLabel.topAnchor.constraint(equalTo: detail.topAnchor, constant: 8),
                contentLabel.heightAnchor.constraint(equalToConstant: 18)
            ])
            detailStackView.addArrangedSubview(detail)
        }
        
        NSLayoutConstraint.activate([
            detailTitleLabel.topAnchor.constraint(equalTo: anchor, constant: 20),
            detailTitleLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 20),
            detailView.topAnchor.constraint(equalTo: detailTitleLabel.bottomAnchor, constant: 8),
            detailView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 20),
            detailView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -60),
            detailView.heightAnchor.constraint(equalToConstant: CGFloat(80 + (20 * data.count))),
            detailStackView.topAnchor.constraint(equalTo: detailView.topAnchor),
            detailStackView.bottomAnchor.constraint(equalTo: detailView.bottomAnchor),
            detailStackView.leadingAnchor.constraint(equalTo: detailView.leadingAnchor),
            detailStackView.trailingAnchor.constraint(equalTo: detailView.trailingAnchor),
        ])
        
        return detailView.bottomAnchor
    }
    
    func setNotes(_ note: String, _ anchor: NSLayoutYAxisAnchor) -> NSLayoutYAxisAnchor {
        let noteView = UIView()
        noteView.backgroundColor = backgroundColor
        mainView.addSubview(noteView)
        noteView.translatesAutoresizingMaskIntoConstraints = false
        
        let noteTitleLabel = UILabel()
        noteTitleLabel.font = UIFont.systemFont(ofSize: 12)
        noteTitleLabel.textColor = primaryColor
        noteTitleLabel.text = "NOTES"
        noteView.addSubview(noteTitleLabel)
        noteTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let noteLabel = UILabel()
        noteLabel.font = UIFont.systemFont(ofSize: 10)
        noteLabel.numberOfLines = 0
        noteLabel.text = (auction.notes)!
        noteView.addSubview(noteLabel)
        noteLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            noteView.topAnchor.constraint(equalTo: anchor, constant: 20),
            noteView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 20),
            noteView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -60),
            noteView.heightAnchor.constraint(equalToConstant: 80),
            noteTitleLabel.topAnchor.constraint(equalTo: anchor, constant: 20),
            noteTitleLabel.leadingAnchor.constraint(equalTo: noteView.leadingAnchor, constant: 0),
            noteLabel.topAnchor.constraint(equalTo: noteTitleLabel.bottomAnchor, constant: 8),
            noteLabel.leadingAnchor.constraint(equalTo: noteView.leadingAnchor, constant: 0),
            //noteLabel.trailingAnchor.constraint(equalTo: noteView.trailingAnchor, constant: -10)
        ])
        
        return noteLabel.bottomAnchor
    }
    
    func setRates(_ data: [Bid]) {
        let rateStackView = UIStackView()
        rateStackView.axis = .vertical
        rateStackView.distribution = .fill
        rateStackView.alignment = .fill
        
        for dt in data {
            let rateView = UIView()
            rateView.backgroundColor = UIColorFromHex(rgbValue: 0xfee2e1)
            
            let titleFont = UIFont.boldSystemFont(ofSize: 12)
            let contentFont = UIFont.systemFont(ofSize: 12)
            
            let statusTitle = UILabel()
            statusTitle.text = "Status"
            statusTitle.font = titleFont
            statusTitle.translatesAutoresizingMaskIntoConstraints = false
            rateView.addSubview(statusTitle)
            let status = UILabel()
            status.text = dt.status
            status.font = contentFont
            status.translatesAutoresizingMaskIntoConstraints = false
            rateView.addSubview(status)
            
            let tenorTitle = UILabel()
            tenorTitle.text = "Tenor"
            tenorTitle.font = titleFont
            tenorTitle.translatesAutoresizingMaskIntoConstraints = false
            rateView.addSubview(tenorTitle)
            let tenor = UILabel()
            tenor.text = dt.tenor
            tenor.font = contentFont
            tenor.translatesAutoresizingMaskIntoConstraints = false
            rateView.addSubview(tenor)
            
            let interestRateTitle = UILabel()
            interestRateTitle.text = "Interest Rate (%)"
            interestRateTitle.font = titleFont
            interestRateTitle.translatesAutoresizingMaskIntoConstraints = false
            rateView.addSubview(interestRateTitle)
            let interestRate = UILabel()
            interestRate.text = """
            (IDR) \(dt.interest_rate_idr!)
            (Sharia) \(dt.interest_rate_sharia!)
            """
            interestRate.font = contentFont
            interestRate.translatesAutoresizingMaskIntoConstraints = false
            rateView.addSubview(interestRate)
            
            NSLayoutConstraint.activate([
                statusTitle.leadingAnchor.constraint(equalTo: rateView.leadingAnchor, constant: 20),
                statusTitle.topAnchor.constraint(equalTo: rateView.topAnchor, constant: 20),
                statusTitle.heightAnchor.constraint(equalToConstant: 14),
                status.leadingAnchor.constraint(equalTo: rateView.leadingAnchor, constant: 130),
                status.topAnchor.constraint(equalTo: rateView.topAnchor, constant: 20),
                status.heightAnchor.constraint(equalToConstant: 14),
                
                tenorTitle.leadingAnchor.constraint(equalTo: rateView.leadingAnchor, constant: 20),
                tenorTitle.topAnchor.constraint(equalTo: statusTitle.bottomAnchor, constant: 10),
                tenorTitle.heightAnchor.constraint(equalToConstant: 14),
                tenor.leadingAnchor.constraint(equalTo: rateView.leadingAnchor, constant: 130),
                tenor.topAnchor.constraint(equalTo: status.bottomAnchor, constant: 10),
                tenor.heightAnchor.constraint(equalToConstant: 14),
                
                interestRateTitle.leadingAnchor.constraint(equalTo: rateView.leadingAnchor, constant: 20),
                interestRateTitle.topAnchor.constraint(equalTo: tenorTitle.bottomAnchor, constant: 10),
                interestRateTitle.heightAnchor.constraint(equalToConstant: 14),
                interestRate.leadingAnchor.constraint(equalTo: rateView.leadingAnchor, constant: 130),
                interestRate.topAnchor.constraint(equalTo: tenor.bottomAnchor, constant: 10),

            ])
            
            rateStackView.addArrangedSubview(rateView)
            //rateStackViewHeight.constant += 100
            //rateViewHeight.constant += 100
        }
        
        rateStackView.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(rateStackView)
        
        NSLayoutConstraint.activate([
            rateStackView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            rateStackView.topAnchor.constraint(equalTo: mainView.topAnchor),
            rateStackView.heightAnchor.constraint(equalToConstant: CGFloat(80 * data.count)),
        ])
    }
    
    func setContent() {
        //setStatus("ACC")
        //setType("AUCTION")
        /*let portfolio = setPortfolio([
            Detail(title: "Fund Name", content: "ABF (RD ABF INDONESIA BOND INDEX FUND)"),
            Detail(title: "Investment (BIO)", content: "IDR 1 - 2.5"),
            Detail(title: "Placement Date", content: "10 Jan 20"),
            Detail(title: "Custodian Bank", content:  "-"),
            Detail(title: "PIC Custodian", content: "-")
        ])
        let detail = setDetail([
            Detail(title: "Tenor", content: "3 months"),
            Detail(title: "Previous Interest Rate (%)", content: "7.75%"),
            Detail(title: "New Interest Rate (%)", content: "8.00%"),
            Detail(title: "Investment (BIO)", content: "IDR 50"),
            Detail(title: "Previous Period", content: "10 Oct 19 - 10 Jan 20"),
            Detail(title: "New Period", content: "10 Jan 20 - 10 Apr 20"),
        ], portfolio)
        
        let notes = setNotes((auction.notes)!, detail)*/
        
        setRates([
            Bid(id: 1, status: "Pending", tenor: "3 months", interest_rate_idr: "2%", interest_rate_usd: nil, interest_rate_sharia: "2%"),
            Bid(id: 2, status: "Pending", tenor: "6 months", interest_rate_idr: "2%", interest_rate_usd: nil, interest_rate_sharia: "2%")
        ])
        
        /*
        typeLabel.text = "NORMAL AUCTION"
        if auction.type == "AUCTION" {
            detailLabel.isHidden = true
            detailView.isHidden = true
            noteViewTop.constant -= 30
        }
        endLabel.text = "Ends Bid in: 1 hour 43 mins"
        noteView.backgroundColor = backgroundColor
        
        setPortfolio([
            "Fund Name": "ABF (RD ABF INDONESIA BOND INDEX FUND)",
            "Investment (BIO)": "IDR 1 - 2.5",
            "Placement Date": "10 Jan 20",
            "Custodian Bank": "-",
            "PIC Custodian": "-"
        ])
        setNotes()
        setRates([
            Bid(id: 1, status: "Pending", tenor: "3 months", interest_rate_idr: "2%", interest_rate_usd: nil, interest_rate_sharia: "2%"),
            Bid(id: 2, status: "Pending", tenor: "6 months", interest_rate_idr: "2%", interest_rate_usd: nil, interest_rate_sharia: "2%")
        ])
        */
    }
    */
    
    /*
    func setPortfolio(_ data: [String:String]) {
        data.forEach {
            let portfolio = UIView()
            
            let titleFont = UIFont.boldSystemFont(ofSize: 10)
            let titleColor = titleLabelColor
            let contentFont = UIFont.boldSystemFont(ofSize: 14)
            
            let titleLabel = UILabel()
            titleLabel.font = titleFont
            titleLabel.textColor = titleColor
            titleLabel.text = $0
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            portfolio.addSubview(titleLabel)
            let contentLabel = UILabel()
            contentLabel.text = $1
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
            
            portfolioStackView.addArrangedSubview(portfolio)
            portfolioViewHeight.constant += CGFloat(30)
        }
    }
    
    func setRates(_ data: [Bid]) {
        for dt in data {
            let rateView = UIView()
            rateView.backgroundColor = .white
            
            let titleFont = UIFont.boldSystemFont(ofSize: 12)
            let contentFont = UIFont.systemFont(ofSize: 12)
            
            let statusTitle = UILabel()
            statusTitle.text = "Status"
            statusTitle.font = titleFont
            statusTitle.translatesAutoresizingMaskIntoConstraints = false
            rateView.addSubview(statusTitle)
            let status = UILabel()
            status.text = dt.status
            status.font = contentFont
            status.translatesAutoresizingMaskIntoConstraints = false
            rateView.addSubview(status)
            
            let tenorTitle = UILabel()
            tenorTitle.text = "Tenor"
            tenorTitle.font = titleFont
            tenorTitle.translatesAutoresizingMaskIntoConstraints = false
            rateView.addSubview(tenorTitle)
            let tenor = UILabel()
            tenor.text = dt.tenor
            tenor.font = contentFont
            tenor.translatesAutoresizingMaskIntoConstraints = false
            rateView.addSubview(tenor)
            
            let interestRateTitle = UILabel()
            interestRateTitle.text = "Interest Rate (%)"
            interestRateTitle.font = titleFont
            interestRateTitle.translatesAutoresizingMaskIntoConstraints = false
            rateView.addSubview(interestRateTitle)
            let interestRate = UILabel()
            interestRate.text = """
            (IDR) \(dt.interest_rate_idr!)
            (Sharia) \(dt.interest_rate_sharia!)
            """
            interestRate.font = contentFont
            interestRate.translatesAutoresizingMaskIntoConstraints = false
            rateView.addSubview(interestRate)
            
            NSLayoutConstraint.activate([
                statusTitle.leadingAnchor.constraint(equalTo: rateView.leadingAnchor, constant: 20),
                statusTitle.topAnchor.constraint(equalTo: rateView.topAnchor, constant: 20),
                statusTitle.heightAnchor.constraint(equalToConstant: 14),
                status.leadingAnchor.constraint(equalTo: rateView.leadingAnchor, constant: 130),
                status.topAnchor.constraint(equalTo: rateView.topAnchor, constant: 20),
                status.heightAnchor.constraint(equalToConstant: 14),
                
                tenorTitle.leadingAnchor.constraint(equalTo: rateView.leadingAnchor, constant: 20),
                tenorTitle.topAnchor.constraint(equalTo: statusTitle.bottomAnchor, constant: 10),
                tenorTitle.heightAnchor.constraint(equalToConstant: 14),
                tenor.leadingAnchor.constraint(equalTo: rateView.leadingAnchor, constant: 130),
                tenor.topAnchor.constraint(equalTo: status.bottomAnchor, constant: 10),
                tenor.heightAnchor.constraint(equalToConstant: 14),
                
                interestRateTitle.leadingAnchor.constraint(equalTo: rateView.leadingAnchor, constant: 20),
                interestRateTitle.topAnchor.constraint(equalTo: tenorTitle.bottomAnchor, constant: 10),
                interestRateTitle.heightAnchor.constraint(equalToConstant: 14),
                interestRate.leadingAnchor.constraint(equalTo: rateView.leadingAnchor, constant: 130),
                interestRate.topAnchor.constraint(equalTo: tenor.bottomAnchor, constant: 10),

            ])
            
            rateStackView.addArrangedSubview(rateView)
            rateStackViewHeight.constant += 100
            //rateViewHeight.constant += 100
        }
    }
    */
    
    /*
    func setRates2(_ data: [String]) {
        let test = UIView()
        let subStackView = UIStackView()
        subStackView.axis = .vertical
        subStackView.alignment = .fill
        subStackView.distribution = .fill
        
        let titleFont = UIFont.boldSystemFont(ofSize: 12)
        let contentFont = UIFont.systemFont(ofSize: 12)
        
        test.addSubview(subStackView)
        mainStackView.addArrangedSubview(test)
        
        for dt in data {
            let mainView = UIView()
            //mainView.backgroundColor = backgroundColor
            mainView.backgroundColor = .red
            mainView.translatesAutoresizingMaskIntoConstraints = false
            
            let subView = UIView()
            subView.backgroundColor = .white
            subView.layer.cornerRadius = 3
            subView.layer.borderColor = UIColor.black.cgColor
            subView.layer.borderWidth = 1
            subView.translatesAutoresizingMaskIntoConstraints = false
            mainView.addSubview(subView)
            
            let statusTitle = UILabel()
            statusTitle.text = "Status"
            statusTitle.font = titleFont
            statusTitle.translatesAutoresizingMaskIntoConstraints = false
            subView.addSubview(statusTitle)
            let status = UILabel()
            status.text = "Pending"
            status.font = contentFont
            status.translatesAutoresizingMaskIntoConstraints = false
            subView.addSubview(status)
            
            let tenorTitle = UILabel()
            tenorTitle.text = "Tenor"
            tenorTitle.font = titleFont
            tenorTitle.translatesAutoresizingMaskIntoConstraints = false
            subView.addSubview(tenorTitle)
            let tenor = UILabel()
            //tenor.text = "3 months"
            tenor.text = dt
            tenor.font = contentFont
            tenor.translatesAutoresizingMaskIntoConstraints = false
            subView.addSubview(tenor)
            
            let interestRateTitle = UILabel()
            interestRateTitle.text = "Interest Rate (%)"
            interestRateTitle.font = titleFont
            interestRateTitle.translatesAutoresizingMaskIntoConstraints = false
            subView.addSubview(interestRateTitle)
            let interestRate = UILabel()
            interestRate.numberOfLines = 0
            interestRate.text = """
            (IDR) 2%
            (Syariah) 2%
            """
            interestRate.font = contentFont
            interestRate.translatesAutoresizingMaskIntoConstraints = false
            subView.addSubview(interestRate)
            
            subStackView.addArrangedSubview(mainView)
            
            NSLayoutConstraint.activate([
                mainView.leadingAnchor.constraint(equalTo: subStackView.leadingAnchor, constant: 0),
                mainView.heightAnchor.constraint(equalToConstant: 200),
                mainView.widthAnchor.constraint(equalToConstant: 200),
                subView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 0),
                subView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: 0),
                subView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 0),
                subView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -8),
                statusTitle.leadingAnchor.constraint(equalTo: subView.leadingAnchor, constant: 8),
                statusTitle.topAnchor.constraint(equalTo: subView.topAnchor, constant: 20),
                //statusTitle.heightAnchor.constraint(equalToConstant: 14),
                status.leadingAnchor.constraint(equalTo: subView.leadingAnchor, constant: 120),
                status.topAnchor.constraint(equalTo: subView.topAnchor, constant: 20),
                //status.heightAnchor.constraint(equalToConstant: 14),
                
                tenorTitle.leadingAnchor.constraint(equalTo: subView.leadingAnchor, constant: 8),
                tenorTitle.topAnchor.constraint(equalTo: statusTitle.bottomAnchor, constant: 10),
                //tenorTitle.heightAnchor.constraint(equalToConstant: 14),
                tenor.leadingAnchor.constraint(equalTo: subView.leadingAnchor, constant: 120),
                tenor.topAnchor.constraint(equalTo: status.bottomAnchor, constant: 10),
                //tenor.heightAnchor.constraint(equalToConstant: 14),
                
                interestRateTitle.leadingAnchor.constraint(equalTo: subView.leadingAnchor, constant: 8),
                interestRateTitle.topAnchor.constraint(equalTo: tenorTitle.bottomAnchor, constant: 10),
                interestRate.leadingAnchor.constraint(equalTo: subView.leadingAnchor, constant: 120),
                interestRate.topAnchor.constraint(equalTo: tenor.bottomAnchor, constant: 10),
            ])
        }
        
        subStackView.translatesAutoresizingMaskIntoConstraints = false
        test.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            subStackView.topAnchor.constraint(equalTo: test.topAnchor, constant: 0),
            subStackView.bottomAnchor.constraint(equalTo: test.bottomAnchor, constant: 0),
            subStackView.leadingAnchor.constraint(equalTo: test.leadingAnchor, constant: 0),
            subStackView.trailingAnchor.constraint(equalTo: test.trailingAnchor, constant: 0),
            test.topAnchor.constraint(equalTo: mainStackView.topAnchor, constant: 0),
            test.bottomAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: 0),
            test.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 0),
            test.heightAnchor.constraint(equalToConstant: 200)
        ])
    }*/
}

extension AuctionDetailViewController: AuctionDetailDelegate {
    //
}
