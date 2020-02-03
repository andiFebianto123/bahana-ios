//
//  OptionViewController.swift
//  Bahana
//
//  Created by Christian Chandra on /2001/31.
//  Copyright © 2020 Rectmedia. All rights reserved.
//

import UIKit

class OptionViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var banks = [Bank]()
    var branchs = [BankBranch]()
    
    var type = "bank"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func test(_ banks: [Bank], _ branchs: [BankBranch]) {
        self.banks = banks
        self.branchs = branchs
        print(banks.count)
    }
    
}

extension OptionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch type {
        case "bank":
            return banks.count
        case "bank_branch":
            return branchs.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        if type == "bank" {
            cell.textLabel?.text = banks[indexPath.row].name
        } else if type == "bank_branch" {
            cell.textLabel?.text = branchs[indexPath.row].name
        }
        return cell
    }
}

extension OptionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
}

extension OptionViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //presenter.searchData(query: searchText)
        switch type {
        case "bank":
            print("")
        case "bank_branch":
            print("")
        default:
            break
        }
    }
}
