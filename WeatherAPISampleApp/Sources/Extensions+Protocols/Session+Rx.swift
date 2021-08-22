//
//  Session+Rx.swift
//  WeatherAPISampleApp
//
//  Created by 前澤健一 on 2021/08/23.
//

import RxSwift
import APIKit

extension Session: ReactiveCompatible {}

extension RxSwift.Reactive where Base: Session {
    func send<T: Request>(request: T) -> Observable<T.Response> {
        return Observable<T.Response>.create { [weak base] observer in
            let task = base?.send(request) { result in
                switch result {
                case .success(let response):
                    observer.onNext(response)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create { task?.cancel() }
        }
    }
}
