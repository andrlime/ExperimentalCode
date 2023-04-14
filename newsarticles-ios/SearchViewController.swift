//
//  SearchViewController.swift
//
//  Created by Andrew Li on 4/8/20.
//  Copyright © 2020 Andrew Li. All rights reserved.
//

import UIKit
import Foundation

struct NewsSource: Decodable { //from github news api swift open source thank you~!
    let status: String?
    let totalResults: Int?
    struct Article: Decodable {
        let source: Source
        let author: String?
        let title: String?
        let description: String?
        let url: URL?
        let urlToImage: URL?
        let publishedAt: Date
        
        struct Source: Decodable {
            let id: String?
            let name: String?
        }
    }
    
    let articles: [Article]
    
    private enum CodingKeys: String, CodingKey {
        case status
        case totalResults
        case articles
    }
}

extension UIImage {
    func alpha(_ value:CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}

extension UIImageView {
    //loads an image from a url, change the Info.plist for http support --> someone please find an https server --> I found this for Spartapp
    func loadUrl(url: URL) {
        print("Loading Image")
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image.alpha(0.2)
                        self?.contentMode = UIView.ContentMode.scaleAspectFill
                        self?.layer.cornerRadius = 15
                        self?.layer.masksToBounds = true
                        self?.clipsToBounds = true
                    }
                }
            }
        }
    }
}

extension String { //Kevin Tong's Spartapp stuff
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    subscript (bounds: CountableRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[start ..< end]
    }
    subscript (bounds: CountableClosedRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[start ... end]
    }
    subscript (bounds: CountablePartialRangeFrom<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(endIndex, offsetBy: -1)
        return self[start ... end]
    }
    subscript (bounds: PartialRangeThrough<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[startIndex ... end]
    }
    subscript (bounds: PartialRangeUpTo<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[startIndex ..< end]
    }
}

class News {
    var title: String
    var author: String
    var day: String
    var webLink: String
    var photoUrl: String
    
    init (title: String, author: String, day: String,  webLink: String, photoUrl: String) {
        self.title = title
        self.author = author
        self.day = day
        self.webLink = webLink
        self.photoUrl = photoUrl
    }
    
    func formatDate() -> String {
        //publishedAt": "2020-04-13T00:49:49Z", <-- format
        let dayString = "\(day)"
        let slash = "/"
        
        //print("\(dayString[5...6])\(slash)\(dayString[8...9])\(slash)\(dayString[0...3])")
        return "\(dayString[5...6])\(slash)\(dayString[8...9])\(slash)\(dayString[0...3])"
    }
    
    func getConcatAuthor() -> String {
        return "\(formatDate())"
        //if(self.author.count==0) {
            //return "\(formatDate())"
        //} else {
            //return "\(self.author), \(formatDate())"
        //}
    }
}

class SearchViewController: UITableViewController, UISearchBarDelegate {
    
    var news: [News] = [News]()
    
    @IBOutlet var searchTable: UITableView!
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return (news.count)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SearchTableViewCell
        
        cell.newsImage.loadUrl(url: URL(string: news[indexPath.section].photoUrl)!)
        cell.newsImage.clipsToBounds = true
        cell.selectionStyle = .none
        
        cell.titleLabel.text = news[indexPath.section].title
        cell.authorLabel.text = news[indexPath.section].getConcatAuthor()
        cell.urlLink.setUrl(url: news[indexPath.section].webLink)
        
