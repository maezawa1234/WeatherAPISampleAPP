//
//  SearchHistoryViewModel.swift
//  WeatherAPISampleApp
//
//  Created by 前澤健一 on 2021/10/19.
//

import RxSwift
import RxCocoa

final class SearchHistoryViewModel {
    
    // MARK: - Input
    let searchBarText = PublishRelay<String?>()
    let searchButtonClicked = PublishRelay<Void>()
    let itemSelected = PublishRelay<IndexPath>()
    let deleteHistoryButtonClicked = PublishRelay<Void>()
    
    // MARK: - Output
    let currentSearchBarText: String
    let tableItems: Driver<[String]>
    let didSelectSearchWord: Driver<String>
    
    private let disposeBag = DisposeBag()
    
    init(currentSearchBarText: String) {
        let _searchHistoryList = BehaviorRelay(value: DataStoreService.shared.searchWordList)
        
        let searchBarEvent = searchButtonClicked
            .withLatestFrom(searchBarText)
            .compactMap { $0 }
            .filter { !$0.isEmpty }
            .distinctUntilChanged()
        
        let selectTableItemEvent = itemSelected
            .withLatestFrom(_searchHistoryList) { ($0, $1) }
            .map { indexPath, history in
                return history[indexPath.row]
            }
        
        let didSelectWordEvent = Observable
            .merge(searchBarEvent, selectTableItemEvent)
        
        didSelectWordEvent
            .withLatestFrom(_searchHistoryList) { ($0, $1) }
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { text, historyList in
                var saveList = [text] + historyList.filter { $0 != text }
                guard saveList.count <= 10 else {
                    saveList = saveList[(0...10)].map { $0 }
                    return
                }
                DataStoreService.shared.searchWordList = saveList
            })
            .disposed(by: disposeBag)
        
        deleteHistoryButtonClicked
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: {
                DataStoreService.shared.searchWordList = []
                _searchHistoryList.accept([])
            })
            .disposed(by: disposeBag)
        
        self.currentSearchBarText = currentSearchBarText
        self.didSelectSearchWord = didSelectWordEvent.asDriver(onErrorDriveWith: .empty())
        self.tableItems = Observable
            .merge(_searchHistoryList.asObservable(),
                   deleteHistoryButtonClicked.map { [] }.asObservable()
            )
            .asDriver(onErrorDriveWith: .empty())
    }
}
