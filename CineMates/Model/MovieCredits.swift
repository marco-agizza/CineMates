//
//  MovieCredits.swift
//  CineMates
//
//  Created by Marco Agizza on 16/05/23.
//

import Foundation

struct MovieCredits: Identifiable, Decodable {
    let id: Int
    let cast: [Cast]
}

struct Cast: Identifiable, Decodable {
    let name: String
    let id: Int
    let character: String
    let order: Int
    let photoURL: String?
}

