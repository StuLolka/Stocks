import UIKit

//MARK: - protocols
protocol StocksPresenterProtocol {
    var model: StocksModelProtocol? { get set }
    var view: StocksViewControllerProtocol? { get set }
    var network: NetworkProtocol? { get set }
    
    func sendRequests(for row: Int, wholeReload: Bool)
    func getInfoScreen()
    func getCompanyArrayFromModel() -> [String]
}

protocol StocksViewProtocol: UIView {
    func reloadData()
    func addData(_ nameCompany: String, _ currentPrice: String, _ priceChanges: String, _ priceChangesTextColor: UIColor)
    func addLogo(_ image: UIImage)
    func showAlert()
    func reloadChooseCompanyPicker()
}

//MARK: - class StocksViewController
final class StocksViewController: UIViewController, StocksViewControllerProtocol {
    let presenter: StocksPresenterProtocol
    
    lazy var customView: StocksViewProtocol = StocksView(delegate: self)
    
    init(presenter: StocksPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        customView.backgroundColor = .systemBackground
        view = customView
        presenter.sendRequests(for: 0, wholeReload: true)
    }
    
    func companyWasSelected(_ row: Int) {
        presenter.sendRequests(for: row, wholeReload: false)
    }
    
    func wholeReloadPicker(for row: Int) {
        presenter.sendRequests(for: row, wholeReload: true)
    }
    
    func addDataToView(_ nameCompany: String, _ currentPrice: String, _ priceChanges: String, _ priceChangesTextColor: UIColor) {
        customView.addData(nameCompany, currentPrice, priceChanges, priceChangesTextColor)
    }
    
    func addImageToLogo(_ image: UIImage) {
        customView.addLogo(image)
    }
    
    func showAlert() {
        customView.showAlert()
    }
    
    func reloadChooseCompanyPicker() {
        customView.reloadChooseCompanyPicker()
    }
    
    func getCompanyArrayFromModel() -> [String] {
        presenter.getCompanyArrayFromModel()
    }
    
    private func setupNavigationBar() {
        title = NSLocalizedString("Stocks", comment: "Stocks")
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "info"),
            style: .done,
            target: self,
            action: #selector(getinfo))
    }
    
    @objc func getinfo() {
        presenter.getInfoScreen()
    }
    
}

