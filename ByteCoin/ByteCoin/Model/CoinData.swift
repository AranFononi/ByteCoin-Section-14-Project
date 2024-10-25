

struct CoinData: Codable {
    let rates: Rates
    let target: String
}

struct Rates: Codable {
    let BTC: Double
}
