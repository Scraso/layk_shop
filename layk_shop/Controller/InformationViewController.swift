//
//  InformationViewController.swift
//  layk_shop
//
//  Created by Tigran Ambarcumyan on 8/24/18.
//  Copyright © 2018 Tigran Ambarcumyan. All rights reserved.
//

import UIKit

class InformationViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var items = ["О магазине", "Доставка и оплата", "Обмен или возврат", "Сотрудничество"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
    }

    // Remove selection when back to ViewController
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectionIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectionIndexPath, animated: animated)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Назад"
        navigationItem.backBarButtonItem = backItem
    }

}

extension InformationViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InformationCell", for: indexPath)
        let item = items[indexPath.row]
        cell.textLabel?.text = item
        return cell
    }
}

extension InformationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            self.performSegue(withIdentifier: "toAboutVC", sender: nil)
        case 1:
            self.performSegue(withIdentifier: "toShippingVC", sender: nil)
        case 2:
            self.performSegue(withIdentifier: "toRefundVC", sender: nil)
        case 3:
            self.performSegue(withIdentifier: "toPartnershipVC", sender: nil)
        default:
            break
        }
    }
}







