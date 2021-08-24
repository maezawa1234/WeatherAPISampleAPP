//
//  WeatherViewModel.swift
//  WeatherAPISampleApp
//
//  Created by 前澤健一 on 2021/08/23.
//

import RxSwift
import RxCocoa

class WeatherViewModel {
    
    // MARK: - Inputs
    let searchButtonClicked = PublishRelay<Void>()
    let searchBarText = PublishRelay<String>()
    
    // MARK: - Outputs
    let weatherResponse: Driver<[ListItem]>
    let isLoading: Driver<Bool>
    let showErrorAlert: Driver<String>
    
    private let disposeBag = DisposeBag()
    
    init(weatherService: WeatherService = WeatherService()) {
        // サーチボタンのタップでイベント発行される
        let searchEvent = self.searchButtonClicked
            .withLatestFrom(searchBarText)
            .filter { !$0.isEmpty }
            .distinctUntilChanged()
        
        // API結果
        let apiResult = searchEvent
            .flatMapLatest { text -> Observable<Event<(CurrentWeatherResponse, ForecastWeatherResponse)>> in
                let current = weatherService.getCurrentWeather(query: text)
                let forecast = weatherService.getForecastFeather(query: text)
                return Observable.zip(current, forecast).materialize()
            }
            .share(replay: 1)     // HotObservableに変換

        // 天気
        let weatherSequence = apiResult
            .compactMap { $0.element }
            .asDriver(onErrorDriveWith: .empty())

        // エラー
        let errorSequence = apiResult
            .compactMap { $0.error }
            .map { error -> String in
                if let apiError = error as? WeatherAPIError {
                    return apiError.message
                }
                return error.localizedDescription
            }
            .asDriver(onErrorDriveWith: .empty())

        // TableViewItems
        self.weatherResponse = weatherSequence
            .map { current, forecast in
                return [.current(current)] + forecast.list.map { ListItem.forecast($0)}
            }

        // ローディングアニメーション
        self.isLoading = Observable
            .merge(searchEvent.map { _ in true },
                   apiResult.map { _ in false })
            .asDriver(onErrorDriveWith: .empty())
        
        // エラーアラート表示
        self.showErrorAlert = errorSequence
    }
    
    // TableViewItem (２種類のCellデータ)
    enum ListItem {
        case current(CurrentWeatherResponse)
        case forecast(ForecastListObject)
    }
}
