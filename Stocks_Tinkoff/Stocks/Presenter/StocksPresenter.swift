import UIKit
import Alamofire

//MARK: - protocols
protocol StocksModelProtocol {
    func addCompanyToDictionary(from array: [NameSymbolCompany])
    func getSortedCompanyArray() -> [String]
    func getValueFromSortedDictinary(_ key: String) -> String?
}

protocol StocksViewControllerProtocol: UIViewController {
    func companyWasSelected(_ row: Int)
    func wholeReloadPicker(for row: Int)
    func addDataToView(_ nameCompany: String, _ currentPrice: String, _ priceChanges: String, _ priceChangesTextColor: UIColor)
    func addImageToLogo(_ image: UIImage)
    func showAlert()
    func reloadChooseCompanyPicker()
    func getCompanyArrayFromModel() -> [String]
}

protocol NetworkProtocol {
    func requestCompanies(completion: @escaping (Result<[NameSymbolCompany], Error>) -> Void)
    func requestQuote(for symbol: String, completion: @escaping (Result<StockData, Error>) -> Void)
    func requestImage(for symbol: String, completion: @escaping (Result<Data, Error>) -> Void)
}

//MARK: - class StocksPresenter
final class StocksPresenter: StocksPresenterProtocol {
    
    var model: StocksModelProtocol?
    var view: StocksViewControllerProtocol?
    var network: NetworkProtocol?
    
    func sendRequests(for row: Int, wholeReload: Bool) {
        if row == 0 && wholeReload {
            getMoreCompanyRequest()
        }
        else {
            requestDataAnaLogo(for: row)
        }
    }
    
    func getInfoScreen() {
       let infoScreen = Builder.shared.getInfoScreen()
       let navigationController = UINavigationController(rootViewController: infoScreen)
       view?.present(navigationController, animated: true, completion: nil)
   }
    
    func getCompanyArrayFromModel() -> [String] {
        guard let model = model else {
            return []
        }
        return model.getSortedCompanyArray()
    }
    
    private func getMoreCompanyRequest() {
        guard let network = network else {
            assertionFailure("Network in presenter = nil")
            return
        }
        network.requestCompanies(completion: { result in
            switch result {
            case .success(let nameSymbolCompanyArray):
                self.model?.addCompanyToDictionary(from: nameSymbolCompanyArray)
                self.view?.reloadChooseCompanyPicker()
                self.requestDataAnaLogo(for: 0)
                self.view?.reloadChooseCompanyPicker()
            case .failure:
                self.view?.showAlert()
            }
        })
        presentInfoIfNeeded()
    }
    
    private func requestDataAnaLogo(for row: Int) {
        guard let model = model else {
            assertionFailure("Model in presenter = nil")
            return
        }
        let nameCompany = model.getSortedCompanyArray()[row]
        guard let selectedSymbol = model.getValueFromSortedDictinary(nameCompany) else {
            assertionFailure("There is no symbol for \(nameCompany)")
            return
        }
        
        requestData(for: selectedSymbol)
        requestLogo(for: selectedSymbol)
    }

    
    private func presentInfoIfNeeded() {
        if !UserDefaults.standard.bool(forKey: "isInfoPresented") {
            UserDefaults.standard.setValue(true, forKey: "isInfoPresented")
            getInfoScreen()
        }
    }
    
    private func requestData(for company: String) {
        network?.requestQuote(for: company, completion: { result in
            switch result {
            case .success(let stock):
                self.view?.addDataToView(
                    stock.companyName,
                    String(stock.latestPrice),
                    String(self.addSignPriceChanges(price: stock.change)),
                    self.getColorForPriceChanges(stock.change))
            case .failure:
                self.view?.showAlert()
            }
        })
    }
    
    private func requestLogo(for company: String) {
        network?.requestImage(for: company, completion: { result in
            switch result {
            case .success(let data):
                guard let image = UIImage(data: data) else {
                    print("Fail image set up image for \(company)")
                    return
                }
                self.view?.addImageToLogo(image)
            case .failure:
                print("There is no image for \(company)")
                return
            }
        })
    }
    
    private func addSignPriceChanges(price changes: Double) -> String {
        if changes > 0 {
            return "+" + "\(changes)"
        }
        return "\(changes)"
    }
    
    private func getColorForPriceChanges(_ priceChanges: Double) -> UIColor {
        switch priceChanges {
        case ..<0:
            return .systemRed
        case 0:
            if UIScreen.main.traitCollection.userInterfaceStyle == .dark {
                return .white
            }
            else {
                return .black
            }
        default:
            return .green
        }
    }
}


