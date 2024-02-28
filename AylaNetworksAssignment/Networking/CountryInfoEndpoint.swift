//
//  CountryInfoEndpoint.swift
//  AylaNetworksAssignment
//
//  Created by MA1424 on 27/02/24.
//

import Foundation

protocol URLRequestConvertible {
    func asURLRequest() -> URLRequest
}

struct CountryFactsEndpoint: URLRequestConvertible {
    func asURLRequest() -> URLRequest {
        guard let url = URL(string: "https://mocki.io/v1/ac63619f-c6c8-4dac-82a3-45a62c767141") else {
            fatalError("Invalid URL") // Ideally handle this more gracefully
        }
        return URLRequest(url: url)
    }
}



