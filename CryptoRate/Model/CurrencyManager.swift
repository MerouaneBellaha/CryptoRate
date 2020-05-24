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

    let currencyArray = [
        ["BTC", "ETH", "XRP", "LTC", "BCH"],
        ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    ]

    static var shared = CurrencyManager()
    private var task: URLSessionDataTask?

    private init() {}

    func getRates(for currency: String, and cryptoCurrency: String, callBack: @escaping (Result<CurrencyModel?, Error>) -> ()) {
        guard let request = URL(string: baseURL+cryptoCurrency+"/"+currency+apiKey) else { return }
        let session = URLSession(configuration: .default)

        task?.cancel()
        task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callBack(.failure(error!)) // mieux déballer
                    return
                }
                guard let response = response as? HTTPURLResponse,
                    response.statusCode == 200 else {
                        callBack(.failure(error!))
                        return
                }
                guard let responseJson = try? JSONDecoder().decode(CurrencyData.self, from: data) else {
                    callBack(.failure(error!))
                    return
                }
                callBack(.success(CurrencyModel(rate: responseJson.rate)))
            }
        }
        task?.resume()
    }

//    func getRates(for currency: String, and cryptoCurrency: String, callBack: @escaping (CurrencyModel?, Bool) -> ()) {
//        guard let request = URL(string: baseURL+cryptoCurrency+"/"+currency+apiKey) else { return }
//        let session = URLSession(configuration: .default)
//
//        task?.cancel()
//        task = session.dataTask(with: request) { (data, response, error) in
//            DispatchQueue.main.async {
//                guard let data = data, error == nil else {
//                    callBack(nil, false)
//                    return
//                }
//                guard let response = response as? HTTPURLResponse,
//                    response.statusCode == 200 else {
//                        callBack(nil, false)
//                        return
//                }
//                guard let responseJson = try? JSONDecoder().decode(CurrencyData.self, from: data) else {
//                    callBack(nil, false)
//                    return
//                }
//                callBack(CurrencyModel(rate: responseJson.rate), true)
//            }
//        }
//        task?.resume()
//    }
}
