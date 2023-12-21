//
//  CoinManager.swift
//  MaticCoin
//
//  Created by Mariola Hullings on 12/20/23.
//

import UIKit

protocol CoinManagerDelegate {
    func didFailWithError(error: Error)
    func didUpdateRate(price: String, currency: String)
}

enum Environment {
    enum Keys {
        static let apiKey = "API_KEY"
    }
    //access the contents of the Info.plist file
    // infoDictionary: [String: Any] - A dictionary, constructed from the bundle's info.plist file, that contains info about the receiver.
    static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("plist not found")
        }
        return dict
    }()
    
    static var apiKey: String = {
        guard let apiKeyString = Environment.infoDictionary[Keys.apiKey] as? String else {
            fatalError("API not found")
        }
        return apiKeyString
    }()
}

struct CoinManager {
    var delegate: CoinManagerDelegate?
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/MATIC"
    let apiKey = Environment.apiKey
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice(for currency: String) {
        let urlString = "\(baseURL)/\(currency)?apikey=\(Environment.apiKey)"
        //Create a URL
        if let url = URL(string: urlString){
            //Create a URL session
            let session = URLSession(configuration: .default)
            //Give URL session a task
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let maticPrice = self.parseJSON(safeData){
                        let priceString = String(format: "%.2f", maticPrice)
                        delegate?.didUpdateRate(price: priceString, currency: currency)
                    }
//                    let dataString = String(decoding: safeData, as: UTF8.self)
//                    print("Received data as string: \(dataString )")
                }
            }
            //Start the task
            task.resume()
        }
    }
    func parseJSON(_ data: Data ) -> Double? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let lastPrice = decodedData.rate
            print(lastPrice)
            return lastPrice
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
