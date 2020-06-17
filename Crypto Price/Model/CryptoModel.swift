//
//  CryptoModel.swift
//  Crypto Price
//
//  Created by Jan B on 24/05/2020.
//  Copyright © 2020 broflowski. All rights reserved.
//  api key: 5FC32403-FA79-4FF9-AE0F-F54916459D3A

import Foundation

protocol CryptoModelDelegate {
    func didFailWithError(error: Error)
    func didUpdatePrice(price: String, currency: String)
}
 
struct CryptoModel {
    
    var delegate: CryptoModelDelegate?
    
    let apikey = "5FC32403-FA79-4FF9-AE0F-F54916459D3A"
    
    let urlBase = "https://rest.coinapi.io/v1/exchangerate"
    
    let currencyArray = ["EUR", "USD", "GBP", "JPY", "ZAR", "CAD", "PLN", "CZK"]
    
    func getPrice(cryptoName: String, for currency: String) {
        let urlString = "\(urlBase)/\(cryptoName)/\(currency)?apikey=\(apikey)"
        print(urlString)
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                  return
                }
                if let safeData = data {
                    if let cryptoPrice = self.parseJSON(cryptoData: safeData){
                        let priceString = String(format: "%.2f", cryptoPrice)
                        self.delegate?.didUpdatePrice(price: priceString, currency: currency)
                    }
                }
            }
            
            task.resume()
        }
        
        
        
    }
    func parseJSON(cryptoData: Data) -> Double? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CryptoData.self, from: cryptoData)
            let price = decodedData.rate
            print(price)
            return price
        }
        catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }

}
    

