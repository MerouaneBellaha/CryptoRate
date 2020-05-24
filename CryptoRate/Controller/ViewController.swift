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

    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.setValue(#colorLiteral(red: 1, green: 0.7497689128, blue: 0.006502680946, alpha: 1), forKeyPath: "textColor")
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
    }
}

extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return CurrencyManager.shared.currencyArray.count
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return CurrencyManager.shared.currencyArray[component].count
    }
}

extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return CurrencyManager.shared.currencyArray[component][row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let cryptoCurrency = CurrencyManager.shared.currencyArray[0][pickerView.selectedRow(inComponent: 0)]
        let currency = CurrencyManager.shared.currencyArray[1][pickerView.selectedRow(inComponent: 1)]
        cryptoCurrencyLabel.text = cryptoCurrency
        currencyLabel.text = currency
        CurrencyManager.shared.getRates(for: currency, and: cryptoCurrency) { (rate, success) in
            guard success, let rate = rate else {
                print("error")
                return
            }
            self.rateLabel.text = rate.formatedRate
        }
    }
}

