//
//  ChartsEnvironment.swift
//  musiclib
//
//  Created by mlunts on 21.03.2022.
//

import ComposableArchitecture

struct ChartsEnvironment {
    var chartsRequest: () -> Effect<Chart, APIError>
    var searchArtistRequest: (String, Int) -> Effect<[Artist], APIError>
}

extension ChartsEnvironment {
    static func makeChartsEnvironment() -> ChartsEnvironment {
        ChartsEnvironment(chartsRequest: {
            return .future { callback in
                DispatchQueue.global(qos: .background).async {
                    NetworkClient.shared.chartArtists { result in
                        switch result {
                        case .success(let chart):
                            callback(.success(chart))
                        case .failure(let error):
                            callback(.failure(error))
                        }
                    }
                }
            }
        }, searchArtistRequest: { searchQuery, currentPage in
            return .future { callback in
                DispatchQueue.global(qos: .background).async {
                    NetworkClient.shared.searchArtist(searchQuery: searchQuery,
                                                            currentIndex: currentPage) { result in
                        switch result {
                        case .success(let artists):
                            callback(.success(artists.data))
                        case .failure(let error):
                            callback(.failure(error))
                        }
                    }
                }
            }
        })
    }
}
