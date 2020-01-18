import UIKit

class MainViewController: UIViewController {

    // MARK: -
    // MARK: Lazy Initial
    lazy var sourceButton: CurrencyButton = {
        let btn = CurrencyButton()
        btn.currency = Storage.shared.getSelectedCurrency()
        btn.addTarget(self, action: #selector(selectCurrency), for: .touchUpInside)
        return btn
    }()

    lazy var sourceTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .white
        tf.placeholder = "Enter amount"
        tf.keyboardType = .numberPad
        tf.delegate = self
        return tf
    }()

    var lastPresistDate: Date? {
        didSet {
            if let lastPresistDate = lastPresistDate {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm"
                presistDateLabel.text = "Last Presist Date: \(formatter.string(from: lastPresistDate)) \n Click left button to select another source currency."
            }

        }
    }

    lazy var presistDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .black
        label.numberOfLines = 2
        label.text = "Click left button to select another source currency."
        return label
    }()

    lazy var tableView: UITableView = {
        let tv = UITableView(frame: UIScreen.main.bounds, style: .grouped)
        tv.delegate = self
        tv.dataSource = self
        tv.register(CurrencyListTableViewCell.self, forCellReuseIdentifier: CurrencyListTableViewCell.reuseIdentifier)
        return tv
    }()

    var currencies: CurrencyEnvelope.Currency = [:] {
        didSet {
            currencyKeys = currencies.keys.sorted()
            tableView.reloadData()
        }
    }

    // Array of all currency keys
    private var currencyKeys: [String] = []

    // MARK: -
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let source = sourceButton.currency {
            self.navigationItem.title = "Current Source: \(source)"
        }
        
        
        // Load Data
        // First of all, we can load the presisted currencies list
        getCurrenciesList()

        // UI and autolayout
        self.view.backgroundColor = UIColor.backgroundColor
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing)))
        view.addSubview(sourceButton)
        view.addSubview(sourceTextField)
        view.addSubview(tableView)
        view.addSubview(presistDateLabel)

        sourceButton.translatesAutoresizingMaskIntoConstraints = false
        sourceTextField.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        presistDateLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint(item: sourceButton, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 79).isActive = true
        NSLayoutConstraint(item: sourceButton, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 32).isActive = true

        NSLayoutConstraint(item: sourceTextField, attribute: .centerY, relatedBy: .equal, toItem: sourceButton, attribute: .centerY, multiplier: 1, constant: 0.0).isActive = true
        NSLayoutConstraint(item: sourceTextField, attribute: .left, relatedBy: .equal, toItem: sourceButton, attribute: .right, multiplier: 1, constant: 32).isActive = true
        NSLayoutConstraint(item: sourceTextField, attribute: .top, relatedBy: .equal, toItem: sourceButton, attribute: .top, multiplier: 1, constant: 0.0).isActive = true
        NSLayoutConstraint(item: sourceTextField, attribute: .bottom, relatedBy: .equal, toItem: sourceButton, attribute: .bottom, multiplier: 1, constant: 0.0).isActive = true

        NSLayoutConstraint(item: presistDateLabel, attribute: .top, relatedBy: .equal, toItem: sourceButton, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: presistDateLabel, attribute: .left, relatedBy: .equal, toItem: sourceButton, attribute: .left, multiplier: 1, constant: 32).isActive = true
        NSLayoutConstraint(item: presistDateLabel, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true

        NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: sourceButton, attribute: .bottom, multiplier: 1, constant: 50.0).isActive =  true
        NSLayoutConstraint(item: tableView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0.0).isActive =  true
        NSLayoutConstraint(item: tableView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0.0).isActive =  true
        NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0.0).isActive =  true

    }

    // MARK: -
    // MARK: Action
    @IBAction func selectCurrency(sender: CurrencyButton) {
        let vc = CurrencyListViewController()
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func endEditing() {
        view.endEditing(true)
    }

    // MARK: -
    // MARK: Network Request

    /// fetch the list of available currencies
    func getCurrenciesList() {
        NetworkService.shared.list { [weak self] result in
            switch result {
            case let .success(value):
                guard let self = self else { return }
                guard value.success else {
                    let vc = HUD.errorAlert(message: value.error.debugDescription)
                    self.present(vc, animated: true, completion: nil)
                    return
                }
                self.currencies = value.currencies

            case let .failure(err):
                print(err)
            }
        }
    }
}

// MARK: -
// MARK: UITextFieldDelegate
extension MainViewController: UITextFieldDelegate {

    func getLiveRate() {
        guard let source = sourceButton.currency else { return }

        NetworkService.shared.live(source: source, currencies: currencyKeys) { [weak self] result in

            guard let self = self else { return }
            switch result {
            case let .success(value):
                guard value.success, let quotes = value.quotes else {
                    let vc = HUD.errorAlert(message: value.error.debugDescription)
                    self.present(vc, animated: true, completion: nil)
                    return
                }

                // presist the quote
                if let source = value.source {
                    Storage.shared.saveSelectedCurrency(value: source)
                }
                
                Storage.shared.presistLiveExchangeRate(rates: quotes)
                // Update  lastPresistDate
                self.lastPresistDate = Date()
            case let .failure(err):
                print(err)
            }
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let amount = textField.text, amount != "" else { return }
        
        // Note: If we select another source, we should fetch the rate immediately
        // regardless of the limit
        
        if Storage.shared.lastPresistSource != sourceButton.currency {
            getLiveRate()
            return
        }
        
        // otherwise, we can check the storage's `uselocalRate`
        // to determinate whether fetch the rate or not
        if Storage.shared.uselocalRate {
            tableView.reloadData()
        } else {
            getLiveRate()
        }
    }
}

// MARK: -
// MARK: UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CurrencyListTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        let key = currencyKeys[indexPath.row]

        if let source = sourceButton.currency, let description = currencies[key] {
            let info = CurrencyInfo(source: source, name: key, description: description, base: sourceTextField.text)
            cell.configure(with: info)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencyKeys.count
    }
}

// MARK: -
// MARK: UITableViewDelegate
extension MainViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
}

extension MainViewController: CurrencyListViewControllerDelegate {
    func didSelectCurrency(currency: String) {
        self.sourceButton.currency = currency
        self.sourceTextField.text = nil
        self.navigationController?.popViewController(animated: true)
        self.navigationItem.title = "Current Source: \(currency)"
        self.tableView.reloadData()
    }
}
