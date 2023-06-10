//
//  ContentView.swift
//  CineMates
//
//  Created by Marco Agizza on 11/05/23.
//

import SwiftUI

struct DiscoverView: View {
    
    @StateObject var viewModel = MovieDiscoverViewModel()
    @State var searchText = ""
    
    @ViewBuilder
    var content: some View {
        ScrollView {
            if searchText.isEmpty {
                if viewModel.trendingMovies.isEmpty {
                    ProgressView()
                } else {
                    DiscoverShowsView
                        .padding()
                }
            } else {
                LazyVStack {
                    ForEach (viewModel.searchedMovies) { searchedShow in
                        NavigationLink(
                            destination: MovieDetailsView(movie: searchedShow),
                            label: {
                                SearchResultItem(resultShow: searchedShow)
                                    .foregroundColor(.primary)
                            }
                        )
                    }
                }
            }
        }
    }
    
    var DiscoverShowsView: some View {
        VStack {
            HStack {
                Text("Top rated")
                    .font(.title)
                    .fontWeight(.heavy)
                Spacer()
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(viewModel.trendingMovies) { trendingItem in
                        NavigationLink(
                            destination: MovieDetailsView(movie: trendingItem),
                            label: {
                                TrendingCard(trendingShow: trendingItem)
                            }
                        )
                    }
                }
            }
            Spacer()
        }
    }
    
    var body: some View {
        NavigationStack {
            content
                .searchable(text: $searchText)
                .onChange(of: searchText) { newValue in
                    Task {
                        if searchText.count > 1 {
                            await viewModel.searchShow(by: searchText)
                        }
                    }
                }
        }
        .task {
            await viewModel.loadTrending()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView()
    }
}
