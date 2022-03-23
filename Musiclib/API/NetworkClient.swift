//
//  NetworkClient.swift
//  musiclib
//
//  Created by mlunts on 19.03.2022.
//

import Foundation
import ComposableArchitecture

enum APIError: Error {
    case downloadError
    case decodingError
}

public class NetworkClient {
    public static let shared = NetworkClient()

    private let baseURL = "https://api.deezer.com"

    enum APIEndPoint: String {
        case artistAlbum = "/artist/*/albums"
        case album = "/album/*"
        case chart = "/chart/0/artists"
        case searchArtist = "/search/artist"
        case track = "/track/*"
    }

    private var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }

    // MARK: - Chart Requests
    func chartArtistsEffect() -> Effect<Chart, APIError> {
        guard let url = URL(string: urlStringBuilder(.chart)) else {
            fatalError("Error on creating url")
        }

        let result = URLSession.shared.dataTaskPublisher(for: url)
            .mapError { _ in APIError.downloadError }
            .map { data, _ in
                return data
            }
            .decode(type: Chart.self, decoder: decoder)
            .mapError { _ in APIError.decodingError }
            .eraseToEffect()
        return result
    }

    // MARK: - Artist Requests
    func artistAlbumsEffect(id: Int) -> Effect<[Album], APIError> {
        guard let url = URL(string: urlStringBuilder(.artistAlbum)
            .replacingOccurrences(of: "*", with: String(id))) else {
            fatalError("Error on creating url")
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .mapError { _ in APIError.downloadError }
            .map { data, _ in data }
            .decode(type: AlbumResponse.self, decoder: decoder)
            .map({ $0.data })
            .mapError { _ in APIError.decodingError }
            .eraseToEffect()
    }

    func searchArtistEffect(searchQuery: String) -> Effect<[Artist], APIError> {
        let queryItems = [URLQueryItem(name: "q", value: "\(searchQuery)")]
        var urlComps = URLComponents(string: urlStringBuilder(.searchArtist))
        urlComps?.queryItems = queryItems

        guard let url = urlComps?.url else {
            fatalError("Error on creating url")
        }

        let result = URLSession.shared.dataTaskPublisher(for: url)
            .mapError { _ in APIError.downloadError }
            .map { data, _ in data }
            .decode(type: ArtistsResponse.self, decoder: decoder)
            .map({ $0.data })
            .mapError { _ in APIError.decodingError }
            .eraseToEffect()

        return result
    }

    // MARK: - Album Requests
    func albumEffect(id: Int) -> Effect<Album, APIError> {
        guard let url = URL(string: urlStringBuilder(.album)
            .replacingOccurrences(of: "*", with: String(id))) else {
            fatalError("Error on creating url")
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .mapError { _ in APIError.downloadError }
            .map { data, _ in data }
            .decode(type: Album.self, decoder: decoder)
            .mapError { _ in APIError.decodingError }
            .eraseToEffect()
    }

    // MARK: - Track Requests
    func trackInfoEffect(id: Int) -> Effect<Track, APIError> {
        guard let url = URL(string: urlStringBuilder(.track)
            .replacingOccurrences(of: "*", with: String(id))) else {
            fatalError("Error on creating url")
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .mapError { _ in APIError.downloadError }
            .map { data, _ in data }
            .decode(type: Track.self, decoder: decoder)
            .mapError { _ in APIError.decodingError }
            .eraseToEffect()
    }

    private func urlStringBuilder(_ endpoint: APIEndPoint) -> String {
        return "\(baseURL)\(endpoint.rawValue)"
    }
}

@dynamicMemberLookup
struct SystemEnvironment<Environment> {
    var environment: Environment

    subscript<Dependency>(
        dynamicMember keyPath: WritableKeyPath<Environment, Dependency>
    ) -> Dependency {
        get { self.environment[keyPath: keyPath] }
        set { self.environment[keyPath: keyPath] = newValue }
    }

    var mainQueue: () -> AnySchedulerOf<DispatchQueue>

    static func live(environment: Environment) -> Self {
        Self(environment: environment, mainQueue: { .main })
    }
}
