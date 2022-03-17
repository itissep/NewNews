//
//  NewswireArticle.swift
//  NewNews
//
//  Created by The GORDEEVS on 17.03.2022.
//

import Foundation

struct NewswireArticle: Codable {
    let url: String
    let abstract: String?
    let title: String
    let byline: String?
    let published_date: String
    let multimedia: [Metadata]?
    
}
