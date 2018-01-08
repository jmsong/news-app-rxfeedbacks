//
//  ArticleModel.swift
//  NewsFeed
//
//  Created by Tran Minh Tung on 1/7/18.
//  Copyright © 2018 TungTM. All rights reserved.
//

import ObjectMapper

struct ArticleItem: Mappable {
    var sourceId: String?
    var sourceName: String?
    var author: String?
    var title: String?
    var description: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: String?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        sourceId <- map["source.id"]
        sourceName <- map["source.name"]
        author <- map["author"]
        title <- map["title"]
        description <- map["description"]
        url <- map["url"]
        urlToImage <- map["urlToImage"]
        publishedAt <- map["publishedAt"]
    }
}