        return cell
    }
    
    @IBAction func readMoreButton(_ sender: WebButton) {
        UIApplication.shared.open(URL(string: sender.getUrl())! as URL, options: [:], completionHandler: nil)
        //access the actual url content on safari app
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("SEARCHING")
        news.removeAll()
        loadNews(query: searchBar.text ?? "")
    }
    
    let APIKEY = "API KEY GOES HERE"
    var myFeed: [NewsSource.Article] = []
    let secretAPIKey = URLQueryItem(name: "apiKey", value: APIKEY)
    var everythingUrl = URLComponents(string: "https://newsapi.org/v2/everything?")
    var topHeadLinesUrl = URLComponents(string: "https://newsapi.org/v2/top-headlines?")

    var errorMessage = ""
    
    fileprivate func updateResults(_ data: Data) {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        myFeed.removeAll()
        do {
            let rawFeed = try decoder.decode(NewsSource.self, from: data)
            myFeed = rawFeed.articles
        } catch let decodeError as NSError {
            errorMessage += "Decoder error: \(decodeError.localizedDescription)"
            return
        }
    }
    
    func getResults(from url: URL, completion: @escaping () -> ()) {
        URLSession.shared.dataTask(with: url) { (data, response, error ) in
            guard let data = data else { return }
            self.updateResults(data)
            completion()
            }.resume()
    }
    
    func everything(query: String) -> URL? {
        everythingUrl = URLComponents(string: "https://newsapi.org/v2/everything?")
        
        let search = URLQueryItem(name: "q", value: query)
        everythingUrl?.queryItems?.append(search)
        everythingUrl?.queryItems?.append(secretAPIKey)
        return everythingUrl?.url
    }
    
    func top() -> URL? {
        topHeadLinesUrl = URLComponents(string: "https://newsapi.org/v2/top-headlines?")
        
        let search = URLQueryItem(name: "country", value: "us")
        topHeadLinesUrl?.queryItems?.append(search)
        topHeadLinesUrl?.queryItems?.append(secretAPIKey)
        return topHeadLinesUrl?.url
    }
    
    func getSRC(src: String) -> String {
        let index = src.index(of: "h")
        let urlindex = src.index(of: ")")
        
        return String(src[index!..<urlindex!])
    }
    
    func getURL(url: String) -> String {
        let index = url.index(of: "h")
        let photoindex = url.index(of: ")")
        
        return String(url[index!..<photoindex!])
    }
    
    let blankIMG: String = "https://cdn-3d.niceshops.com/upload/image/product/medium/default/vallejo-game-air-dead-white-17-ml-278281-en.jpg"
    
    func loadNews(query: String) {
        if(query == "") {
            return
        } else {
            getResults(from: everything(query: query)!) {
                DispatchQueue.main.async {
                    self.myFeed.forEach{
                        print("\($0)")
                        let title = "\($0.title ?? "No Title")"
                        let date = "\($0.publishedAt)"
                        let author = "\($0.source.id?.capitalized ?? "")"
                        let srcURL: String! = "\($0.url)"
                        let imageURL: String! = "\($0.urlToImage ?? URL(string: self.blankIMG))"
                        
                        let s = self.getSRC(src: srcURL)
                        let i = self.getURL(url: imageURL)
                        
                        if(title=="No Title") {
                            
                        } else {
                            self.news.append(News(title: title, author: author, day: date, webLink: s, photoUrl: i))
                        }
                    }
                    self.searchTable.reloadData()
                }
            }
        }
    }
    
    func initLoad() {
        print("init load")
        print(top()?.absoluteString)
        getResults(from: everything(query: "Bitcoin")!) {
            DispatchQueue.main.async {
                self.myFeed.forEach{
                    print("\($0)")
                    let title = "\($0.title ?? "No Title")"
                    let date = "\($0.publishedAt)"
                    let author = "\($0.source.id?.capitalized ?? "")"
                    let srcURL: String! = "\($0.url)"
                    let imageURL: String! = "\($0.urlToImage)"
                    
                    let s = self.getSRC(src: srcURL)
                    let i = self.getURL(url: imageURL)
                    
                    print(title)
                    
                    self.news.append(News(title: title, author: author, day: date, webLink: s, photoUrl: i))
                }
                self.searchTable.reloadData()
            }
        }
    }
    
    func topHeadlinesUrl() -> URL? {
        topHeadLinesUrl?.queryItems?.append(secretAPIKey)
        return topHeadLinesUrl?.url
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //news.append(News(title: "bug", author: "", day: "2020-04-21", webLink: "https://www.google.com", photoUrl: "https://cdn-3d.niceshops.com/upload/image/product/medium/default/vallejo-game-air-dead-white-17-ml-278281-en.jpg"))
        
        searchTable.rowHeight = 230
        searchTable.separatorColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        searchTable.delegate = self
        searchTable.dataSource = self
        searchBar.delegate = self
        
        initLoad()
    }
}
