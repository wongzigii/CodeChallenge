import UIKit

class CurrencyListViewController: UIViewController {

    // MARK: -
    // MARK: Variable

    // currencies variable
    var currencies: CurrencyEnvelope.Currency = [:] {
        didSet {
            currencyKeys = currencies.keys.sorted()
            tableView.reloadData()
        }
    }

    // CurrencyListViewController delegate
    weak var delegate: CurrencyListViewControllerDelegate?

    // lazy init tableview
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: UIScreen.main.bounds, style: .grouped)
        tv.delegate = self
        tv.dataSource = self
        tv.register(CurrencyListTableViewCell.self, forCellReuseIdentifier: CurrencyListTableViewCell.reuseIdentifier)
        return tv
    }()

    // Array of all currency keys
    private (set) var currencyKeys: [String] = []

    // MARK: -
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Select Source Currency"

        view.addSubview(tableView)
        NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0.0).isActive =  true
        NSLayoutConstraint(item: tableView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0.0).isActive =  true
        NSLayoutConstraint(item: tableView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0.0).isActive =  true
        NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0.0).isActive =  true

        NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0.0).isActive =  true
        NSLayoutConstraint(item: tableView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0.0).isActive =  true
        NSLayoutConstraint(item: tableView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0.0).isActive =  true
        NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0.0).isActive =  true

        getCurrenciesList()
    }

    func getCurrenciesList() {
        NetworkService.shared.list { [weak self] result in
            switch result {
            case let .success(value):
                guard let self = self else { return }
                self.currencies = value.currencies
            case let .failure(err):
                print(err)
            }
        }
    }
}

// MARK: -
// MARK: UITableViewDataSource
extension CurrencyListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CurrencyListTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        let key = currencyKeys[indexPath.row]
        let info = CurrencyInfo(source: nil, name: key, description: currencies[key]!, base: nil)
        cell.configure(with: info)
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencyKeys.count
    }
}

// MARK: -
// MARK: UITableViewDelegate
extension CurrencyListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let key = currencyKeys[indexPath.row]
        self.delegate?.didSelectCurrency(currency: key)
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
}

// MARK: -
// MARK: CurrencyListViewControllerDelegate
protocol CurrencyListViewControllerDelegate: class {

    func didSelectCurrency(currency: String)
}
