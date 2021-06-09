//
//  AuctionMultifoundConfirmationViewController.swift
//  Bahana
//
//  Created by RECTmedia MD102 on 07/05/21.
//  Copyright © 2021 Rectmedia. All rights reserved.
//

import UIKit

class AuctionMultifoundConfirmationViewController: UIViewController {
    @IBOutlet weak var navigationView: UIView! // untuk box navigasi
    @IBOutlet weak var navigationViewHeight: NSLayoutConstraint! // untuk navigation heigth constraint
    @IBOutlet weak var closeView: UIView! // tombol close view
    @IBOutlet weak var navigationTitle: UILabel! // judul navigation
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var AuctionStackPlacementView: UIStackView!
    // string label
    @IBOutlet weak var tenorLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var totalSelectedLabel: UILabel!
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var btnCheckAll: UIButton!
    
    @IBOutlet weak var viewButton: UIView!
    @IBOutlet weak var viewSelectAll: UIView!
    @IBOutlet weak var viewBatasBawah: UIView!
    
    @IBOutlet weak var winnerDetailTitleLabel: UILabel!
    @IBOutlet weak var tenorTitleLabel: UILabel!
    @IBOutlet weak var rateTitleLabel: UILabel!
    @IBOutlet weak var totalSelectedTitleLabel: UILabel!
    @IBOutlet weak var approvedBtn: UIButton!
    @IBOutlet weak var declinedBtn: UIButton!
    
    var checkBtnTrigger:Bool = false
    
    
    var loadingView = UIView()
    
    var id = Int()
    var bidId: Int!
    
    var presenter: AuctionMultifoundConfirmationViewPresenter!
    var data: DetailBidder!
    
    var detailPortfolio = [AuctionStackPlacement]()
    
    var needRefresh: Bool = false

    @IBOutlet weak var stackPortfolio: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backgroundColor
        scrollView.backgroundColor = backgroundColor
        scrollView.alwaysBounceHorizontal = false
        
        navigationTitle.text = localize("confirmation").uppercased()
        winnerDetailTitleLabel.text = localize("winner_detail")
        rateTitleLabel.text = localize("rate").uppercased()
        totalSelectedTitleLabel.text = localize("total_selected_bio").uppercased()
        approvedBtn.setTitle(localize("approved").uppercased(), for: .normal)
        declinedBtn.setTitle(localize("declined").uppercased(), for: .normal)
        
        
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
        
        container.layer.cornerRadius = 5
        container.layer.shadowColor = UIColor.gray.cgColor
        container.layer.shadowOffset = CGSize(width:0, height:0)
        container.layer.shadowRadius = 4
        container.layer.shadowOpacity = 0.5
        
        viewBatasBawah.isHidden = true
        closeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goBack)))
        presenter = AuctionMultifoundConfirmationViewPresenter(delegate: self)
        presenter.getDetailBidder(id, bidId)
        
    }
    
    @objc func goBack() {
        if needRefresh {
            NotificationCenter.default.post(name: .refreshAuctionDetail, object: nil, userInfo: nil)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    func showAlert(_ message: String, _ isBackToList: Bool) {
        let alert = UIAlertController(title: localize("information"), message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: localize("ok"), style: .default, handler: { action in
            if isBackToList {
                self.goBack()
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showLoading(_ show: Bool) {
        loadingView.isHidden = !show
    }
    
    
    @IBAction func checkAllPress(_ sender: Any) {
        if checkBtnTrigger {
            // lepas
            checkBtnTrigger = false
            btnCheckAll.setImage(UIImage(named:"unchecked_checkbox"), for: .normal)
            detailPortfolio.forEach { portofolio in
                if !portofolio.checkBoxViewHide {
                    portofolio.unchecked()
                }
            }
        } else {
            // check
            checkBtnTrigger = true
            btnCheckAll.setImage(UIImage(named:"checked_checkbox"), for: .normal)
            detailPortfolio.forEach { portofolio in
                if !portofolio.checkBoxViewHide {
                    portofolio.checked()
                }
            }
        }
    }
    
    func setContent(){
        tenorLabel.text = ": \(self.data.tenor)"
        rateLabel.text = ": \(self.data.rate)%"
        totalSelectedLabel.text = ": \(self.data.total_investment)"
        
        if(self.data.view == 0){
            viewButton.isHidden = true
            viewSelectAll.isHidden = true
            viewBatasBawah.isHidden = false
        }
        
        for portfolio in self.data.detail_portfolio {
            var Portfolio = AuctionStackPlacement()
            Portfolio.id = portfolio.portfolio_id
            Portfolio.portfolioLabel.text = portfolio.portfolio
            Portfolio.fullNameLabel.text = portfolio.description
            Portfolio.custodianLabel.text = portfolio.custodian_bank
            Portfolio.bilyetLabel.text = portfolio.bilyet
            Portfolio.approvedRmLabel.text = portfolio.status
            Portfolio.statusView = self.data.view
            Portfolio.status = portfolio.status
            Portfolio.autoLoad()
            
            detailPortfolio.append(Portfolio)
            stackPortfolio.addArrangedSubview(Portfolio)
        }
        
    }
    
    @IBAction func approvedPressed(_ sender: Any) {
        let is_accepted = "yes"
        showLoading(true)
        presenter.confirmBtn(portfolio_details: detailPortfolio, id_auction:id, id_bidder: bidId, is_accepted)
    }
    
    @IBAction func declinedPressed(_ sender: Any) {
        let is_accepted = "no"
        showLoading(true)
        presenter.confirmBtn(portfolio_details: detailPortfolio, id_auction:id, id_bidder: bidId, is_accepted)
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
extension AuctionMultifoundConfirmationViewController: AuctionMultifundDetailConfirmationDelegate{
    
    func isConfirmed(_ isConfirmed: Bool, _ message: String) {
        showLoading(false)
        if isConfirmed {
            needRefresh = true
        }
        showAlert(message, isConfirmed)
    }
    
    func openLoginPage() {
        let authStoryboard : UIStoryboard = UIStoryboard(name: "Auth", bundle: nil)
        let loginViewController : UIViewController = authStoryboard.instantiateViewController(withIdentifier: "Login") as UIViewController
        self.present(loginViewController, animated: true, completion: nil)
    }
    
    func setData(_ data: DetailBidder) {
        self.data = data
        showLoading(false)
        //print(self.data.view)
        setContent()
    }
    
    func getData() {
        showLoading(false)
    }
    
    func getDataFail(_ message: String?) {
        showLoading(false)
        var alert = UIAlertController(title: localize("information"), message: localize("cannot_connect_to_server"), preferredStyle: .alert)
        if message != nil {
            alert = UIAlertController(title: localize("information"), message: message, preferredStyle: .alert)
        }
        alert.addAction(UIAlertAction(title: localize("ok"), style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
