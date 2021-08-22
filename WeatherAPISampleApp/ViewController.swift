//
//  ViewController.swift
//  WeatherAPISampleApp
//
//  Created by 前澤健一 on 2021/08/22.
//

import RxSwift
import RxCocoa
import RxDataSources
import APIKit
import SwiftyJSON


class ViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var searchBar: UISearchBar!
    
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
            })
            .disposed(by: disposeBag)
    }

}

