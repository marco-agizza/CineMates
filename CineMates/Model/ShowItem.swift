//
//  MovieItem.swift
//  CineMates
//
//  Created by Marco Agizza on 12/05/23.
//

import Foundation

struct ShowItem: Identifiable, Decodable {
    let adult: Bool
    let id: Int
    let posterPath: String?
    let mediaType: String
    let title: String?  // movies
    let name: String?   // tv series
    let overview: String
    let voteAverage: Float
    let backdropPath: String?
    
    var backdropURL: URL {
        let baseURL = URL(string: "https://image.tmdb.org/t/p/original")!
        return baseURL.appending(path: backdropPath ?? "")
    }
    
    var lowBackdropURL: URL {
        let baseURL = URL(string: "https://image.tmdb.org/t/p/w300")!
        return baseURL.appending(path: backdropPath ?? "")
    }
    
    var posterURL: URL {
        let baseURL = URL(string: "https://image.tmdb.org/t/p/w500")!
        return baseURL.appending(path: posterPath ?? "")
    }
    
    static var mock: ShowItem {
        return ShowItem(adult: false, id: 12345, posterPath: "/r2J02Z2OpNTctfOSN1Ydgii51I3.jpg", mediaType: "movie", title: "Guardians of the Galaxy Vol. 3", name: "", overview: "I'm Groot!", voteAverage: 8.183, backdropPath: "/A7JQ7MIV5fkIxceI5hizRIe6DRJ.jpg")
    }
}
