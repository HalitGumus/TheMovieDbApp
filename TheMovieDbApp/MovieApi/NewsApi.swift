//
//  MovieApi.swift
//  TheMovieDbApp
//
//  Created by HalitG on 7.03.2021.
//  Copyright (c) 2021 HalitG. All rights reserved.
//

import Foundation

struct MovieApi {

    static let ApiKey = "fd2b04342048fa2d5f728561866ad52a"

    static func urlForCategory(page: String, searchKey: String) -> URL? {
        var urlComponents = MovieApi.baseUrlComponents

        urlComponents.path = Path.top.rawValue

        let keyLanguageItem = MovieApi.keyLanguageItem
        let keyQueryItem = MovieApi.keyQueryItem
        let pageQueryItem = URLQueryItem(name: "page", value: page)

        urlComponents.queryItems = [keyLanguageItem, keyQueryItem, pageQueryItem]

        return urlComponents.url
    }

}

private extension MovieApi {
    enum Path: String {
        case top = "/3/movie/popular"
        case search = "/v2/everything"
    }

    static var baseUrlComponents: URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.themoviedb.org"

        return urlComponents
    }

    static var keyQueryItem: URLQueryItem {
        return URLQueryItem(name: "api_key", value: ApiKey)
    }
    
    static var keyLanguageItem: URLQueryItem {
        return URLQueryItem(name: "language", value: "en-US")
    }
}

extension URL {

    func get<T: Codable>(completion: @escaping (Result<T, ApiError>) -> Void) {
        print("get: \(self.absoluteString)")

        let session = URLSession.shared
        let task = session.dataTask(with: self) { data, _, error in
            if let _ = error {
                DispatchQueue.main.async {
                    completion(.failure(.generic))
                }
                return
            }

            guard let unwrappedData = data else {
                DispatchQueue.main.async {
                    completion(.failure(.generic))
                }
                return
            }

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            if let decoded = try? decoder.decode(T.self, from: unwrappedData) {
                DispatchQueue.main.async {
                    completion(.success(decoded))
                }
            }
            else {
                DispatchQueue.main.async {
                    completion(.failure(.generic))
                }
            }
        }

        task.resume()
    }

}

enum ApiError: Error {
    case generic
}
