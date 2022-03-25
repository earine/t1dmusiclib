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
        case album = "/album/*"
        case artistAlbum = "/artist/*/albums"
        case chartArtists = "/chart/0/artists"
        case searchArtist = "/search/artist"
        case track = "/track/*"
    }

    private var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }

    // MARK: Chart Requests
    func chartArtists(completion: @escaping (Result<Chart, APIError>) -> Void) {
        guard let url = URL(string: urlStringBuilder(.chartArtists)) else {
            fatalError("Error on creating url")
        }

        performTask(for: url, completion: completion)
    }

    // MARK: Artist Requests
    func artistAlbums(id: Int,
                            completion: @escaping (Result<AlbumResponse, APIError>) -> Void) {
        guard let url = URL(string: urlStringBuilder(.artistAlbum)
            .replacingOccurrences(of: "*", with: String(id))) else {
            fatalError("Error on creating url")
        }

        performTask(for: url, completion: completion)
    }

    func searchArtist(searchQuery: String,
                            currentIndex: Int,
                            completion: @escaping (Result<ArtistsResponse, APIError>) -> Void) {
        let queryItems = [URLQueryItem(name: "q", value: searchQuery),
                          URLQueryItem(name: "index", value: String(currentIndex))]
        var urlComps = URLComponents(string: urlStringBuilder(.searchArtist))
        urlComps?.queryItems = queryItems

        guard let url = urlComps?.url else {
            fatalError("Error on creating url")
        }

        performTask(for: url, completion: completion)
    }

    // MARK: Album Requests
    func album(id: Int, completion: @escaping (Result<Album, APIError>) -> Void) {
        guard let url = URL(string: urlStringBuilder(.album)
            .replacingOccurrences(of: "*", with: String(id))) else {
            fatalError("Error on creating url")
        }

        performTask(for: url, completion: completion)
    }

    // MARK: Track Requests
    func trackInfo(id: Int, completion: @escaping (Result<Track, APIError>) -> Void) {
        guard let url = URL(string: urlStringBuilder(.track)
            .replacingOccurrences(of: "*", with: String(id))) else {
            fatalError("Error on creating url")
        }

        performTask(for: url, completion: completion)
    }

    // MARK: - private

    private func performTask<T: Decodable>(for url : URL,
                                           completion: @escaping (Result<T, APIError>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            DispatchQueue.main.async {
                if let _ = error {
                    completion(.failure(.downloadError))
                } else {
                    do {
                        let decodedData = try self.decoder.decode(T.self, from: data!)
                        completion(.success(decodedData))
                    } catch {
                        completion(.failure(.decodingError))
                    }
                }
            }
        }
        task.resume()
    }

    private func urlStringBuilder(_ endpoint: APIEndPoint) -> String {
        return "\(baseURL)\(endpoint.rawValue)"
    }
}
