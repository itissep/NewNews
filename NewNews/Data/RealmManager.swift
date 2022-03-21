//
//  RealmManager.swift
//  NewNews
//
//  Created by The GORDEEVS on 21.03.2022.
//

import UIKit
import RealmSwift

struct RealmManager {
    static let shared = RealmManager()
    let realm = try! Realm()
    
    private init(){}
    
    
    func create(item: Favourite){
        try! realm.write {
            realm.add(item)
            print("written")
        }
    }
    
    
    func getFavourites(_ complitionHandler: @escaping (Results<Favourite>) -> Void){
        let items = realm.objects(Favourite.self)
        complitionHandler(items)
    }
    
    
    func delete(title: String){
        let items = realm.objects(Favourite.self)
        let itemToDelete = items.where {
            $0.title.starts(with: title)
        }
        try! realm.write {
            realm.delete(itemToDelete)
            print("deleted")
        }
    }
    
    
    func search(string: String, _ complitionHandler: @escaping (Results<Favourite>) -> Void){
        let items = realm.objects(Favourite.self)
        let foundItems = items.where {
            $0.title.contains(string)
        }
        complitionHandler(foundItems)
    }
    
    
    func finder(title: String) -> Bool{
        let items = realm.objects(Favourite.self)
        let itemToDelete = items.where {
            $0.title.starts(with: title)
        }
        if let _ = itemToDelete.first {
            print("true")
            return true
        } else {
            print("false")
            return false
        }
    }
    
}
