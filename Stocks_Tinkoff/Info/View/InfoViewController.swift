import UIKit

//MARK: - protocols
protocol InfoViewsProtocol: UIView {
    func setupInfoImage()
}

protocol InfoModelProtocol {
    func getInfoImage() -> UIImage?
}

//MARK: - class InfoViewController
final class InfoViewController: UIViewController, InfoViewControllerProtocol {
    
    private let presenter: InfoPresenterProtocol
    
    lazy private var customView: InfoViewsProtocol = InfoViews(delegate: self)
    
    init(presenter: InfoPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = customView
        customView.backgroundColor = .systemBackground
        setupNavigationBar()
    }

    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        customView.setupInfoImage()
    }
    
    func getInfoImage() -> UIImage? {
        presenter.getInfoImage()
    }
    
    private func setupNavigationBar() {
        title = NSLocalizedString("Info", comment: "Info")
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(closeViewController)
        )
    }
    
    @objc func closeViewController() {
        dismiss(animated: true, completion: nil)
    }
    
}
