//
//  PopularArticle.swift
//  NewNews
//
//  Created by The GORDEEVS on 17.03.2022.
//

import Foundation

struct PopularArticle {
    let url: String
    let id: Int
    let published_date: String
    let byline: String
    let title: String
    let abstract: String
    let media: [Media]?

}

struct Media {
    let caption: String?
    let mediaMetadata: [Metadata]?
}
