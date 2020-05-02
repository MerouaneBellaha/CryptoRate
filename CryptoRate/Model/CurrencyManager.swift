//
//  CurrencyManager.swift
//  CryptoRate
//
//  Created by Merouane Bellaha on 02/05/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import Foundation

protocol CurrencyManagerDelegate: class {
    func didUpdateRate(rate: CurrencyModel)
    func didFailWithError(error: Error)
}

struct CurrencyManager {

    let baseURL = "https://rest.coinapi.io/v1/exchangerate/"
    let apiKey = "?apikey=93E0C214-4B73-4597-AB59-9A14899A2E71"

    let currencyArray = [
        ["BTC", "ETH", "XRP", "LTC", "BCH"],
        ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    ]

    weak var delegate: CurrencyManagerDelegate?

    func getRatePrice(for currency: String, and cryptoCurrency: String) {
        let stringURL = baseURL+cryptoCurrency+"/"+currency+apiKey
        performRequest(with: stringURL)
    }

    func performRequest(with urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, _, error in
            if error != nil {
                self.delegate?.didFailWithError(error: error!)
                return
            }
            if let safeData = data {
                guard let rate = self.parseJSON(safeData) else { return }
                self.delegate?.didUpdateRate(rate: rate)
            }
        }
        task.resume()
    }

    func parseJSON(_ currencyData: Data) -> CurrencyModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CurrencyData.self, from: currencyData)
            let rate = decodedData.rate
            return CurrencyModel(rate: rate)
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
