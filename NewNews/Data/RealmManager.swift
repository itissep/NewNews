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
    
    
    func create(item: Bookmark){
        try! realm.write {
            realm.add(item)
        }
    }
    
    func update(){
        realm.refresh()
    }
    
    
    func getFavourites(_ complitionHandler: @escaping (Results<Bookmark>) -> Void){
        let items = realm.objects(Bookmark.self).sorted(byKeyPath: "published_date", ascending: false)
        complitionHandler(items)
    }
    
    
    func delete(title: String){
        let items = realm.objects(Bookmark.self)
        let itemToDelete = items.where {
            $0.title.starts(with: title)
        }
        try! realm.write {
            realm.delete(itemToDelete)
        }
    }
    
    
    func search(string: String, _ complitionHandler: @escaping (Results<Bookmark>) -> Void){
        let items = realm.objects(Bookmark.self)
        let foundItems = items.where {
            $0.title.contains(string)
        }
        complitionHandler(foundItems)
    }
    
    
    func finder(title: String) -> Bool{
        let items = realm.objects(Bookmark.self)
        let itemToDelete = items.where {
            $0.title.starts(with: title)
        }
        if let _ = itemToDelete.first {
            return true
        } else {
            return false
        }
    }
    
}
