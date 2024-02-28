//
//  CountryInfoViewModel.swift
//  AylaNetworksAssignment
//
//  Created by MA1424 on 27/02/24.
//

import Foundation
import RxSwift
import RxCocoa

class CountryFactsViewModel {
    let title = BehaviorSubject<String>(value: "")
    let facts = BehaviorSubject<[CountryFact]>(value: [])
    let errorMessage = PublishSubject<String>()  
    private let disposeBag = DisposeBag()
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func fetchCountryFacts() {
        networkService.request(endpoint: CountryFactsEndpoint())
            .subscribe(onNext: { [weak self] (response: CountryFactsResponse) in
                self?.title.onNext(response.title)
                self?.facts.onNext(response.rows)
            }, onError: { [weak self] error in
                self?.errorMessage.onNext(error.localizedDescription)
            }).disposed(by: disposeBag)
    }
}
