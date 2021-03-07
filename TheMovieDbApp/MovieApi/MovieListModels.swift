//
//  MovieListModels.swift
//  TheMovieDbApp
//
//  Created by HalitG on 7.03.2021.
//  Copyright (c) 2021 HalitG. All rights reserved.
//

import Foundation

struct Headline: Codable {
    var results: [Movie]
}

struct Movie: Codable {
    var title: String?
    var original_title: String?
    var overview: String?
    var poster_path: String?
    var release_date: String?
    var vote_count: Int?
    var id: Int?
}

struct Source: Codable {
    var name: String?
}

extension Movie {
    var ago: String? {
        guard let date = release_date else { return nil }

        let rdf = RelativeDateTimeFormatter()

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd"
        guard let newDate = dateFormatter.date(from: date) else {
            return ""
        }
        
        return rdf.localizedString(for: newDate, relativeTo: Date())
    }

    var titleDisplay: String {
        guard let title = title else { return "" }

        let components = title.components(separatedBy: " - ")
        guard let first = components.first else { return title }

        return first
    }

}

enum MovieCategory: String, CaseIterable, Codable {
    case general
    case business
    case entertainment
    case health
    case science
    case sports
    case technology

    var systemName: String {
        switch self {
        case .general:
            return "newspaper"
        case .business:
            return "briefcase"
        case .entertainment:
            return "film"
        case .health:
            return "stethoscope"
        case .science:
            return "bolt"
        case .sports:
            return "sportscourt"
        case .technology:
            return "desktopcomputer"
        }
    }
}

enum MoviePageTye {
    case list
    case detail
}
