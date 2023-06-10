//
//  MovieDetailsView.swift
//  CineMates
//
//  Created by Marco Agizza on 14/05/23.
//

import SwiftUI
import PartialSheet

struct MovieDetailsView: View {
    @StateObject var viewModel = ShowDetailsViewModel()
    @State var displayCompleteOverview = false
    let movie: ShowItem
    let headerHeight: CGFloat = 370
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                VStack {
                    AsyncImage(url: movie.backdropURL) { image in
                        ZStack {
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: geometry.size.width, maxHeight: headerHeight)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                    } placeholder: {
                        ProgressView()
                    }
                    Spacer()
                }
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading) {
                        Spacer()
                            .frame(height: headerHeight)
                        HStack{
                            switch(movie.mediaType){
                            case "movie":
                                Text(movie.title!)
                                    .font(.title)
                                    .fontWeight(.heavy)
                            default:
                                Text(movie.name!)
                                    .font(.title)
                                    .fontWeight(.heavy)
                            }
                            Spacer()
                        }
                        HStack {
                            Text("About the show")
                                .font(.title3)
                                .fontWeight(.bold)
                                .padding(.top, 20)
                            Spacer()
                            Button(
                                action: {displayCompleteOverview.toggle()}) {
                                    Text("more")
                                }
                        }
                        Text(movie.overview)
                            .lineLimit(2)
                            .foregroundColor(.secondary)
                        LazyHStack {
                            Text("Cast & Crew")
                                .font(.title3)
                                .fontWeight(.bold)
                                .padding(.top, 20)
                            Spacer()
                        }
                        if !viewModel.cast.isEmpty && !viewModel.castProfiles.isEmpty {
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack {
                                    ForEach(viewModel.castProfiles) { castMember in
                                        CastMemberPosterView(castMember: castMember)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .ignoresSafeArea()
        .toolbar(.visible, for: .navigationBar)
        .partialSheet(isPresented: $displayCompleteOverview, content: {
            Text(movie.overview)
                .multilineTextAlignment(.leading)
        })
        .task {
            await viewModel.loadMovieCredits(movieID: movie.id, showType: movie.mediaType == "movie" ? .movie : .series)
            await viewModel.loadCastMemberProfiles()
        }
    }
}

struct MovieDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailsView(movie: .mock)
    }
}
