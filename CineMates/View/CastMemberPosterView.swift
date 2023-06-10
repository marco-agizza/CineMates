//
//  CastMemberPoster.swift
//  CineMates
//
//  Created by Marco Agizza on 16/05/23.
//

import SwiftUI

struct CastMemberPosterView: View {
    
    let castMember: CastProfile
    
    var body: some View {
        VStack {
            AsyncImage(url: castMember.photoUrl) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 100, height: 120)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                case .failure:
                    Image(systemName: "person")
                @unknown default:
                    // Since the AsyncImagePhase enum isn't frozen,
                    // we need to add this currently unused fallback
                    // to handle any new cases that might be added
                    // in the future:
                    EmptyView()
                }
                
            }
            Text(castMember.name)
                .lineLimit(1)
                .frame(width: 100)
        }
    }
}
