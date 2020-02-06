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
    
    var currentView = 1
    
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
        
        previousLabel.text = "< Prev"
        let previousTap = UITapGestureRecognizer(target: self, action: #selector(showPrev))
        previousView.addGestureRecognizer(previousTap)
        nextLabel.text = "Next >"
        let nextTap = UITapGestureRecognizer(target: self, action: #selector(validateForm))
        nextView.addGestureRecognizer(nextTap)
        
        loadMainView(step: 1)
        
        NotificationCenter.default.addObserver(self, selector: #selector(back(notification:)), name: Notification.Name("RegisterBack"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showNext(notification:)), name: Notification.Name("RegisterNextValidation"), object: nil)
        
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
        self.navigationController?.navigationBar.isTranslucent = true
        let buttonFrame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        let label = UILabel()
        label.text = "Profile"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.white
        navigationItem.titleView = label
        /*
        let backButton = UIButton(type: UIButton.ButtonType.custom)
        backButton.setImage(UIImage(named: "icon_back_white"), for: .normal)
        backButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        //backButton.frame = buttonFrame
        backButton.addTarget(self, action: #selector(backButtonPressed(_:)), for: .touchUpInside)
        let backBarButton = UIBarButtonItem(customView: backButton)
        navigationItem.setHidesBackButton(true, animated: false)
        navigationItem.leftBarButtonItem = backBarButton
        
        let saveBarButton = UIBarButtonItem(title: Localize("save"), style: .plain, target: self, action: #selector(saveButtonPressed(_:)))
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        saveBarButton.setTitleTextAttributes(attributes, for: .normal)
        
        navigationItem.rightBarButtonItem = saveBarButton*/
    }
    
    @objc func back(notification:Notification) {
        if let data = notification.userInfo as? [String: Int] {
            let idx = data["step"]!
            dismiss(animated: true, completion: nil)
        }
    }
    
    func loadMainView(step: Int) {
        if currentView == 1 {
            previousView.isHidden = true
            nextView.isHidden = false
        } else {
            previousView.isHidden = false
            nextView.isHidden = false
        }
        NotificationCenter.default.post(name: Notification.Name("RegisterTab"), object: nil, userInfo: ["idx": step - 1])
    }

    @objc func showPrev() {
        currentView -= 1
        loadMainView(step: currentView)
        collectionView.reloadData()
    }
    
    @objc func validateForm() {
        NotificationCenter.default.post(name: Notification.Name("RegisterNext"), object: nil, userInfo: ["idx": currentView - 1])
    }
    
    @objc func showNext(notification:Notification) {
        currentView += 1
        loadMainView(step: currentView)
        collectionView.reloadData()
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
            if currentView >= 1 {
                cell.setActive()
            } else {
                cell.setInactive()
            }
        case 1:
            cell.number.text = "2"
            cell.name.text = "Best Rate"
            if currentView >= 2 {
                cell.setActive()
            } else {
                cell.setInactive()
            }
        case 2:
            cell.number.text = "3"
            cell.name.text = "Syarat & Ketentuan"
            if currentView == 3 {
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
