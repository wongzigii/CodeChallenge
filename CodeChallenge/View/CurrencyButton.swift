import UIKit.UIButton

// Custom Button
final class CurrencyButton: UIButton {

    var currency: String? {
        didSet {
            if let value = currency {
                icon.image = UIImage(named: value.lowercased())
                label.text = value
            }
        }
    }

    private lazy var icon: UIImageView = UIImageView()

    private lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)

        self.backgroundColor = .white
        addSubview(icon)
        addSubview(label)

        icon.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint(item: icon, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0.0).isActive = true
        NSLayoutConstraint(item: icon, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 10).isActive = true

        NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0.0).isActive = true
        NSLayoutConstraint(item: label, attribute: .left, relatedBy: .equal, toItem: icon, attribute: .right, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: label, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: -10).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
