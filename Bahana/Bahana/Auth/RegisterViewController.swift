//
//  RegisterViewController.swift
//  Bahana
//
//  Created by Christian Chandra on /2001/31.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import UIKit
import Eureka

class RegisterViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bottomNavigationView: UIView!
    @IBOutlet weak var previousView: UIView!
    @IBOutlet weak var previousLabel: UILabel!
    @IBOutlet weak var nextView: UIView!
    @IBOutlet weak var nextLabel: UILabel!
    
    var currentViewIdx = 0
    
    var presenter: RegisterPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "RegisterStepCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RegisterStepCollectionViewCell")
        
        setNavigationItems()
        
        //bottomNavigationView.layer.borderWidth = 0.5
        //bottomNavigationView.layer.borderColor = UIColor.red.cgColor
        //bottomNavigationView.layer.masksToBounds = true
        
        let previousTap = UITapGestureRecognizer(target: self, action: #selector(showPrev))
        previousView.addGestureRecognizer(previousTap)
        let nextTap = UITapGestureRecognizer(target: self, action: #selector(validateForm))
        nextView.addGestureRecognizer(nextTap)
        
        loadMainView(index: 0)
        
        // Back when form failed to load
        NotificationCenter.default.addObserver(self, selector: #selector(back(notification:)), name: Notification.Name("RegisterBack"), object: nil)
        // Go to next step
        NotificationCenter.default.addObserver(self, selector: #selector(showNext(notification:)), name: Notification.Name("RegisterNextValidation"), object: nil)
        // Check if user checked agreement checkbox
        NotificationCenter.default.addObserver(self, selector: #selector(isAgree(notification:)), name: Notification.Name("RegisterAgreement"), object: nil)
        
        presenter = RegisterPresenter(delegate: self)
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
        //self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.barTintColor = UIColor.red
        let buttonFrame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        let label = UILabel()
        label.text = "REGISTRASI"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.white
        let titleBar = UIBarButtonItem.init(customView: label)
        //navigationItem.setHidesBackButton(true, animated: false)
        navigationItem.setLeftBarButton(titleBar, animated: true)
        
        let closeButton = UIButton(type: UIButton.ButtonType.custom)
        //closeButton.setImage(UIImage(named: "icon_back_white"), for: .normal)
        closeButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        closeButton.setTitle("X", for: .normal)
        closeButton.setTitleColor(.white, for: .normal)
        //closeButton.frame = buttonFrame
        closeButton.addTarget(self, action: #selector(showAlertExit), for: .touchUpInside)
        let closeBarButton = UIBarButtonItem(customView: closeButton)
        //navigationItem.setHidesBackButton(true, animated: false)
        
        navigationItem.rightBarButtonItem = closeBarButton
    }
    
    @objc func showAlertExit() {
        let alert = UIAlertController(title: "Informasi", message: "Apakah anda yakin ingin meninggalkan halaman ini?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tidak", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Ya", style: .default, handler: { action in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func back(notification:Notification) {
        if let data = notification.userInfo as? [String: Int] {
            let idx = data["step"]!
            dismiss(animated: true, completion: nil)
        }
    }
    
    func loadMainView(index: Int) {
        nextView.isUserInteractionEnabled = true
        nextLabel.textColor = UIColor.black
        if currentViewIdx == 0 {
            nextLabel.text = "Next >"
            previousView.isHidden = true
            nextView.isHidden = false
        } else {
            previousLabel.text = "< Prev"
            nextLabel.text = "Next >"
            previousView.isHidden = false
            nextView.isHidden = false
            if currentViewIdx == 2 {
                nextLabel.text = "Kirim"
                nextView.isUserInteractionEnabled = false
                nextLabel.textColor = UIColor.gray
            }
        }
        // Load view by tab index
        NotificationCenter.default.post(name: Notification.Name("RegisterTab"), object: nil, userInfo: ["idx": index])
    }

    @objc func showPrev() {
        currentViewIdx -= 1
        loadMainView(index: currentViewIdx)
        collectionView.reloadData()
    }
    
    @objc func validateForm() {
        // Before go to next step, validate form first
        NotificationCenter.default.post(name: Notification.Name("RegisterNext"), object: nil, userInfo: ["idx": currentViewIdx])
    }
    
    @objc func showNext(notification:Notification) {
        if let data = notification.userInfo as? [String: Int] {
            //let idx = data["idx"]!
            //if idx == currentViewIdx {
                currentViewIdx += 1
                if currentViewIdx < 3 {
                    loadMainView(index: currentViewIdx)
                    collectionView.reloadData()
                } else {
                    presenter.submit()
                }
            //}
        }
    }
    
    @objc func isAgree(notification:Notification) {
        if let data = notification.userInfo as? [String: Int] {
            let isChecked = data["isChecked"]!
            if isChecked == 1 {
                nextView.isUserInteractionEnabled = true
                nextLabel.textColor = UIColor.black
            } else {
                nextView.isUserInteractionEnabled = false
                nextLabel.textColor = UIColor.gray
            }
        }
    }
}

extension RegisterViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RegisterStepCollectionViewCell", for: indexPath) as! RegisterStepCollectionViewCell
        switch indexPath.row {
        case 0:
            cell.number.text = "1"
            cell.name.text = "Form Registrasi"
            if currentViewIdx >= 0 {
                cell.setActive()
            } else {
                cell.setInactive()
            }
        case 1:
            cell.number.text = "2"
            cell.name.text = "Best Rate"
            if currentViewIdx >= 1 {
                cell.setActive()
            } else {
                cell.setInactive()
            }
        case 2:
            cell.number.text = "3"
            cell.name.text = "Syarat & Ketentuan"
            if currentViewIdx == 2 {
                cell.setActive()
            } else {
                cell.setInactive()
            }
        default:
            break
        }
        return cell
    }
    
    
}

extension RegisterViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize = UIScreen.main.bounds
        return CGSize(width: screenSize.width / 3 - 20, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension RegisterViewController: RegisterDelegate {
    func isRegisterSuccess(_ isSuccess: Bool) {
        //
    }
}
