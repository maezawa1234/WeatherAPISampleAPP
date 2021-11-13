//
//  WeatherViewModel.swift
//  WeatherAPISampleApp
//
//  Created by 前澤健一 on 2021/08/23.
//

import RxSwift
import RxCocoa

final class WeatherViewModel {

    // MARK: - Inputs
    struct Input {
        let searchButtonClicked = PublishRelay<Void>()
        let searchBarText = PublishRelay<String>()
    }

    // MARK: - Outputs
    struct Output {
        let weather: Driver<[ListItem]>
        let isLoading: Driver<Bool>
        let showErrorAlert: Driver<String>
    }
    
    let input: Input = Input()
    let output: Output

    private let disposeBag = DisposeBag()
    
    init(weatherService: WeatherService = WeatherService()) {
        // サーチボタンのタップでイベント発行される
        let searchEvent = input.searchButtonClicked
            .withLatestFrom(input.searchBarText)
            .filter { !$0.isEmpty }
            .distinctUntilChanged()     // 同じ値が連続したら無視
        
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
            .map { APIError(error: $0).message }
            .asDriver(onErrorDriveWith: .empty())

        // TableViewItems
        let weatherOutput = weatherSequence
            // TableViewItemの配列に変換
            .map { current, forecast in
                return [.current(current)] + forecast.list.map { ListItem.forecast($0)}
            }
        
        // ローディングアニメーション
        let isLoadingOutput = Observable
            .merge(searchEvent.map { _ in true },
                   apiResult.map { _ in false })
            .asDriver(onErrorDriveWith: .empty())
        
        // エラーアラート表示
        let showErrorAlertOutput = errorSequence
        
        self.output = Output(weather: weatherOutput,
                             isLoading: isLoadingOutput,
                             showErrorAlert: showErrorAlertOutput)
    }
}

extension WeatherViewModel {

    // TableViewItem (２種類のCellデータ)
    enum ListItem {
        case current(CurrentWeatherResponse)
        case forecast(ForecastListObject)
    }
}
