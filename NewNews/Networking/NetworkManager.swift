//
//  NetworkManager.swift
//  NewNews
//
//  Created by The GORDEEVS on 17.03.2022.
//

import Foundation


final class NetworkManager {
    static let shared = NetworkManager()
    
    private init(){}

    struct Constants {
        static let topHeadlines = "https://api.nytimes.com/svc/mostpopular/v2"
        static let sectionHeadlines = "https://api.nytimes.com/svc/news/v3/content/"
    }
    
    
    func getNewswire(source: String, section:String,  _ complitionHandler: @escaping ([NewswireArticle]) -> Void) {
        let urlString = "\(Constants.sectionHeadlines+source)/\(section).json?api-key=\(Config.key)"
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    let json = try? JSONDecoder().decode(ARIResponse.self, from: safeData)
                    complitionHandler(json?.results ?? [NewswireArticle(url: "", abstract: "", title: "", byline: "", published_date: "", multimedia: [])])
                }
            }
            task.resume()
        }
    }


    func getTopNews(_ complitionHandler: @escaping ([PopularArticle]) -> Void) {
        let period = 7
        let urlString = "\(Constants.topHeadlines)/viewed/\(period).json?api-key=\(Config.key)"

        guard let url = URL(string: urlString) else { return }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error)
            } else if let data = data {
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    let result = self.JSONParser(json: json)
                    complitionHandler(result)
                }
            }
        }
        task.resume()
    }
    
    
    func JSONParser(json: [String: Any]) -> [PopularArticle] {
        var results = [PopularArticle]()
        if let result = json["results"] as? [Any]{
            for articleItem in result {
                if let articleItem = articleItem as? [String: Any] {
                    let url = articleItem["url"] as! String
                    let id = articleItem["id"] as! Int
                    let published_date = articleItem["published_date"] as! String
                    let title = articleItem["title"] as! String
                    let abstract = articleItem["abstract"] as! String
                    let byline = articleItem["byline"] as! String
                    var media: [Media]?
                    
                    if let mediaM = articleItem["media"] as? [Any] {
                        var mediaArray = [Media]()
                        for mediaItem in mediaM {
                            if let firstMedia = mediaItem as? [String: Any] {
                                let caption = firstMedia["caption"] as! String
                                var metaFuckingArray: [Metadata]?
                                
                                if let mediaMetadata = firstMedia["media-metadata"] as? [Any] {
                                    var metadataArray =  [Metadata]()
                                    for image in mediaMetadata {
                                        if let image = image as? [String: Any] {
                                            let format = image["format"] as! String
                                            let url = image["url"] as! String
                                            let height = image["height"] as! Int
                                            let width = image["width"] as! Int
                                            let metadata = Metadata(format: format, url: url, height: height, width: width)
                                            metadataArray.append(metadata)
                                        }
                                    }
                                    metaFuckingArray = metadataArray
                                }
                                let media = Media(caption: caption, mediaMetadata: metaFuckingArray)
                                mediaArray.append(media)
                            }
                        }
                        media = mediaArray
                    }
                    let article = PopularArticle(url: url, id: id, published_date: published_date, byline: byline, title: title, abstract: abstract, media: media)
                    results.append(article)
                }
            }
        }
        return results
    }
    
    
    func getSections( _ complitionHandler: @escaping ([Section]) -> Void) {
        let urlString = "https://api.nytimes.com/svc/news/v3/content/section-list.json?api-key=\(Config.key)"

        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    let json = try? JSONDecoder().decode(ResponseSections.self, from: safeData)
                    complitionHandler(json?.results ?? [Section(section: "nope", display_name: "nope")])
                }
            }
            task.resume()
        }
    }
    
    
    func getBookSellers(listName: String, _ complitionHandler: @escaping ([Book]) -> Void){
        let urlString = "https://api.nytimes.com/svc/books/v3/lists/current/\(listName).json?api-key=\(Config.key)"
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    let json = try? JSONDecoder().decode(BookSellersResponse.self, from: safeData)
                    complitionHandler(json?.results?.books ?? [])
                }
            }
            task.resume()
        }
    }
    
    func getBookLists( _ complitionHandler: @escaping ([BookList]) -> Void){
        let urlString = "https://api.nytimes.com/svc/books/v3/lists/names?api-key=\(Config.key)"
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    let json = try? JSONDecoder().decode(BookListNamesResponse.self, from: safeData)
                    complitionHandler(json?.results ?? [])
                }
            }
            task.resume()
        }
    }
    
}
struct BookListNamesResponse: Codable {
    let results:[BookList]?
}

struct BookList: Codable {
    let list_name: String
    let list_name_encoded: String
}




struct BookSellersResponse: Codable {
    let results: BookListResult?
}
struct BookListResult: Codable {
    let books:[Book]?
}

struct Book: Codable {
    let rank: Int
    let description: String
    let title: String
    let publisher: String
    let contributor: String
    let book_image: String
    let amazon_product_url: String
    
}

struct ARIResponse: Codable {
    let results: [NewswireArticle]?
}


struct ResponseSections: Codable {
    let results: [Section]?
}


struct Section: Codable {
    let section: String
    let display_name: String
}
