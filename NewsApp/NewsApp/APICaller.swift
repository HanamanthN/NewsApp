//
//  APICaller.swift
//  NewsApp
//
//  Created by Hanamantraya Nagonde on 12/07/22.
//

import Foundation

struct Constants {
    static let topHeadlinesURL = URL(string: "https://newsapi.org/v2/top-headlines?country=in&apiKey=32b133034c12485c872618145f2cdc42")
    static let searchUrlString = "https://newsapi.org/v2/everything?sortBy=popularity&apiKey=32b133034c12485c872618145f2cdc42&q="
}

final class APICaller {
    static let shared = APICaller()
    
    private init() {}
    
    public func getTopStories(completion: @escaping(Result<[Article], Error>) -> Void) {
        guard let url = Constants.topHeadlinesURL else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    debugPrint(result.articles.count)
                    completion(.success(result.articles))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    public func search(with query: String, completion: @escaping(Result<[Article], Error>) -> Void) {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let urlString = Constants.searchUrlString + query
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    debugPrint(result.articles.count)
                    completion(.success(result.articles))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}



// Models

struct APIResponse: Codable {
    let articles: [Article]
}

struct Article: Codable {
    let source: Source
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String
}

struct Source: Codable {
    let name: String
}
