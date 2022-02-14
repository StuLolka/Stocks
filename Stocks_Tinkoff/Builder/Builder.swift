import UIKit

protocol BuilderProtocol {
    func getStocksScreen() -> StocksViewControllerProtocol
    func getInfoScreen() -> InfoViewControllerProtocol
}

final class Builder: BuilderProtocol {
    
    static var shared: BuilderProtocol = {
        return Builder()
    }()
    
    private var stocksPresenter: StocksPresenterProtocol = {
        return StocksPresenter()
    }()
    
    private var infoPresenter: InfoPresenterProtocol = {
        return InfoPresenter()
    }()

    private init() {}
    
    func getStocksScreen() -> StocksViewControllerProtocol {
        let model = StocksModel()
        let view = StocksViewController(presenter: stocksPresenter)
        let network = Network.shared
        stocksPresenter.view = view
        stocksPresenter.model = model
        stocksPresenter.network = network
        return view
    }
    
    func getInfoScreen() -> InfoViewControllerProtocol {
        let model = InfoModel()
        let view = InfoViewController(presenter: infoPresenter)
        infoPresenter.view = view
        infoPresenter.model = model
        return view
    }
}
