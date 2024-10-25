

import Foundation

protocol CoinManagerDelegate {
    func didUpdateCoin(_ coinManager: CoinManager,coin: Coin)
    func didFailWithError(_ error: Error)
}



struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://api.coinlayer.com/live?access_key=ADDYOURACCESSKEYHERE&symbols=BTC"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR","IRR"]
    
    func getCoinPrice(for currency: String) {
        let urlString = "\(baseURL)&target=\(currency)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error {
                    delegate?.didFailWithError(error)
                    return
                }
                if let safeData = data {
                    if let coin = self.parseJSON(safeData) {
                        self.delegate?.didUpdateCoin(self, coin: coin)
                    }
                }
                
            }
            .resume()
        }
    }
    
    func parseJSON(_ coinData: Data) -> Coin? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            let rate = decodedData.rates.BTC
            let currency = decodedData.target
            let price = Coin(rates: rate, currency: currency)
            return price
            
        } catch {
            delegate?.didFailWithError(error)
            return nil
        }
    }
}

