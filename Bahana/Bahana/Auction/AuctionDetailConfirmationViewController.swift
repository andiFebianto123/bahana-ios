//
//  AuctionDetailConfirmationViewController.swift
//  Bahana
//
//  Created by Christian Chandra on /2002/28.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import UIKit

class AuctionDetailConfirmationViewController: UIViewController {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var confirmationLabel: UILabel!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var changeEndDateButton: UIButton!
    
    var pickerView = UIView()
    var datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mainView.layer.cornerRadius = 5
        mainView.layer.shadowColor = UIColor.gray.cgColor
        mainView.layer.shadowOffset = CGSize(width: 0, height: 0)
        mainView.layer.shadowRadius = 4
        mainView.layer.shadowOpacity = 0.5
        
        confirmationLabel.text = "Are you sure you want to be the winner?"
        
        noButton.backgroundColor = .red
        noButton.setTitleColor(.white, for: .normal)
        
        yesButton.backgroundColor = .green
        yesButton.setTitleColor(.white, for: .normal)
        
        changeEndDateButton.backgroundColor = .systemYellow
        changeEndDateButton.setTitleColor(.white, for: .normal)
        
        setDatePicker()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func setDatePicker() {
        pickerView.isHidden = true
        
        datePicker.datePickerMode = .date
        view.addSubview(datePicker)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            datePicker.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    @IBAction func changeEndDatePressed(_ sender: Any) {
        pickerView.isHidden = false
    }
}
