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
    let weatherResponse: Driver<[WeatherResponse]>
    let showErrorAlert: Driver<String>
    
    private let disposeBag = DisposeBag()
    
    init(weatherService: WeatherService = WeatherService()) {
        let apiResponse = self.searchButtonClicked
            .withLatestFrom(searchBarText.compactMap { $0 })
            .flatMapLatest { text in
                return weatherService.getWeather(query: text).materialize()
            }
        
        let weatherSequence = apiResponse
            .compactMap { $0.element }
            .asDriver(onErrorDriveWith: .empty())
        
        let errorSequence = apiResponse
            .compactMap { $0.error }
            .map { error -> String in
                if let apiError = error as? WeatherAPIError {
                    return apiError.message
                }
                return error.localizedDescription
            }
        
        self.weatherResponse = weatherSequence.map { [$0] }
        self.showErrorAlert = errorSequence.asDriver(onErrorDriveWith: .empty())
    }
}
