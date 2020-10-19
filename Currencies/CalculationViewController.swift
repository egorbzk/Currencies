//
//  CalculationViewController.swift
//  Currencies
//
//  Created by Egor Bozko on 10/18/20.
//  Copyright © 2020 Egor Bozko. All rights reserved.
//

import UIKit


class CalculationViewController: UIViewController {
    
    static let CalculationSegueKey = "CalculationSegue"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    public var rate: APILatestResponse.Rate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "Calculate \(rate?.localizedTitle ?? "") to USD"
        textField.placeholder = rate?.name
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textField.becomeFirstResponder()
    }
    
    @IBAction func convertButtonPressed(_ sender: Any) {
        guard let rateName = rate?.name, let amount = textField.text else { return }
        APIService.shared.calculate(from: rateName, amount: amount) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.show(message: "\(response.result)")
                case .failure(let error):
                    self.show(message: error.localizedDescription)
                }
            }
        }
    }
}
