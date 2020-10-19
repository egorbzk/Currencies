//
//  ViewController.swift
//  Currencies
//
//  Created by Egor Bozko on 10/17/20.
//  Copyright © 2020 Egor Bozko. All rights reserved.
//

import UIKit

final class LatestCurrenciesController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var items: [APILatestResponse.Rate] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private var filteredItems: [APILatestResponse.Rate] = []
    private var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupTableView()
        APIService.shared.loadCurrencies { result in
            switch result {
            case .success(let response):
                self.items = response.rates
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    func setupSearchBar() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
        navigationItem.searchController = searchController
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: ItemCell.ItemCellNibKey, bundle: nil), forCellReuseIdentifier: ItemCell.ItemCellKey)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredItems = items.filter { (item: APILatestResponse.Rate) -> Bool in
            return item.localizedTitle.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == CalculationViewController.CalculationSegueKey, let index = tableView.indexPathForSelectedRow?.row {
            let item = (isSearchBarEmpty ? items : filteredItems)[index]
            let controller = segue.destination as? CalculationViewController
            controller?.rate = item
        }
    }
}

extension LatestCurrenciesController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearchBarEmpty ? items.count : filteredItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ItemCell.ItemCellKey) as! ItemCell
        let item = (isSearchBarEmpty ? items : filteredItems)[indexPath.row]
        cell.titleLabel.text = item.localizedTitle
        cell.controlButton.isSelected = DataManager.shared.isFavorite(item)
        cell.controlAction = {
            DataManager.shared.save(item)
            cell.controlButton.isSelected = DataManager.shared.isFavorite(item)
        }
        return cell
    }
}

extension LatestCurrenciesController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: CalculationViewController.CalculationSegueKey, sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension LatestCurrenciesController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
  }
}
