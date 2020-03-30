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
    @IBOutlet weak var rightView: UIView!
    
    var pageType: String!
    var alreadySet: Bool = false
    
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
        
        typeView.layer.cornerRadius = 3
        typeLabel.font = UIFont.boldSystemFont(ofSize: 12)
        statusView.layer.cornerRadius = 5
        statusLabel.font = UIFont.boldSystemFont(ofSize: 12)
        
        let titleFont = UIFont.systemFont(ofSize: 10)
        let titleColor = titleLabelColor
        let contentFont = UIFont.boldSystemFont(ofSize: 14)
            
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
        
        typeView.layer.borderWidth = 1
        typeView.layer.borderColor = primaryColor.cgColor
        typeLabel.textColor = primaryColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setAuction(_ auction: Auction) {
        if pageType == "history" {
            endTitleLabel.isHidden = true
            endLabel.isHidden = true
        }
        
        setAuctionType(auction.type)
        setStatus(auction.status)
        fundNameLabel.text = auction.portfolio_short
        tenorLabel.text = auction.period
        if auction.investment_range_end > 0 {
            investmentLabel.text = "IDR \(toIdrBio(auction.investment_range_start)) - \(toIdrBio(auction.investment_range_end))"
            
        } else {
           investmentLabel.text = "IDR \(toIdrBio(auction.investment_range_start))"
        }
        
        if auction.type == "auction" || auction.type == "direct auction" {
            
        } else {
            
        }
        
        if auction.type == "break" {
            if auction.maturity_date != nil {
                placementDateLabel.text = convertDateToString(convertStringToDatetime(auction.maturity_date!)!)
            }
            
            endLabel.text = convertDateToString(convertStringToDatetime(auction.start_date)!)
        } else {
            if pageType == "auction" {
                placementDateLabel.text = convertDateToString(convertStringToDatetime(auction.start_date)!)
            } else if pageType == "history" {
                placementDateLabel.text = convertDateToString(convertStringToDatetime(auction.end_date)!)
            }
            
            let countdown = calculateDateDifference(Date(), convertStringToDatetime(auction.end_date)!)
            if countdown["hour"]! > 0 {
                let hour = countdown["hour"]! > 1 ? "\(countdown["hour"]!) hours" : "\(countdown["hour"]!) hour"
                let minute = countdown["minute"]! > 1 ? "\(countdown["minute"]!) minutes" : "\(countdown["minute"]!) minute"
                endLabel.text = "\(hour) \(minute)"
            } else {
                endLabel.text = ""
            }
        }
    }
    
    func setTransaction(_ transaction: Transaction) {
        placementDateTitleLabel.text = localize("issue_date")
        endTitleLabel.text = localize("maturity_date")
        
        // Transaction type
        typeLabel.text = transaction.status.uppercased()
        let typeTextWidth = typeLabel.intrinsicContentSize.width
        typeViewWidth.constant = typeTextWidth + 10
        typeLabel.textColor = .white
        typeView.layer.borderWidth = 0
        switch transaction.status {
        case "Active":
            typeView.backgroundColor = UIColorFromHex(rgbValue: 0x65d663)
        case "Canceled":
            typeView.backgroundColor = UIColorFromHex(rgbValue: 0x3e3e3e)
        case "Used in Break Auction":
            typeView.backgroundColor = UIColorFromHex(rgbValue: 0x990000)
        case "Mature":
            typeView.backgroundColor = UIColorFromHex(rgbValue: 0x2d91ff)
        default:
            break
        }
        
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
                statusLabel.text = status
            } else if status == "ACC" {
                statusLabel.text = status
            } else {
                statusView.isHidden = true
            }
            
            //alreadySet = true
        //}
    }
    
    func setAuctionType(_ type: String) {
        //if !alreadySet {
            typeLabel.text = type.uppercased()
            let typeTextWidth = typeLabel.intrinsicContentSize.width
            typeViewWidth.constant = typeTextWidth + 10
        
            mainView.backgroundColor = UIColor.white
            typeView.backgroundColor = UIColor.white
            leftView.backgroundColor = UIColor.white
            rightView.backgroundColor = UIColor.white
        
            switch type {
            case "break":
                placementDateTitleLabel.text = localize("maturity_date")
                endTitleLabel.text = localize("break_date")
            case "rollover":
                placementDateTitleLabel.text = localize("maturity_date")
            case "mature":
                mainView.backgroundColor = UIColorFromHex(rgbValue: 0xffe0e0)
                typeView.backgroundColor = UIColorFromHex(rgbValue: 0xffe0e0)
                leftView.backgroundColor = UIColorFromHex(rgbValue: 0xffe0e0)
                rightView.backgroundColor = UIColorFromHex(rgbValue: 0xffe0e0)
                break
            default:
                break
            }
            
            //alreadySet = true
        //}
    }
}
