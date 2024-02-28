//
//  NetworkService.swift
//  AylaNetworksAssignment
//
//  Created by MA1424 on 27/02/24.
//

import Foundation
import RxSwift

import Foundation
import RxSwift

protocol NetworkServiceProtocol {
    func request<T: Decodable>(endpoint: URLRequestConvertible) -> Observable<T>
}

class NetworkService: NetworkServiceProtocol {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func request<T: Decodable>(endpoint: URLRequestConvertible) -> Observable<T> {
        return Observable.create { observer in
            let request = endpoint.asURLRequest()
            let task = self.session.dataTask(with: request) { data, response, error in
                // Check for errors
                if let error = error {
                    observer.onError(error)
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode),
                      let data = data else {
                    observer.onError(NSError(domain: "InvalidResponse", code: 0, userInfo: nil))
                    return
                }

                do {
                    let decodedObject = try JSONDecoder().decode(T.self, from: data)
                    observer.onNext(decodedObject)
                    observer.onCompleted()
                } catch {
                    observer.onError(error)
                }
            }
            task.resume() 

            return Disposables.create {
                task.cancel()
            }
        }
    }
}

