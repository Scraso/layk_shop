//
//  PCViewController.swift
//  layk_shop
//
//  Created by Tigran Ambarcumyan on 10/24/18.
//  Copyright © 2018 Tigran Ambarcumyan. All rights reserved.
//

import UIKit

class PCViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
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
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Назад"
        navigationItem.backBarButtonItem = backItem
    }

}

extension PCViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 2
        case 2:
            return 3
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PCCell", for: indexPath)
        if indexPath.section == 0 {
           cell.textLabel?.text = "История и статус покупок"
        } else if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Оптовая закупка"
            case 1:
                cell.textLabel?.text = "Дропшипинг"
                cell.imageView?.image = UIImage(named: "partnership")
            default:
                break
            }
        } else if indexPath.section == 2 {
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "О магазине"
                cell.imageView?.image = UIImage(named: "about")
            case 1:
                cell.textLabel?.text = "Доставка и оплата"
                cell.imageView?.image = UIImage(named: "box")
            case 2:
                cell.textLabel?.text = "Обмен и возврат"
                cell.imageView?.image = UIImage(named: "refund")
            default:
                break
            }
        }
        
        return cell
    }
}

extension PCViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Заказы"
        case 1:
            return "Сотрудничество"
        case 2:
            return "Общая информация"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            performSegue(withIdentifier: "toHistoryVC", sender: nil)
        case 2:
            switch indexPath.row {
            case 0:
                performSegue(withIdentifier: "toAboutVC", sender: nil)
            case 1:
                performSegue(withIdentifier: "toShippingVC", sender: nil)
            case 2:
                performSegue(withIdentifier: "toRefundVC", sender: nil)
            default:
                break
            }
        default:
            break
        }
    }
    
}
