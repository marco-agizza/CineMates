//
//  TrendingResults.swift
//  CineMates
//
//  Created by Marco Agizza on 13/05/23.
//

import Foundation

struct TrendingShowResults: Decodable {
    let page: Int
    let results: [ShowItem]
    let totalPages: Int
    let totalResults: Int
}
