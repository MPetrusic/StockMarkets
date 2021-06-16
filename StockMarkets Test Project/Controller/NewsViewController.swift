//
//  NewsViewController.swift
//  StockMarkets Test Project
//
//  Created by Milos Petrusic on 16.6.21..
//

import UIKit

class NewsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var newsHeadline: UILabel!
    
    private var news: [News] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "News"
        tableView.delegate = self
        tableView.dataSource = self
        fetchNews()
        registerTableViewCells()
    }
    
    private func fetchNews() {
        let symbolParser = NewsParser()
        symbolParser.parseNews(url: "https://www.teletrader.rs/downloads/tt_news_list.xml", completion: { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let news):
                strongSelf.news = news
            case .failure(let error):
                print("Failed to parse news \(error)")
            }
            DispatchQueue.main.async {
                strongSelf.configureFirstNews()
                strongSelf.tableView.reloadData()
            }
        })
    }
    
    func configureFirstNews() {
        let url = URL(string: "https://cdn.ttweb.net/News/images/" + news[0].imageId + ".jpg?preset=w220_q40")
        if let safeUrl = url {
            newsImageView.load(url: safeUrl)
        }
        newsImageView.contentMode = .scaleAspectFill
        
        newsHeadline.text = news[0].headline
    }
    
    private func registerTableViewCells() {
        let textFieldCell = UINib(nibName: "NewsTableViewCell",
                                  bundle: nil)
        self.tableView.register(textFieldCell,
                                forCellReuseIdentifier: "NewsTableViewCell")
    }

}

extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count - 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as? NewsTableViewCell {
            let newsWithoutFirst = news.dropFirst(1)
            let newsItem = newsWithoutFirst[indexPath.row + 1]
            cell.newsTitle.text = newsItem.headline
            let url = URL(string: "https://cdn.ttweb.net/News/images/" + news[indexPath.row + 1].imageId + ".jpg?preset=w220_q40")
            if let safeUrl = url {
                cell.newsImage?.load(url: safeUrl)
            }
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let vc = storyboard?.instantiateViewController(identifier: "NewsDetailsViewController") as? NewsDetailsViewController {
            vc.selectedNews = news[indexPath.row + 1]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
