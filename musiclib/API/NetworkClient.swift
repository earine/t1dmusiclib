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
        case chart = "/chart/0/artists"
    }

    func artistAlbumsEffect(id: Int, decoder: JSONDecoder) -> Effect<[Album], APIError> {
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


    func chartArtistsEffect(decoder: JSONDecoder) -> Effect<Chart, APIError> {
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
    var decoder: () -> JSONDecoder

    private static func decoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }

    static func live(environment: Environment) -> Self {
        Self(environment: environment, mainQueue: { .main }, decoder: decoder)
    }
}
