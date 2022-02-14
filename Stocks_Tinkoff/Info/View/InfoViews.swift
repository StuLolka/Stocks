import UIKit
import SnapKit

final class InfoViews: UIView, InfoViewsProtocol {
    
    private let delegate: InfoViewControllerProtocol
    
    private lazy var infoImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("infoLabel", comment: "Info")
        label.minimumScaleFactor = 0.7
        label.adjustsFontSizeToFitWidth = true
        label.font = .systemFont(ofSize: infoLabelFontSize)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    //MARK: - font
    private lazy var infoLabelFontSize = UIScreen.main.bounds.height / 35
    
    //MARK: - size
    private lazy var infoImageViewSize = UIScreen.main.bounds.height / 2
    
    init(delegate view: InfoViewControllerProtocol) {
        self.delegate = view
        super.init(frame: UIScreen.main.bounds)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupInfoImage() {
        infoImageView.image = delegate.getInfoImage()
    }
    
    private func setupConstraints() {
        addSubview(infoImageView)
        addSubview(infoLabel)

        infoImageView.snp.makeConstraints { make in
            make.left.equalTo(self).offset(15)
            make.right.equalTo(self).offset(-15)
            make.top.equalTo(snp_topMargin)
            make.height.equalTo(infoImageViewSize)
            make.bottomMargin.equalTo(infoLabel.snp_topMargin).offset(-35)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.left.equalTo(self).offset(15)
            make.right.equalTo(self).offset(-15)
            make.bottomMargin.equalTo(self).offset(-25)
        }
    }
}
