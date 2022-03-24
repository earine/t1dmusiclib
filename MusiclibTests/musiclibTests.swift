//
//  musiclibTests.swift
//  musiclibTests
//
//  Created by mlunts on 19.03.2022.
//

import XCTest
import ComposableArchitecture
@testable import Musiclib

class musiclibTests: XCTestCase {
    private let mockedArtist = Artist(
        id: 1424821,
        name: "Lana Del Rey",
        pictureMedium: ""
    )

    private let mockedAlbum = Album(id: 0,
                                    title: "SAWAYAMA",
                                    coverMedium: nil,
                                    tracks: TracksResponse(data: [
                                        Track(id: 1,
                                              title: "Dynasty",
                                              duration: 329,
                                              contributors:
                                                [
                                                    Artist(id: 1,
                                                           name: "Rina Sawayama",
                                                           pictureMedium: "")
                                                ]
                                             ),
                                        Track(id: 2,
                                              title: "XS",
                                              duration: 298,
                                              contributors:
                                                []
                                             )
                                    ]))


    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testAlbumRequest() throws {
        let mockedAlbum = Album(id: 110497512,
                                title: "Charli",
                                coverMedium: "https://e-cdns-images.dzcdn.net/images/cover/9c7ad8c4c90f91fc1762a09b9bce257f/250x250-000000-80-0-0.jpg",
                                tracks: TracksResponse(data: [
                                ]))

        let ree = NetworkClient.shared.albumEffect(id: mockedAlbum.id)
            

    }

    func testArtistSearchResultFailure() throws {
        let store = TestStore(initialState: ChartsState(isSearching: true,
                                                        searchQuery: "",
                                                        artists: [],
                                                        searchedArtistsResult: [],
                                                        currentPage: 0),
                              reducer: chartsReducer,
                              environment: ChartsEnvironment(
                                chartsRequest: NetworkClient.shared.chartArtistsEffect,
                                searchArtistRequest: NetworkClient.shared.searchArtistEffect
                                )
                            )
        let result = Result<[Artist], APIError>.init(of: nil, or: APIError.decodingError)
        store.send(.searchResultDataLoaded(result)) { state in
            state.isSearching = true
            state.currentPage = 0
        }
    }

    func testArtistSearchResultSuccess() throws {
        let store = TestStore(initialState: ChartsState(isSearching: true,
                                                        searchQuery: "",
                                                        artists: [],
                                                        searchedArtistsResult: [],
                                                        currentPage: 0),
                              reducer: chartsReducer,
                              environment: ChartsEnvironment(
                                chartsRequest: NetworkClient.shared.chartArtistsEffect,
                                searchArtistRequest: NetworkClient.shared.searchArtistEffect
                                )
                            )
        let result = Result<[Artist], APIError>.init(of: [mockedArtist], or: nil)

        store.send(.searchResultDataLoaded(result)) { state in
            state.isSearching = true
            state.currentPage = 25
            state.searchedArtistsResult = [self.mockedArtist]
        }
    }

    func testArtistAlbumsDataLoadedFailureState() throws {
        let store = TestStore(initialState: ArtistState(artist: mockedArtist),
                              reducer: artistReducer,
                              environment: ArtistEnvironment(
                                artistAlbumsRequest: NetworkClient.shared.artistAlbumsEffect))
        let result = Result<[Album], APIError>.init(of: nil, or: APIError.decodingError)

        store.send(.albumsDataLoaded(result)) { $0.artist.albums = [] }
    }

    func testArtistAlbumsDataLoadedSuccessState() throws {
        let store = TestStore(initialState: ArtistState(artist: mockedArtist),
                              reducer: artistReducer,
                              environment: ArtistEnvironment(
                                artistAlbumsRequest: NetworkClient.shared.artistAlbumsEffect))

        let mockedAlbums = [mockedAlbum]
        let result = Result<[Album], APIError>.init(of: mockedAlbums, or: nil)
        store.send(.albumsDataLoaded(result)) { $0.artist.albums = mockedAlbums}
    }

    func testAlbumTracksLoadingState() throws {
        let store = TestStore(initialState: AlbumState(album: mockedAlbum),
                              reducer: albumReducer,
                              environment: AlbumEnvironment(
                                albumRequest: NetworkClient.shared.albumEffect,
                                trackRequest: NetworkClient.shared.trackInfoEffect
                              )
        )

        let updatedTrack = Track(id: 2,
                                 title: "XS",
                                 duration: 298,
                                 contributors:
                                    [
                                        Artist(id: 1,
                                               name: "Rina Sawayama",
                                               pictureMedium: "")
                                    ]
        )

        store.send(.updateTrack(updatedTrack)) { state in
            state.isLoading = false
        }
    }
}
