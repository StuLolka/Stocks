import Alamofire

enum NetworkError: Error {
    case urlError
    case responseError
    case internetConnection
}

struct StockData: Decodable {
    let companyName: String
    let latestPrice: Double
    let change: Double
}

final class Network: NetworkProtocol {

    static var shared: NetworkProtocol = Network()
    
    private let publishToken = "pk_c6d81a6bd6a549f6a9cc43c1f22cbcbd"
    private let requestQuoteParametr = "/quote?&token="
    private let fetchCompaniesList = "https://cloud.iexapis.com/stable/stock/market/list/gainers?token="
    private let fetchStocksUrl = "https://cloud.iexapis.com/stable/stock/"
    private let fetchLogoUrl = "https://storage.googleapis.com/iex/api/logos/"
    
    private var isConnectedToInternet: Bool {
            return NetworkReachabilityManager()?.isReachable ?? false
        }
    
    private init() {}
    
    func requestCompanies(completion: @escaping (Result<[NameSymbolCompany], Error>) -> Void) {
        
        guard isConnectedToInternet else {
            completion(.failure(NetworkError.internetConnection))
            return
        }
        guard let url = URL(string: fetchCompaniesList + publishToken) else {
            return
        }
        
        AF.request(url)
            .validate()
            .responseDecodable(of: StockData.self) { response in
                guard let data = response.data else {
                    assertionFailure("Can't get \(StockData.self) from \(url)")
                    return
                }
                let nameSymbolCompanyArray = self.parseCompanies(from: data)
                completion(.success(nameSymbolCompanyArray))
            }.resume()
    }
    
    
    func requestQuote(for symbol: String, completion: @escaping (Result<StockData, Error>) -> Void) {
        guard isConnectedToInternet else {
            completion(.failure(NetworkError.internetConnection))
            return
        }
        guard let url = URL(string: fetchStocksUrl + symbol + requestQuoteParametr + publishToken) else {
            completion(.failure(NetworkError.urlError))
            return
        }
        
        AF.request(url)
            .validate()
            .responseDecodable(of: StockData.self) { response in
                guard let stock = self.getStockModel(response: response) else {return }
                completion(.success(stock))
            }.resume()
    }
    
    func requestImage(for symbol: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: fetchLogoUrl + symbol + ".png") else {
            completion(.failure(NetworkError.urlError))
            return
        }
        
        AF.request(url)
            .validate()
            .response { data in
                guard let data = data.data else {
                    completion(.failure(NetworkError.responseError))
                    return
                }
                completion(.success(data))
            }
    }
    
    //    MARK: -  parse
    private func parseCompanies(from data: Data) ->  [NameSymbolCompany] {
        var jsonObject: Any?
        var nameSymbolCompanyArray = [NameSymbolCompany]()
        do {
            jsonObject = try JSONSerialization.jsonObject(with: data)
        }
        catch {
            assertionFailure("jsonObject error")
            return []
        }
        guard let json = jsonObject as? [[String : Any]] else {
            return []
        }
        
        for object in json {
            guard let companyName = object["companyName"] as? String,
                  let companySymbol = object["symbol"] as? String else {
                      continue
                  }
            nameSymbolCompanyArray.append(NameSymbolCompany(companyName: companyName, symbol: companySymbol))
        }
        return nameSymbolCompanyArray
    }
    
    
    private func getStockModel(response: DataResponse<StockData, AFError>) -> StockData? {
        guard let data = response.data, response.error == nil, let request = response.request, let responseHTTPURL = response.response, let stock = response.value else {
            assertionFailure("\(NetworkError.responseError)")
            return nil
        }
        cachedURLResponse(response: responseHTTPURL, data: data, request: request)
        return stock
    }
    
    //MARK:- get cached
    private func cachedURLResponse(response: URLResponse, data: Data, request: URLRequest) {
        let cachedURLResponse = CachedURLResponse(response: response, data: data, userInfo: nil, storagePolicy: .allowed)
        URLCache.shared.storeCachedResponse(cachedURLResponse, for: request)
    }
}
