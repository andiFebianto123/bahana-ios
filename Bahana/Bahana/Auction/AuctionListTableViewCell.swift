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
        
        let titleFont = UIFont.boldSystemFont(ofSize: 10)
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
    
    func isTransaction() {
        placementDateTitleLabel.text = localize("issue_date")
        endTitleLabel.text = localize("maturity_date")
    }
    
    func setStatus(_ status: String) {
        if status != "-" {
            statusLabel.text = status
        } else if status == "ACC" {
            statusLabel.text = status
            mainView.backgroundColor = UIColorFromHex(rgbValue: 0xffe0e0)
            typeView.backgroundColor = UIColorFromHex(rgbValue: 0xffe0e0)
            leftView.backgroundColor = UIColorFromHex(rgbValue: 0xffe0e0)
            rightView.backgroundColor = UIColorFromHex(rgbValue: 0xffe0e0)
        } else {
            statusView.isHidden = true
        }
    }
    
    func setAuctionType(_ type: String) {
        typeLabel.text = type.uppercased()
        let typeTextWidth = typeLabel.intrinsicContentSize.width
        typeViewWidth.constant = typeTextWidth + 10
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
        default:
            break
        }
    }
    
    func setTransactionType(_ type: String) {
        typeLabel.text = type.uppercased()
        let typeTextWidth = typeLabel.intrinsicContentSize.width
        typeViewWidth.constant = typeTextWidth + 10
        typeLabel.textColor = .white
        typeView.layer.borderWidth = 0
        switch type {
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
    }
}
