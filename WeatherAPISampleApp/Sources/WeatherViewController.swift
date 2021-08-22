//
//  WeatherViewController.swift
//  WeatherAPISampleApp
//
//  Created by 前澤健一 on 2021/08/23.
//

import RxSwift
import RxCocoa
import RxDataSources
import APIKit

class WeatherViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!

    private let viewModel = WeatherViewModel()
    private let disposeBag = DisposeBag()

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
        tableView.register(UINib(nibName: WeatherWeeklyCell.className, bundle: nil), forCellReuseIdentifier: WeatherWeeklyCell.className)
    }
    
    private func bind() {
        searchBar.rx.text.asObservable()
            .bind(to: viewModel.searchBarText)
            .disposed(by: disposeBag)
        
        searchBar.rx.searchButtonClicked.asObservable()
            .bind(to: viewModel.searchButtonClicked)
            .disposed(by: disposeBag)
        
        viewModel.weatherResponse
            .drive(tableView.rx.items) { tableView, row, element in
                let cell = tableView.dequeueReusableCell(withIdentifier: WeatherSummaryCell.className, for: [0, row]) as! WeatherSummaryCell
                cell.configure(with: element)
                return cell
            }
            .disposed(by: disposeBag)
        
        viewModel.showErrorAlert
            .drive(onNext: { [weak self] message in
                let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alertController, animated: true)
            })
            .disposed(by: disposeBag)
    }
}
