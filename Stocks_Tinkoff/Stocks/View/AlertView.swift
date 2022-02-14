import UIKit
import SnapKit

final class AlertView: UIView {
    
    private var viewDelegate: StocksViewProtocol
    
    //     MARK: - views
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("title", comment: "Alert")
        label.minimumScaleFactor = 0.7
        label.adjustsFontSizeToFitWidth = true
        label.font = .systemFont(ofSize: titleFontSize)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("subtitle", comment: "Alert")
        label.minimumScaleFactor = 0.7
        label.adjustsFontSizeToFitWidth = true
        label.font = .systemFont(ofSize: subtitleFontSize)
        label.textAlignment = .center
        label.textColor = .lightGray
        return label
    }()
    
    private lazy var reloadButton: UIButton = {
        let but = UIButton()
        but.setTitle(NSLocalizedString("buttonTitle", comment: "Alert"), for: .normal)
        but.addTarget(self, action: #selector(reload), for: .touchUpInside)
        but.setTitleColor(.systemBlue, for: .normal)
        return but
    }()
    
    
    //    MARK: - font sizes
    private lazy var titleFontSize = UIScreen.main.bounds.height / 30
    private lazy var subtitleFontSize = UIScreen.main.bounds.height / 40
    
    init(view: StocksViewProtocol) {
        self.viewDelegate = view
        super.init(frame: UIScreen.main.bounds)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(reloadButton)
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.bottom.equalTo(subtitleLabel.snp_topMargin).offset(-15)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.centerX.equalTo(self)
        }
        
        reloadButton.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(subtitleLabel.snp_bottomMargin).offset(25)
        }
    }
    
    @objc func reload() {
        viewDelegate.reloadData()
    }
}
