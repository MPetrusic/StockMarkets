//
//  NetworkingManager.swift
//  StockMarkets Test Project
//
//  Created by Milos Petrusic on 16.6.21..
//

import Foundation

enum NetworkingError: Error {
    case failedToFetch
}

class SymbolParser: NSObject, XMLParserDelegate {
    private var symbols: [Symbol] = []
    private var symbolsDict: [String: String] = [:]
    private var quoteDict: [String: String] = [:]
    
    private var currentElement = ""
    
    func parseFeed(url: String, completion: @escaping (Result<[Symbol], NetworkingError>) -> Void) {
        
        var request = URLRequest(url: URL(string: url)!)
        let username = "android_tt"
        let password = "Sk3M!@p9e"
        let loginString = "\(username):\(password)"

        guard let loginData = loginString.data(using: String.Encoding.utf8) else {
            return
        }
        let base64LoginString = loginData.base64EncodedString()

        request.httpMethod = "GET"
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                if error != nil {
                    completion(.failure(NetworkingError.failedToFetch))
                }
                return
            }
            
            // parse xml data
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
            completion(.success(self.symbols))
        }
        
        task.resume()
    }
    
    // MARK: - XML Parser Delegate
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        currentElement = elementName
        if currentElement == "Symbol" {
            symbolsDict = attributeDict
        }
        if currentElement == "Quote" {
            quoteDict = attributeDict
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "Symbol" {
            let last = quoteDict["last"]!
            let high = quoteDict["high"]!
            let low = quoteDict["low"]!
            let dateTime = quoteDict["dateTime"]!
            let change = quoteDict["change"] ?? "-"
            let changePercent = quoteDict["changePercent"] ?? "-"
            let bid = quoteDict["bid"] ?? "-"
            let ask = quoteDict["ask"] ?? "-"
            let quote = Quote(bid: bid, ask: ask, last: last, high: high, low: low, dateTime: dateTime, change: change, changePercent: changePercent)
            let symbol = Symbol(name: symbolsDict["name"]!, quote: quote)
            symbols += [symbol]
        }
    }
}

class NewsParser: NSObject, XMLParserDelegate {
    private var news: [News] = []
    private var newsDict: [String: String] = [:]
    private var currentElement = ""
    private var currentTitle: String = "" {
        didSet {
            currentTitle = currentTitle.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentImageId: String = "" {
        didSet {
            currentImageId = currentImageId.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    func parseNews(url: String, completion: @escaping (Result<[News], NetworkingError>) -> Void) {
        
        var request = URLRequest(url: URL(string: url)!)
        let username = "android_tt"
        let password = "Sk3M!@p9e"
        let loginString = "\(username):\(password)"

        guard let loginData = loginString.data(using: String.Encoding.utf8) else {
            return
        }
        let base64LoginString = loginData.base64EncodedString()

        request.httpMethod = "GET"
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                if error != nil {
                    completion(.failure(NetworkingError.failedToFetch))
                }
                return
            }
            
            // parse xml data
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
            completion(.success(self.news))
        }
        
        task.resume()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        currentElement = elementName
        if currentElement == "NewsArticle" {
            currentTitle = ""
        }
        if currentElement == "NewsArticle" {
            currentImageId = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String)
        {
            switch currentElement {
            case "Headline": currentTitle += string
            case "ImageID" : currentImageId += string
            default: break
            }
        }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "NewsArticle" {
            
            let newsItem = News(headline: currentTitle, imageId: currentImageId)
            news += [newsItem]
        }
    }
}
