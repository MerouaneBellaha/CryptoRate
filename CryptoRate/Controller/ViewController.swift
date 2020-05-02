//
//  ViewController.swift
//  CryptoRate
//
//  Created by Merouane Bellaha on 02/05/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var cryptoCurrencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!

    var currencyManager = CurrencyManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.setValue(#colorLiteral(red: 1, green: 0.7497689128, blue: 0.006502680946, alpha: 1), forKeyPath: "textColor")
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        currencyManager.delegate = self
    }
}

extension ViewController: CurrencyManagerDelegate {
    func didFailWithError(error: Error) {
        print(error)
    }

    func didUpdateRate(rate: CurrencyModel) {
        DispatchQueue.main.async {
            self.rateLabel.text = rate.formatedRate
        }
    }
}

extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return currencyManager.currencyArray.count
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyManager.currencyArray[component].count
    }
}

extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyManager.currencyArray[component][row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let cryptoCurrency = currencyManager.currencyArray[0][pickerView.selectedRow(inComponent: 0)]
        let currency = currencyManager.currencyArray[1][pickerView.selectedRow(inComponent: 1)]
        cryptoCurrencyLabel.text = cryptoCurrency
        currencyLabel.text = currency
        currencyManager.getRatePrice(for: currency, and: cryptoCurrency)
    }
}

