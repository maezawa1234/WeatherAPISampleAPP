//
//  SearchHistoryViewController.swift
//  WeatherAPISampleApp
//
//  Created by 前澤健一 on 2021/10/19.
//

import UIKit
import RxSwift
import RxCocoa

protocol SearchHistoryViewControllerDelegate: AnyObject {
    func searchHistoryViewControllerDidSelect(_ searchWord: String)
}

final class SearchHistoryViewController: UIViewController {
    
    typealias Dependency = SearchHistoryViewModel
    
    // MARK: - UIProperties
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.register(cellType: SearchHistoryTableViewCell.self)
        }
    }
    @IBOutlet private weak var deleteHistoryButton: UIButton!
    
    private let viewModel: Dependency
    private let disposeBag = DisposeBag()
    weak var delegate: SearchHistoryViewControllerDelegate?
    
    init?(coder: NSCoder, dependency: Dependency) {
        self.viewModel = dependency
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been impslemented")
    }
    
    static func configure(with dependency: Dependency) -> Self {
        let vc = UIStoryboard(name: Self.className, bundle: nil)
            .instantiateInitialViewController { coder in
                SearchHistoryViewController(coder: coder, dependency: dependency)
            }! as! Self
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        bind()
    }
    
    private func setupView() {
    }
    
    private func bind() {
        searchBar.rx.text.asObservable()
            .bind(to: viewModel.searchBarText)
            .disposed(by: disposeBag)
        
        searchBar.rx.searchButtonClicked.asObservable()
            .bind(to: viewModel.searchButtonClicked)
            .disposed(by: disposeBag)
        
        deleteHistoryButton.rx.tap.asSignal()
            .emit(to: viewModel.deleteHistoryButtonClicked)
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected.asObservable()
            .bind(to: viewModel.itemSelected)
            .disposed(by: disposeBag)
        
        self.searchBar.text = viewModel.currentSearchBarText
        
        viewModel.tableItems
            .drive(tableView.rx.items) { tableView, row, element in
                let cell = tableView.dequeueReusableCell(with: SearchHistoryTableViewCell.self, for: [0, row])
                cell.configure(with: element)
                return cell
            }
            .disposed(by: disposeBag)
        
        viewModel.didSelectSearchWord
            .drive(onNext: { [weak self] text in
                self?.delegate?.searchHistoryViewControllerDidSelect(text)
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
}
