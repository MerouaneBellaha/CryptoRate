//
//  CurrencyManager.swift
//  CryptoRate
//
//  Created by Merouane Bellaha on 02/05/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import Foundation

class CurrencyManager {

    private let baseURL = "https://rest.coinapi.io/v1/exchangerate/"
    private let apiKey = "?apikey=93E0C214-4B73-4597-AB59-9A14899A2E71"
    private let session: URLSession

    let currencyArray = [
        ["BTC", "ETH", "XRP", "LTC", "BCH"],
        ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    ]

    private var task: URLSessionDataTask?

    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }

    enum CurrencyManagerError: Error {
        case incorrectResponse
        case undecodableData
        case noData

        var description: String {
            switch self {
            case .incorrectResponse:
               return "No response"
            case .undecodableData:
                return ""
            case .noData:
                return ""
            }
        }
    }

    func getRates(for currency: String, and cryptoCurrency: String, callBack: @escaping (Result<CurrencyModel, CurrencyManagerError>) -> ()) {
        guard let request = URL(string: baseURL+cryptoCurrency+"/"+currency+apiKey) else { return }

        task?.cancel()
        task = session.dataTask(with: request) { (data, response, error) in

                guard let data = data, error == nil else {
                    callBack(.failure(.noData))
                    return
                }
                guard let response = response as? HTTPURLResponse,
                    response.statusCode == 200 else {
                        callBack(.failure(.incorrectResponse))
                        return
                }
                guard let responseJson = try? JSONDecoder().decode(CurrencyData.self, from: data) else {
                    callBack(.failure(.undecodableData))
                    return
                }
                callBack(.success(CurrencyModel(rate: responseJson.rate)))
            }
        task?.resume()
    }
}
