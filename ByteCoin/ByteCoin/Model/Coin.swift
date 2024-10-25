
struct Coin {
    let rates: Double
    let currency: String
    
    var ratesString: String {
        String(format: "%.2f", rates)
    }
}
