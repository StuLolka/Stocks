import UIKit
final class InfoModel: InfoModelProtocol {

    func getInfoImage() -> UIImage? {
        if UIScreen.main.traitCollection.userInterfaceStyle == .dark {
            return UIImage(named: "info_screen_dark_theme")
        }
        else {
            return UIImage(named: "info_screen_light_theme")
        }
    }
}
