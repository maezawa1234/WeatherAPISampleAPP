//
//  WeatherViewController.swift
//  WeatherAPISampleApp
//
//  Created by 前澤健一 on 2021/08/23.
//

import RxSwift
import RxCocoa
import RxDataSources

class WeatherViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var indicator: UIActivityIndicatorView! {
        didSet {
            indicator.hidesWhenStopped = true
        }
    }

    private let viewModel = WeatherViewModel()
    private let disposeBag = DisposeBag()

    // インスタンス化
    static func configure() -> Self {
        let viewController = UIStoryboard(name: Self.className, bundle: nil)
            .instantiateViewController(identifier: Self.className) as! Self
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bind()
    }
  
    private func setupView() {
        self.navigationItem.title = "Weather Sample App"
        tableView.register(UINib(nibName: WeatherSummaryCell.className, bundle: nil), forCellReuseIdentifier: WeatherSummaryCell.className)
        tableView.register(UINib(nibName: ForecastWeatherCell.className, bundle: nil), forCellReuseIdentifier: ForecastWeatherCell.className)
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    // ViewModelとデータバインド
    private func bind() {
        searchBar.rx.text.orEmpty.asObservable()
            .bind(to: viewModel.searchBarText)
            .disposed(by: disposeBag)

        searchBar.rx.searchButtonClicked.asObservable()
            .bind(to: viewModel.searchButtonClicked)
            .disposed(by: disposeBag)
        
        viewModel.weatherResponse
            .drive(tableView.rx.items) { tableView, row, element in
                switch element {
                case .current(let current):
                    let cell = tableView.dequeueReusableCell(withIdentifier: WeatherSummaryCell.className, for: [0, row]) as! WeatherSummaryCell
                    cell.configure(with: current)
                    return cell
                case .forecast(let forecast):
                    let cell = tableView.dequeueReusableCell(withIdentifier: ForecastWeatherCell.className, for: [0, row]) as! ForecastWeatherCell
                    cell.configure(with: forecast)
                    return cell
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .drive(onNext: { [weak self] isLoading in
                if isLoading {
                    UIView.animate(withDuration: 0.3) {
                        self?.indicator.startAnimating()
                        self?.tableView.alpha = 0.5
                    }
                } else {
                    UIView.animate(withDuration: 0.3) {
                        self?.indicator.stopAnimating()
                        self?.tableView.alpha = 1
                    }
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.showErrorAlert
            .drive(onNext: { [weak self] message in
                self?.showAlertController(message)
            })
            .disposed(by: disposeBag)
    }

    private func showAlertController(_ message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertController, animated: true)
    }
}
