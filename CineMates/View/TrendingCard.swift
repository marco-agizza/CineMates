//
//  TrendingCard.swift
//  CineMates
//
//  Created by Marco Agizza on 13/05/23.
//

import SwiftUI

struct TrendingCard: View {
    
    let trendingShow: ShowItem
    var typeLabel: String {
        switch(trendingShow.mediaType) {
        case "movie": return "Movie"
        case "tv": return "Series"
        case "person": return "Actor"
        default:
            return "boh"
        }
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            moviePoster
            movieInfos
        }
        .frame(width: 260, height: 170)
        .cornerRadius(23)
    }
    
    struct TrendingCard_Previews: PreviewProvider {
        static var previews: some View {
            TrendingCard(trendingShow: .mock)
        }
    }
    
}

extension TrendingCard {
    
    var moviePoster: some View {
        AsyncImage(url: trendingShow.backdropURL) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
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
    }
    
    var movieInfos: some View {
        VStack {
            HStack {
                Spacer()
                Text(typeLabel)
                    .padding(.horizontal, 8)
                    .foregroundColor(.accentColor)
                    .fontWeight(.regular)
                    .cornerRadius(15.0)
                    .background(
                        RoundedRectangle(cornerRadius: 18)
                            .foregroundColor(.white)
                    )
                    .opacity(0.86)
                    .shadow(radius: 5)
                    .padding(.horizontal)
            }
            .padding()
            Spacer()
            HStack {
                Text(typeLabel == "Movie" ? trendingShow.title! : trendingShow.name!)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.white)
                        .fontWeight(.heavy)
                        .frame(height: 85)
                        .padding(.horizontal, 32)
                
                Spacer()
            }
            
        }
        .background(
            LinearGradient(gradient: Gradient(colors: [.black, .white.opacity(0.02)]), startPoint: .bottom, endPoint: .center)
        )
    }
    
}
