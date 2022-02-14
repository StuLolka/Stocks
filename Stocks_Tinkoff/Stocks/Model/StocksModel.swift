struct NameSymbolCompany: Decodable {
    let companyName: String
    let symbol: String
}


final class StocksModel: StocksModelProtocol {
    
    private var dictionaryCompanies = ["Apple" : "AAPL",
                            "Microsoft" : "MSFT",
                            "Google" : "GOOG",
                            "Amazon" : "AMZN",
                            "Facebook" : "FB"]

    func addCompanyToDictionary(from array: [NameSymbolCompany]) {
        for i in array {
            dictionaryCompanies[i.companyName] = i.symbol
        }
    }
    
    func getSortedCompanyArray() -> [String] {
        Array(dictionaryCompanies.keys).sorted()
    }
    
    func getValueFromSortedDictinary(_ key: String) -> String? {
        dictionaryCompanies[key]
    }
}
