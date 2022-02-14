import UIKit
protocol InfoViewControllerProtocol: UIViewController {
    func getInfoImage() -> UIImage?
}

protocol InfoPresenterProtocol {
    var view: InfoViewControllerProtocol? { get set }
    var model: InfoModelProtocol? { get set }
    
    func getInfoImage() -> UIImage?
}

final class InfoPresenter: InfoPresenterProtocol {
    var view: InfoViewControllerProtocol?
    var model: InfoModelProtocol?
    
    func getInfoImage() -> UIImage? {
        guard let model = model else {
            assertionFailure("Model in presenter = nil")
            return nil
        }
        return model.getInfoImage()
    }
}
