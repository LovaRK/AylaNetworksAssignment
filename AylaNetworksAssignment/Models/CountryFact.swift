//
//  CountryInfo.swift
//  AylaNetworksAssignment
//
//  Created by MA1424 on 27/02/24.
//

import Foundation


// MARK: - CountryFactsResponse
struct CountryFactsResponse: Codable {
    let title: String
    let rows: [CountryFact]
}

// MARK: - CountryFact
struct CountryFact: Codable {
    let title, description: String?
    let imageHref: String?
}
