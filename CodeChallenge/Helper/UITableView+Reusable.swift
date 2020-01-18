import UIKit.UITableViewCell

protocol ReusableView {
    static var reuseIdentifier: String { get }
}

extension ReusableView where Self: UIView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReusableView {}

extension UITableView {

    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Unable to Dequeue Reusable Table View Cell")
        }
        return cell
    }
}

protocol ConfigurableType {}

extension CurrencyInfo: ConfigurableType {}
// Make other datastructs to conform `ConfigurableType` if need

class ConfigurableCell<T: ConfigurableType>: UITableViewCell {
    func configure(with config: T) {}
}
