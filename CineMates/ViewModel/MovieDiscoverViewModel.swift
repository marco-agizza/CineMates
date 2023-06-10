//
//  MovieDBViewModel.swift
//  CineMates
//
//  Created by Marco Agizza on 12/05/23.
//

import Foundation
import Combine

@MainActor
class MovieDiscoverViewModel: ObservableObject {
    @Published var trendingMovies: [ShowItem] = []
    @Published var searchedMovies: [ShowItem] = []
    private let networkInstance = Network<TrendingShowResults>()
    private let apiKey = "9de54757897ae119b171a32889b8fcd0"
    private let scheme = "https"
    private let host = "api.themoviedb.org"
    private let trendingPath = "/3/trending/all/week"
    private let searchingPath = "/3/search/multi"
    
    // Example: https://api.themoviedb.org/3/movie/550?api_key=9de54757897ae119b171a32889b8fcd0
    /*
     scheme:    https
     host:      api.themoviedb.org
     path:      3/movie/550
     */
    // Tranding movies: https://api.themoviedb.org/3/trending/movie/week?api_key=9de54757897ae119b171a32889b8fcd0
    /*
     scheme:    https
     host:      api.themoviedb.org
     path:      3/trending/movie/week
     */
    // Latest movies: https://api.themoviedb.org/3/movie/latest?api_key=9de54757897ae119b171a32889b8fcd0&language=en-US
    /*
     scheme:    https
     host:      api.themoviedb.org
     path:      3/movie/latest
     queryItems:[URLQueryItem(name: "language", value: "swift")]
     */
    // Search shows by text: "https://api.themoviedb.org/3/search/multi?api_key=9de54757897ae119b171a32889b8fcd0&language=en-US&page=1&include_adult=false&query=casa
    
    func loadTrending() async {
        do {
            let trendingShowResults = try await networkInstance.list(
                scheme: scheme,
                host: host,
                path: trendingPath,
                apiKey: apiKey
            )
            trendingMovies = trendingShowResults?.results ?? []
            
        } catch {
            let error = ResponseHandler.shared.mapError(error)
            print(error.localizedDescription)
        }
    }
    
    func searchShow(by searchKey: String) async {
        do {
            let searchMovieResults = try await networkInstance.list(
                scheme: scheme,
                host: host,
                path: searchingPath,
                apiKey: apiKey,
                queryItems: [
                    URLQueryItem(name: "language", value: "en-US"),
                    URLQueryItem(name: "page", value: "1"),
                    URLQueryItem(name: "include_adult", value: "false"),
                    URLQueryItem(name: "query", value: "\(searchKey)")
                ]
            )
            searchedMovies = searchMovieResults?.results ?? []
        } catch {
            let error = ResponseHandler.shared.mapError(error)
            print(error.localizedDescription)
        }
    }
    
}
