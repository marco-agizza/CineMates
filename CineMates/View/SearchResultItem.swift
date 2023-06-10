//
//  SearchResultItem.swift
//  CineMates
//
//  Created by Marco Agizza on 13/05/23.
//

import SwiftUI

struct SearchResultItem: View {
    
    let resultShow: ShowItem
    var typeLabel: String {
        switch(resultShow.mediaType) {
        case "movie": return "Movie"
        case "tv": return "Series"
        case "person": return "Actor"
        default:
            return "boh"
        }
    }
    
    var body: some View {
        HStack {
            moviePoster
                .padding(.horizontal)
            movieInfos
            Spacer()
        }
        .padding()
    }
}

struct SearchResultItem_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultItem(resultShow: .mock)
    }
}

extension SearchResultItem {
    
    var moviePoster: some View {
        AsyncImage(url: resultShow.posterURL) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
                    .resizable()
            case .failure:
                Image(systemName: "popcorn")
            @unknown default:
                // Since the AsyncImagePhase enum isn't frozen,
                // we need to add this currently unused fallback
                // to handle any new cases that might be added
                // in the future:
                EmptyView()
            }
        }
        .frame(width: 80, height: 120)
    }
    
    var movieInfos: some View {
            Text(typeLabel == "Movie" ? resultShow.title! : resultShow.name!)
                    .multilineTextAlignment(.leading)
                    .fontWeight(.heavy)
                    .frame(height: 85)
                    .padding(.horizontal, 32)
                
    }
}
