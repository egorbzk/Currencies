//
//  UserCurrenciesController.swift
//  Currencies
//
//  Created by Egor Bozko on 10/17/20.
//  Copyright © 2020 Egor Bozko. All rights reserved.
//

import UIKit

class UserCurrenciesController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var items: [APILatestResponse.Rate] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        items = DataManager.shared.favoriteItems
        tableView.reloadData()
        
        if let selectedIndex = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndex, animated: true)
        }
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: ItemCell.ItemCellNibKey, bundle: nil), forCellReuseIdentifier: ItemCell.ItemCellKey)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == CalculationViewController.CalculationSegueKey, let row = tableView.indexPathForSelectedRow?.row {
            let controller = segue.destination as? CalculationViewController
            controller?.rate = DataManager.shared.favoriteItems[row]
        }
    }
}

extension UserCurrenciesController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ItemCell.ItemCellKey) as! ItemCell
        let item = items[indexPath.row]
        cell.titleLabel.text = item.localizedTitle
        cell.controlButton.isHidden = true
        return cell
    }
}

extension UserCurrenciesController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            DataManager.shared.delete(item: items[indexPath.row])
            items.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: CalculationViewController.CalculationSegueKey, sender: nil)
    }
}
