import UIKit
import SnapKit

final class StocksView: UIView, StocksViewProtocol {
    
    private let delegate: StocksViewControllerProtocol
    
    //MARK: - views
    lazy private var alert: AlertView = {
        let alert = AlertView(view: self)
        alert.isHidden = true
        return alert
    }()
    
    lazy private var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    lazy private var logoCompanyImageView: UIImageView = {
        let image = UIImageView()
        image.image = .checkmark
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    lazy private var nameCompanyLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.minimumScaleFactor = 0.7
        label.adjustsFontSizeToFitWidth = true
        label.font = .boldSystemFont(ofSize: nameCompanyFontSize)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    lazy private var currentPriceStockLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: currentPriceStockFontSize)
        label.textAlignment = .center
        return label
    }()
    
    lazy private var priceChangesStockLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: priceChangesStockFontSize)
        label.textAlignment = .center
        return label
    }()
    
    lazy private var chooseCompanyPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()
    
    //    MARK: - views sizes
    lazy private var imageCompanyViewSize = UIScreen.main.bounds.width / 3
    lazy private var topImageConstraint = UIScreen.main.bounds.height / 5.5
    lazy private var topNameCompanyConstraint = topImageConstraint / 2
    lazy private var heightChooseCompanyPicker = UIScreen.main.bounds.height / 3
    
    //    MARK: - font sizes
    lazy private var nameCompanyFontSize = UIScreen.main.bounds.height / 25
    lazy private var currentPriceStockFontSize = UIScreen.main.bounds.height / 30
    lazy private var priceChangesStockFontSize = UIScreen.main.bounds.height / 35
    
    private var choosenRowInPicker = 0
    
    init(delegate view: StocksViewControllerProtocol) {
        self.delegate = view
        super.init(frame: UIScreen.main.bounds)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadData() {
        loadingIndicator.startAnimating()
        self.logoCompanyImageView.isHidden = false
        alert.isHidden = true
        delegate.companyWasSelected(choosenRowInPicker)
        delegate.wholeReloadPicker(for: choosenRowInPicker)
    }
    
    func addData(_ nameCompany: String, _ currentPrice: String, _ priceChanges: String, _ priceChangesTextColor: UIColor) {
        loadingIndicator.stopAnimating()
        chooseCompanyPicker.isHidden = false
        nameCompanyLabel.text = nameCompany
        currentPriceStockLabel.text = currentPrice + " $"
        priceChangesStockLabel.text = priceChanges
        priceChangesStockLabel.textColor = priceChangesTextColor
    }
    
    func addLogo(_ image: UIImage) {
        logoCompanyImageView.image = image
    }
    
    func showAlert() {
        DispatchQueue.main.async {
            self.choosenRowInPicker = self.chooseCompanyPicker.selectedRow(inComponent: 0)
            self.logoCompanyImageView.isHidden = true
            self.alert.isHidden = false
            self.loadingIndicator.stopAnimating()
            self.chooseCompanyPicker.isHidden = true
        }
    }
    
    func reloadChooseCompanyPicker() {
        DispatchQueue.main.async {
            self.chooseCompanyPicker.reloadAllComponents()
        }
    }
    
    private func setupConstraints() {
        addSubview(alert)
        addSubview(loadingIndicator)
        addSubview(logoCompanyImageView)
        addSubview(nameCompanyLabel)
        addSubview(currentPriceStockLabel)
        addSubview(priceChangesStockLabel)
        addSubview(chooseCompanyPicker)
        
        alert.frame = self.frame
        
        loadingIndicator.snp.makeConstraints { make in
            make.top.equalTo(logoCompanyImageView.snp_bottomMargin).offset(topNameCompanyConstraint)
            make.centerX.equalTo(self)
        }
        
        logoCompanyImageView.snp.makeConstraints { make in
            make.top.equalTo(topImageConstraint)
            make.centerX.equalTo(self)
            make.height.width.equalTo(imageCompanyViewSize)
        }
        
        nameCompanyLabel.snp.makeConstraints { make in
            make.top.equalTo(logoCompanyImageView.snp_bottomMargin).offset(topNameCompanyConstraint)
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
        }
        
        currentPriceStockLabel.snp.makeConstraints { make in
            make.top.equalTo(nameCompanyLabel.snp_bottomMargin).offset(topNameCompanyConstraint / 2)
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
        }
        
        priceChangesStockLabel.snp.makeConstraints { make in
            make.top.equalTo(currentPriceStockLabel.snp_bottomMargin).offset(topNameCompanyConstraint / 3)
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
        }
        
        chooseCompanyPicker.snp.makeConstraints { make in
            //            make.top.equalTo(priceChangesStockLabel).offset(topNameCompanyConstraint / 1.5)
            make.height.equalTo(heightChooseCompanyPicker)
            make.left.equalTo(self).offset(5)
            make.right.equalTo(self).offset(-5)
            make.bottom.equalTo(self).offset(-5)
        }
    }
    
    private func hideViews() {
        nameCompanyLabel.text = ""
        currentPriceStockLabel.text = ""
        priceChangesStockLabel.text = ""
        logoCompanyImageView.image = nil
    }
}

extension StocksView: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let nameCompaniesArray = delegate.getCompanyArrayFromModel()
        loadingIndicator.startAnimating()
        hideViews()
        return nameCompaniesArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        loadingIndicator.startAnimating()
        delegate.companyWasSelected(row)
        hideViews()
    }
}

extension StocksView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return delegate.getCompanyArrayFromModel().count
    }
}
