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
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bind()
    }
    
    private func setupView() {
        
    }
    
    private func bind() {
        let searchBarTextObservable = searchBar.rx.text.orEmpty.asObservable()
        
        searchBar.rx.searchButtonClicked.asObservable()
            .withLatestFrom(searchBarTextObservable)
            .subscribe(onNext: { text in
                let request = WeatherAPI.FetchWeatherRequest(queryKeyword: text)
                Session.shared.send(request) { result in
                    switch result {
                    case .success(let response):
                        print("get data!")
                        print(response)
                    case .failure(let error):
                        print(error)
                    }
                }
            })
            .disposed(by: disposeBag)
    }
}
