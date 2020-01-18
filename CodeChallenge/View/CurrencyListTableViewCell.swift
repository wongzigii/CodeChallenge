import UIKit

class CurrencyListTableViewCell: ConfigurableCell<CurrencyInfo> {

    private lazy var flagIcon: UIImageView = UIImageView()

    private lazy var currencyLabel: UILabel = UILabel()

    private lazy var descriptionLabel: UILabel = UILabel()

    private lazy var rateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        return label
    }()
    
    private lazy var convertedLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        contentView.addSubview(flagIcon)
        contentView.addSubview(currencyLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(rateLabel)
        contentView.addSubview(convertedLabel)
        
        flagIcon.translatesAutoresizingMaskIntoConstraints = false
        currencyLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        rateLabel.translatesAutoresizingMaskIntoConstraints = false
        convertedLabel.translatesAutoresizingMaskIntoConstraints = false
        // flagIcon
        NSLayoutConstraint(item: flagIcon, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 48).isActive = true
        NSLayoutConstraint(item: flagIcon, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 32).isActive = true
        NSLayoutConstraint(item: flagIcon, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1.0, constant: 20).isActive = true
        NSLayoutConstraint(item: flagIcon, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1.0, constant: 0.0).isActive = true
        // currencyLabel
        NSLayoutConstraint(item: currencyLabel, attribute: .left, relatedBy: .equal, toItem: flagIcon, attribute: .right, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: currencyLabel, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1.0, constant: 0.0).isActive = true
        // descriptionLabel
        NSLayoutConstraint(item: descriptionLabel, attribute: .left, relatedBy: .equal, toItem: currencyLabel, attribute: .right, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: descriptionLabel, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1.0, constant: 0.0).isActive = true
        // rateLabel
        NSLayoutConstraint(item: rateLabel, attribute: .left, relatedBy: .equal, toItem: currencyLabel, attribute: .right, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: rateLabel, attribute: .top, relatedBy: .equal, toItem: descriptionLabel, attribute: .bottom, multiplier: 1.0, constant: 0.0).isActive = true
        // convertedLabel
        NSLayoutConstraint(item: convertedLabel, attribute: .left, relatedBy: .equal, toItem: rateLabel, attribute: .left, multiplier: 1, constant: 0.0).isActive = true
        NSLayoutConstraint(item: convertedLabel, attribute: .top, relatedBy: .equal, toItem: rateLabel, attribute: .bottom, multiplier: 1.0, constant: 0.0).isActive = true
    }

    override func configure(with config: CurrencyInfo) {
        flagIcon.image = UIImage(named: config.name.lowercased())
        currencyLabel.text = config.name
        descriptionLabel.text = config.description
        
        guard Storage.shared.lastPresistSource == config.source else {
            rateLabel.text = nil
            convertedLabel.text = nil
            return
        }
        
        let rates = Storage.shared.rates
        if let source = config.source, let rate = rates[source+config.name] {
            rateLabel.text = rate == 0.0 ? nil : "Exchange rate: \(rate)"
            if let base = config.base, let baseVal = Float(base) {
                convertedLabel.text = rate == 0.0 ? nil : "\(baseVal) \(source) = \(rate * baseVal) \(config.name)"
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
