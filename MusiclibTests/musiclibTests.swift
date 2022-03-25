//
//  musiclibTests.swift
//  musiclibTests
//
//  Created by mlunts on 19.03.2022.
//

import XCTest
import ComposableArchitecture
import SnapshotTesting
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

    private let mockedTrack = Track(id: 1528428352,
                                    title: "Text Book",
                                    duration: 303,
                                    contributors: [Artist(id: 1424821,
                                                          name: "Lana Del Rey",
                                                          pictureMedium: "https://e-cdns-images.dzcdn.net/images/artist/df76fa73a458af753cbe9e5ae64a33cd/250x250-000000-80-0-0.jpg")
                                    ])

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // MARK: - Request tests
    func testArtistAlbumsRequestFailure() throws {
        let expectation = expectation(description: "testArtistAlbumsRequestFailure")

        NetworkClient.shared.artistAlbums(id: 0) { result in
            switch result {
            case .success(let albums):
                break
            case .failure(let error):
                XCTAssertNotNil(error)
                break
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testArtistAlbumsRequestSuccess() throws {
        let expectation = expectation(description: "testArtistAlbumsRequestSuccess")

        NetworkClient.shared.artistAlbums(id: mockedArtist.id) { result in
            switch result {
            case .success(let albums):
                XCTAssertNotNil(albums.data)
                break
            case .failure(let error):
                XCTAssertNil(error)
                break
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testSearchArtistNoResultsRequestSuccess() throws {
        let expectation = expectation(description: "testSearchArtistNoResultsRequestSuccess")

        NetworkClient.shared.searchArtist(searchQuery: "Lanaa dek reey", currentIndex: 0) { result in
            switch result {
            case .success(let artists):
                XCTAssertTrue(artists.data.isEmpty)
                break
            case .failure(let error):
                XCTAssertNotNil(error)
                break
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testSearchArtistRequestSuccess() throws {
        let expectation = expectation(description: "testSearchArtistRequestSuccess")

        NetworkClient.shared.searchArtist(searchQuery: "Lana Del Rey", currentIndex: 0) { result in
            switch result {
            case .success(let artists):
                XCTAssertTrue(artists.data.contains(where: { $0.id == self.mockedArtist.id }))
                break
            case .failure(let error):
                XCTAssertNotNil(error)
                break
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testChartArtistsRequestSuccess() throws {
        let expectation = expectation(description: "testChartArtistsRequestSuccess")

        NetworkClient.shared.chartArtists { result in
            switch result {
            case .success(let chart):
                XCTAssertNotNil(chart.artists)
                break
            case .failure(let error):
                XCTAssertNotNil(error)
                break
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testTrackInfoRequestFailure() throws {
        let expectation = expectation(description: "testTrackInfoRequestFailure")

        NetworkClient.shared.trackInfo(id: 0) { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                XCTAssertNotNil(error)
                break
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testTrackInfoRequestSuccess() throws {
        let expectation = expectation(description: "testTrackInfoRequestSuccess")

        NetworkClient.shared.trackInfo(id: mockedTrack.id) { result in
            switch result {
            case .success(let track):
                XCTAssertEqual(self.mockedTrack, track)
                break
            case .failure(let error):
                XCTAssertTrue(error == .decodingError)
                break
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    // MARK: - Store tests
    func testArtistSearchResultFailure() throws {
        let store = TestStore(initialState: ChartsState(isSearching: true,
                                                        searchQuery: "",
                                                        artists: [],
                                                        searchedArtistsResult: [],
                                                        currentPage: 0),
                              reducer: chartsReducer,
                              environment: ChartsEnvironment.makeChartsEnvironment()
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
                              environment: ChartsEnvironment.makeChartsEnvironment()
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
                              environment: ArtistEnvironment.makeArtistEnvironment())
        let result = Result<[Album], APIError>.init(of: nil, or: APIError.decodingError)

        store.send(.albumsDataLoaded(result)) { $0.artist.albums = [] }
    }

    func testArtistAlbumsDataLoadedSuccessState() throws {
        let store = TestStore(initialState: ArtistState(artist: mockedArtist),
                              reducer: artistReducer,
                              environment: ArtistEnvironment.makeArtistEnvironment())

        let mockedAlbums = [mockedAlbum]
        let result = Result<[Album], APIError>.init(of: mockedAlbums, or: nil)
        store.send(.albumsDataLoaded(result)) { $0.artist.albums = mockedAlbums}
    }

    func testAlbumTracksLoadingState() throws {
        let store = TestStore(initialState: AlbumState(album: mockedAlbum),
                              reducer: albumReducer,
                              environment: AlbumEnvironment.makeAlbumEnvironment()
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

extension Result {
    init(of success: Success?, or failure: Failure?) {
        if let failure = failure {
            self = .failure(failure)
        } else if let success = success {
            self = .success(success)
        } else {
            fatalError("Neither success \(String(describing: success)) nor failure \(String(describing: failure)) was non nil")
        }
    }
}
