//
//  MovieDetailsViewModel.swift
//  CineMates
//
//  Created by Marco Agizza on 16/05/23.
//

import Foundation

enum MediaType {
    case movie
    case series
}

@MainActor
class ShowDetailsViewModel: ObservableObject {
    @Published var cast: [Cast] = []
    @Published var castProfiles: [CastProfile] = []
    private let movieNetworkInstance = Network<MovieCredits>()
    private let castMemberNetworkInstance = Network<CastProfile>()
    private var showID: Int?
    private var showType: MediaType?
    private let apiKey = "9de54757897ae119b171a32889b8fcd0"
    private let apiReadAccessToken = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI5ZGU1NDc1Nzg5N2FlMTE5YjE3MWEzMjg4OWI4ZmNkMCIsInN1YiI6IjY0NWNhYjU4MWI3MGFlMDBlMmFkZjNkMSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.FQEzBH0c6LSqITN87yBm67pMoeZKzqx23nWHvmtQuiw"
    private let scheme = "https"
    private let host = "api.themoviedb.org"
    private var showCreditPath: String? {
        if let showID = showID, let mediaType = showType {
            return "/3/\(mediaType == .movie ? "movie" : "tv")/\(showID)/credits"
        }
        return nil
    }
    
    func loadMovieCredits(movieID: Int, showType: MediaType) async {
        self.showID = movieID
        self.showType = showType
        do {
            if let showCreditPath {
                let movieCreditResults = try await movieNetworkInstance.list(scheme: scheme, host: host, path: showCreditPath, apiKey: apiKey, queryItems: [URLQueryItem(name: "language", value: "en-US")])
                cast = movieCreditResults?.cast.sorted(by: {$0.order < $1.order}) ?? []
            } else {
                throw NetworkError.badRequest
            }
        } catch {
            let error = ResponseHandler.shared.mapError(error)
            print(error.localizedDescription)
        }
    }
    
    func loadCastMemberProfiles() async {
        do {
            for member in cast {
                let castProfile = try await castMemberNetworkInstance.list(
                    scheme: scheme,
                    host: host,
                    path: "/3/person/\(member.id)",
                    apiKey: apiKey
                )
                if let castProfile {
                    castProfiles.append(castProfile)
                }
            }
        } catch {
            let error = ResponseHandler.shared.mapError(error)
            print(error.localizedDescription)
        }
    }
}
