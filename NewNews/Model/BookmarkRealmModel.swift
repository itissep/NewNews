//
//  FavouriteRealmModel.swift
//  NewNews
//
//  Created by The GORDEEVS on 21.03.2022.
//

import UIKit
import RealmSwift


class Bookmark: Object {
    @Persisted var url: String
    @Persisted var abstract: String?
    @Persisted var byline: String?
    @Persisted var published_date: String
    @Persisted var title: String
    @Persisted var imageUrl: String
}
