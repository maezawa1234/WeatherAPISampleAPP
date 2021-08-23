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
    let searchBarText = PublishRelay<String?>()
    
    // MARK: - Outputs
    let weatherResponse: Driver<[ListItem]>
    let loadingIndicator: Driver<Bool>
    let showErrorAlert: Driver<String>
    
    private let disposeBag = DisposeBag()
    
    init(weatherService: WeatherService = WeatherService()) {
        
        let _indicator = BehaviorRelay<Bool>(value: false)
        self.loadingIndicator = _indicator.asDriver(onErrorDriveWith: .empty())
        
        // サーチボタンのタップでイベント発行される
        let apiResponse = self.searchButtonClicked
            .do(onNext: {
                _indicator.accept(true)
            })
            .withLatestFrom(searchBarText.compactMap { $0 })
            .flatMapLatest { text -> Observable<Event<(CurrentWeatherResponse, ForecastWeatherResponse)>> in
                let current = weatherService.getCurrentWeather(query: text)
                let forecast = weatherService.getForecastFeather(query: text)
                return Observable.zip(current, forecast).materialize()
            }
            .share(replay: 1)
        
        apiResponse
            .subscribe(onNext: { _ in
                _indicator.accept(false)
            })
            .disposed(by: disposeBag)
        
        // APIレスポンス
        let sequence = apiResponse
            .compactMap { $0.element }
            .asDriver(onErrorDriveWith: .empty())
        
        // APIエラー
        let errorSequence = apiResponse
            .compactMap { $0.error }
            .map { error -> String in
                if let apiError = error as? WeatherAPIError {
                    return apiError.message
                }
                return error.localizedDescription
            }
        
        // TableViewItems
        self.weatherResponse = sequence
            .map { current, forecast in
                return [.current(current)] + forecast.list.map { ListItem.forecast($0)}
            }
        
        // エラーアラート表示
        self.showErrorAlert = errorSequence.asDriver(onErrorDriveWith: .empty())
    }
    
    // TableViewItem (２種類のCellデータ)
    enum ListItem {
        case current(CurrentWeatherResponse)
        case forecast(ForecastListObject)
    }
}
