//
//  AuctionListTableViewCell.swift
//  Bahana
//
//  Created by Christian Chandra on /2002/09.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import UIKit

class AuctionListTableViewCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var typeView: UIView!
    @IBOutlet weak var typeViewWidth: NSLayoutConstraint!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusViewWidth: NSLayoutConstraint!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var fundNameTitleLabel: UILabel!
    @IBOutlet weak var fundNameLabel: UILabel!
    @IBOutlet weak var investmentTitleLabel: UILabel!
    @IBOutlet weak var investmentLabel: UILabel!
    @IBOutlet weak var placementDateTitleLabel: UILabel!
    @IBOutlet weak var placementDateLabel: UILabel!
    @IBOutlet weak var tenorTitleLabel: UILabel!
    @IBOutlet weak var tenorLabel: UILabel!
    @IBOutlet weak var endTitleLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var breakDateTitleLabel: UILabel!
    @IBOutlet weak var breakDateLabel: UILabel!
    @IBOutlet weak var constraintHeight: NSLayoutConstraint!
    @IBOutlet weak var breakConstraintHeight: NSLayoutConstraint!
    @IBOutlet weak var fundStack: UIStackView!
    @IBOutlet weak var breakStack: UIStackView!
    
    var pageType: String!
    var alreadySet: Bool = false
    
    var auction: Auction!
    var serverHourDifference = Int()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = backgroundColor
        self.selectionStyle = .none
        
        mainView.layer.cornerRadius = 5
        mainView.layer.shadowColor = UIColor.gray.cgColor
        mainView.layer.shadowOffset = CGSize(width: 0, height: 0)
        mainView.layer.shadowRadius = 4
        mainView.layer.shadowOpacity = 0.5
        
        //typeView.layer.cornerRadius = 3
        typeLabel.font = UIFont.boldSystemFont(ofSize: 12)
        statusView.layer.cornerRadius = 5
        statusLabel.font = UIFont.boldSystemFont(ofSize: 12)
        
        let titleFont = UIFont.systemFont(ofSize: 11)
        let titleColor = titleLabelColor
        let contentFont = UIFont.boldSystemFont(ofSize: 12)
            
        fundNameTitleLabel.font = titleFont
        fundNameTitleLabel.textColor = titleColor
        fundNameTitleLabel.text = localize("fund_name")
        fundNameLabel.font = contentFont
        investmentTitleLabel.font = titleFont
        investmentTitleLabel.textColor = titleColor
        investmentTitleLabel.text = localize("investment")
        investmentLabel.font = contentFont
        placementDateTitleLabel.font = titleFont
        placementDateTitleLabel.textColor = titleColor
        placementDateTitleLabel.text = localize("placement_date")
        placementDateLabel.font = contentFont
        tenorTitleLabel.font = titleFont
        tenorTitleLabel.textColor = titleColor
        tenorTitleLabel.text = localize("tenor")
        tenorLabel.font = contentFont
        endTitleLabel.font = titleFont
        endTitleLabel.textColor = titleColor
        endTitleLabel.text = localize("ends_in")
        endLabel.font = contentFont
        breakDateTitleLabel.text = localize("break_date")
        breakDateTitleLabel.font = titleFont
        breakDateTitleLabel.textColor = titleColor
        breakDateTitleLabel.isHidden = true
        breakDateLabel.font = contentFont
        breakDateLabel.isHidden = true
        
        typeView.layer.borderWidth = 1
        typeView.layer.borderColor = primaryColor.cgColor
        typeLabel.textColor = primaryColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setAuction(_ auction: Auction, _ hourDifference: Int) {
        self.auction = auction
        self.serverHourDifference = hourDifference
        
        endTitleLabel.isHidden = false
        endLabel.isHidden = false
        
        if pageType == "history" || auction.type != "break" || auction.type == "mature" || auction.type == "mature-multifund" {
            endTitleLabel.isHidden = true
            endLabel.isHidden = true
        }
        
        fundNameLabel.text = auction.portfolio_short
        setAuctionType(auction.type)
        setStatus(auction.status)
        
        
        tenorLabel.text = auction.period
        
        var investment = "IDR \(toIdrBio(auction.investment_range_start))"
        if auction.investment_range_end > 0 {
            investment += " - \(toIdrBio(auction.investment_range_end))"
        }
        investmentLabel.text = investment
        
        if auction.type == "break" {
            if auction.maturity_date != nil {
                placementDateLabel.text = convertDateToString(convertStringToDatetime(auction.maturity_date!)!)
            }
            
            if pageType == "auction" {
                endLabel.text = convertDateToString(convertStringToDatetime(auction.end_date)!)
            } else if pageType == "history" {
                endLabel.text = convertDateToString(convertStringToDatetime(auction.break_maturity_date)!)
            }
        } else if auction.type == "mature" || auction.type == "mature-multifund" {
            placementDateLabel.text = convertDateToString(convertStringToDatetime(auction.maturity_date)!)
        } else {
            if auction.type == "rollover-multifund"{
                placementDateLabel.text = convertDateToString(convertStringToDatetime(auction.maturity_date)!)
            }else{
                placementDateLabel.text = convertDateToString(convertStringToDatetime(auction.end_date)!)
            }
            
            countdown()
            
            Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countdown), userInfo: nil, repeats: true)
        }
    }
    
    func setTransaction(_ transaction: Transaction) {
        placementDateTitleLabel.text = localize("issue_date")
        endTitleLabel.text = localize("maturity_date")
        
        // Transaction type
        var title = String()
        var backgroundColor: UIColor!
        switch transaction.status {
        case "Active":
            title = localize("active")
            backgroundColor = greenColor
            breakDateTitleLabel.isHidden = true
            breakDateLabel.isHidden = true
        case "Break":
            title = localize("break")
            backgroundColor = primaryColor
            breakDateTitleLabel.isHidden = false
            breakDateLabel.isHidden = false
            breakDateLabel.text = convertDateToString(convertStringToDatetime(transaction.break_maturity_date)!)
        case "Mature":
            title = localize("mature")
            backgroundColor = blueColor
            breakDateTitleLabel.isHidden = true
            breakDateLabel.isHidden = true
        case "Rollover":
            title = localize("rollover")
            backgroundColor = accentColor
            breakDateTitleLabel.isHidden = true
            breakDateLabel.isHidden = true
        case "Canceled":
            title = localize("canceled")
            backgroundColor = darkGreyColor
            breakDateTitleLabel.isHidden = true
            breakDateLabel.isHidden = true
        case "Used in RO Auction":
            title = localize("used_in_ro_auction")
            backgroundColor = darkYellowColor
            breakDateTitleLabel.isHidden = true
            breakDateLabel.isHidden = true
        case "Used in Break Auction":
            title = localize("used_in_break_auction")
            backgroundColor = darkRedColor
            breakDateTitleLabel.isHidden = true
            breakDateLabel.isHidden = true
        case "Used in Mature NCM Auction":
            title = localize("used_in_mature_ncm_auction")
            backgroundColor = darkYellowColor
            breakDateTitleLabel.isHidden = true
            breakDateLabel.isHidden = true
        case "Used in Break NCM Auction":
            title = localize("used_in_break_ncm_auction")
            backgroundColor = darkYellowColor
            breakDateTitleLabel.isHidden = true
            breakDateLabel.isHidden = true
        case "Used in RO Multifund Auction":
            title = localize("used_in_ro_multifund_auction")
            backgroundColor = darkYellowColor
            breakDateTitleLabel.isHidden = true
            breakDateLabel.isHidden = true
        case "Multifund Rollover":
            title = localize("multifund_rollover")
            backgroundColor = yellowColor
            breakDateTitleLabel.isHidden = true
            breakDateLabel.isHidden = true
        default:
            break
        }
        typeLabel.text = title.uppercased()
        
        let typeTextWidth = typeLabel.intrinsicContentSize.width
        typeViewWidth.constant = typeTextWidth + 10
        typeLabel.textColor = .white
        typeView.layer.borderWidth = 0
        
        typeView.backgroundColor = backgroundColor
        
        setStatus("-")
        fundNameLabel.text = transaction.portfolio
        investmentLabel.text = "IDR \(toIdrBio(transaction.quantity))"
        tenorLabel.text = transaction.period
        placementDateLabel.text = convertDateToString(convertStringToDatetime(transaction.issue_date)!)
        endLabel.text = convertDateToString(convertStringToDatetime(transaction.maturity_date)!)
    }
    
    func setStatus(_ status: String) {
        //if !alreadySet {
            if status != "-" {
                statusView.isHidden = false
                
                statusLabel.text = status
                let statusTextWidth = statusLabel.intrinsicContentSize.width
                statusViewWidth.constant = statusTextWidth + 10
            } else {
                statusView.isHidden = true
            }
            
            //alreadySet = true
        //}
    }
    
    func setAuctionType(_ type: String) {
        mainView.backgroundColor = UIColor.white
    
        var title = String()
        switch type {
        case "auction":
            title = localize("auction")
            placementDateTitleLabel.text = localize("placement_date")
            endTitleLabel.text = localize("ends_in")
        case "direct-auction":
            title = localize("direct_auction")
            placementDateTitleLabel.text = localize("placement_date")
            endTitleLabel.text = localize("ends_in")
        case "break":
            title = localize("break")
            placementDateTitleLabel.text = localize("maturity_date")
            endTitleLabel.text = localize("break_date")
            endLabel.textColor = .black
        case "rollover":
            title = localize("rollover")
            placementDateTitleLabel.text = localize("maturity_date")
            endTitleLabel.text = localize("ends_in")
        case "mature":
            title = localize("mature")
            mainView.backgroundColor = lightRedColor
            break
        case "mature-ncm-auction":
            title = localize("mature_no_cash_movement")
            placementDateLabel.text = localize("placement_date")
            endTitleLabel.text = localize("ends_in")
            break
        case "break-ncm-auction":
            title = localize("break_no_cash_movement")
            placementDateLabel.text = localize("placement_date")
            endTitleLabel.text = localize("ends_in")
            break
        case "multifund-auction":
            title = localize("multifund-auction")
            placementDateLabel.text = localize("placement_date")
            endTitleLabel.text = localize("ends_in")
            fundNameTitleLabel.text = "-"
            fundNameLabel.text = "-"
            fundStack.isHidden = true
            breakStack.isHidden = true
            break
        case "rollover-multifund":
            title = localize("multifund_rollover_")
            placementDateTitleLabel.text = localize("maturity_date")
            endTitleLabel.text = localize("ends_in")
            fundNameTitleLabel.text = "-"
            fundNameLabel.text = "-"
            fundStack.isHidden = true
            breakStack.isHidden = true
            break
        case "mature-multifund":
            title = localize("multifund_mature")
            mainView.backgroundColor = lightRedColor
            fundNameTitleLabel.text = "-"
            fundNameLabel.text = "-"
            fundStack.isHidden = true
            breakStack.isHidden = true
            break
        default:
            break
        }
        typeLabel.text = title.uppercased()
        
        let typeTextWidth = typeLabel.intrinsicContentSize.width
        typeViewWidth.constant = typeTextWidth + 10
    }
    
    @objc func countdown() {
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .hour, value: -serverHourDifference, to: Date())!
        
        // Kalau auction sudah selesai dan bukan mature, background jadi abu-abu
        if auction.maturity_date != nil && auction.type != "break" {
            // jika maturity date tidak kosong dan tipe auction bukan break
            if auction.type != "mature" {
                endTitleLabel.isHidden = false
                endLabel.isHidden = false
            }
            let endBid = calculateDateDifference(date, convertStringToDatetime(auction.maturity_date!)!)
            
            if endBid["hour"]! > 0 || endBid["minute"]! > 0 {
                let hour = endBid["hour"]! > 1 ? String.localizedStringWithFormat(localize("hours"), "\(endBid["hour"]!)") : String.localizedStringWithFormat(localize("hour"), "\(endBid["hour"]!)")
                let minute = endBid["minute"]! > 1 ? String.localizedStringWithFormat(localize("minutes"), "\(endBid["minute"]!)") : String.localizedStringWithFormat(localize("minute"), "\(endBid["minute"]!)")
                endLabel.text = "\(hour) \(minute)"
                if endBid["hour"]! == 0 {
                    endLabel.textColor = primaryColor
                }
            } else {
                let endAuction = calculateDateDifference(date, convertStringToDatetime(auction.end_date)!)
                
                if endAuction["hour"]! > 0 || endAuction["minute"]! > 0 {
                    let hour = endAuction["hour"]! > 1 ? String.localizedStringWithFormat(localize("hours"), "\(endAuction["hour"]!)") : String.localizedStringWithFormat(localize("hour"), "\(endAuction["hour"]!)")
                    let minute = endAuction["minute"]! > 1 ? String.localizedStringWithFormat(localize("minutes"), "\(endAuction["minute"]!)") : String.localizedStringWithFormat(localize("minute"), "\(endAuction["minute"]!)")
                    endLabel.text = "\(hour) \(minute)"
                    
                    if endAuction["hour"]! == 0 {
                        endLabel.textColor = primaryColor
                    }
                } else {
                    endTitleLabel.isHidden = true
                    endLabel.text = ""
                    if pageType != "history"{
                        mainView.backgroundColor = lightGreyColor
                    }
                }
            }
        } else if auction.type == "mature-ncm-auction" || auction.type == "break-ncm-auction" || auction.type == "multifund-auction" {
            endTitleLabel.isHidden = false
            endLabel.isHidden = false
            let endAuction = calculateDateDifference(date, convertStringToDatetime(auction.end_date)!)
            if endAuction["hour"]! > 0 || endAuction["minute"]! > 0 {
                let hour = endAuction["hour"]! > 1 ? String.localizedStringWithFormat(localize("hours"), "\(endAuction["hour"]!)") : String.localizedStringWithFormat(localize("hour"), "\(endAuction["hour"]!)")
                let minute = endAuction["minute"]! > 1 ? String.localizedStringWithFormat(localize("minutes"), "\(endAuction["minute"]!)") : String.localizedStringWithFormat(localize("minute"), "\(endAuction["minute"]!)")
                endLabel.text = "\(hour) \(minute)"
                
                if endAuction["hour"]! == 0 {
                    endLabel.textColor = primaryColor
                }
            } else {
                 // jika waktu bidder telah habis
                if pageType != "history"{
                    // jika berada pada halaman auction/transaction
                    endTitleLabel.isHidden = true
                    endLabel.text = ""
                    mainView.backgroundColor = lightGreyColor
                }else{
                    endTitleLabel.isHidden = true
                    endLabel.isHidden = true
                }
            }
            /*
            if pageType == "auction" {
                endLabel.text = convertDateToString(convertStringToDatetime(auction.end_date)!)
            }
             */
        } else {
            endTitleLabel.isHidden = true
            endLabel.text = ""
            if pageType == "auction" && auction.type != "mature" {
                mainView.backgroundColor = lightGreyColor
            }
        }
    }
}
