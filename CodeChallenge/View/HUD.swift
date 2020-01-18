import UIKit.UIAlertController

class HUD {

    static func errorAlert(message: String) -> UIAlertController {

        let alert = UIAlertController(title: "Please use USD instead", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        return alert
    }
}
