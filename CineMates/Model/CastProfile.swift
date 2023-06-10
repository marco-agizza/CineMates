//
//  CastProfile.swift
//  CineMates
//
//  Created by Marco Agizza on 16/05/23.
//

import Foundation

struct CastProfile: Decodable, Identifiable {
    let birthday: String?
    let id: Int
    let name: String
    let profilePath: String?
    
    var photoUrl: URL? {
        let baseURL = URL(string: "https://image.tmdb.org/t/p/w300")! // check if u can better manage this
        return baseURL.appending(path: profilePath ?? "")
    }
}
