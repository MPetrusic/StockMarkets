//
//  ViewController.swift
//  StockMarkets Test Project
//
//  Created by Milos Petrusic on 16.6.21..
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameButton: UIButton!
    @IBOutlet weak var leftColumnLabel: UILabel!
    @IBOutlet weak var rightColumnLabel: UILabel!
    
    var refreshControl: UIRefreshControl?
    
    var symbols: [Symbol] = []
    
    var symbolNames: [String]? {
        didSet {
            if sortState?.rawValue == "unsorted" {
                return symbolNames = unsortedList
            } else if sortState?.rawValue == "ascending" {
                return symbolNames = ascengingList
            } else {
                symbolNames = descendingList
            }
        }
    }
    
    var sortState = SymbolSortState(rawValue: UserDefaults.standard.string(forKey: "sortState") ?? "unsorted")
    
    var formatState = FormateState(rawValue: UserDefaults.standard.string(forKey: "format") ?? "changePercent")
    
    var bids: [String] {
        var array = [String]()
        for i in 0...(symbols.count - 1) {
            array.append(symbols[i].quote.bid)
        }
        return array
    }
    
    var asks: [String] {
        var array = [String]()
        for i in 0...(symbols.count - 1) {
            array.append(symbols[i].quote.ask)
        }
        return array
    }
    
    var highs: [String] {
        var array = [String]()
        for i in 0...(symbols.count - 1) {
            array.append(symbols[i].quote.high)
        }
        return array
    }
    
    var lows: [String] {
        var array = [String]()
        for i in 0...(symbols.count - 1) {
            array.append(symbols[i].quote.low)
        }
        return array
    }
    
    var unsortedList: [String] {
        var array = [String]()
        for symbol in symbols {
            array.append(symbol.name)
        }
        return array
    }
    
    var ascengingList: [String] {
        var array = [String]()
        for symbol in symbols {
            array.append(symbol.name)
        }
        array.sort()
        return array
    }
    
    var descendingList: [String] {
        var array = [String]()
        for symbol in symbols {
            array.append(symbol.name)
        }
        array.sort(by: { itemA, itemB in
            itemA > itemB
        })
        return array
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(toggleEditing))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Format", style: .plain, target: self, action: #selector(symbolFormat))
        registerTableViewCells()
        fetchData()
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl!)
        rightColumnLabel.minimumScaleFactor = 0.5
        rightColumnLabel.adjustsFontSizeToFitWidth = true
    }
    
    private func fetchData() {
        let symbolParser = SymbolParser()
        symbolParser.parseFeed(url: "https://www.teletrader.rs/downloads/tt_symbol_list.xml", completion: { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let symbols):
                strongSelf.symbols = symbols
                strongSelf.symbolNames = strongSelf.unsortedList
            case .failure(let error):
                print("Failed to parse: \(error)")
            }
            DispatchQueue.main.async {
                strongSelf.tableView.reloadData()
                strongSelf.refreshControl?.endRefreshing()
            }
        })
    }
    
    //MARK: - @objc functions
    
    @objc private func symbolFormat() {
        let ac = UIAlertController(title: "Format", message: "Choose preferred format", preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Bid/Ask, High/Low", style: .default, handler: { [weak self] _ in
            self?.rightColumnLabel.text = "High, Low"
            self?.leftColumnLabel.text = "Bid/Ask"
            self?.formatState = FormateState(rawValue: "bidAsk")
            UserDefaults.standard.setValue(self?.formatState?.rawValue, forKey: "format")
            self?.tableView.reloadData()
        }))
        ac.addAction(UIAlertAction(title: "Change(%), Last", style: .default, handler: { [weak self] _ in
            self?.rightColumnLabel.text = "Last"
            self?.leftColumnLabel.text = "Chg%"
            self?.formatState = FormateState(rawValue: "changePercent")
            UserDefaults.standard.setValue(self?.formatState?.rawValue, forKey: "format")
            self?.tableView.reloadData()
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(ac, animated: true, completion: nil)
    }
    
    @objc private func refresh() {
        fetchData()
    }
    
    @objc private func toggleEditing() {
        tableView.setEditing(!tableView.isEditing, animated: true)
        navigationItem.rightBarButtonItem?.title = tableView.isEditing ? "Done" : "Edit"
    }
    
    //MARK: - Outlet action functions

    @IBAction func nameButtonTapped(_ sender: Any) {
        if sortState == .unsorted {
            sortState = .ascending
            UserDefaults.standard.setValue(sortState?.rawValue, forKey: "sortState")
        } else if sortState == .ascending {
            
            sortState = .descending
            UserDefaults.standard.setValue(sortState?.rawValue, forKey: "sortState")
        } else if sortState == .descending {
            
            sortState = .unsorted
            UserDefaults.standard.setValue(sortState?.rawValue, forKey: "sortState")
        }
        switch sortState {
        case .unsorted:
            symbolNames = unsortedList
            tableView.reloadData()
        case .ascending:
            symbolNames = ascengingList
            tableView.reloadData()
        case .descending:
            symbolNames = descendingList
            tableView.reloadData()
        case .none:
            symbolNames = unsortedList
        }
    }
    
    private func registerTableViewCells() {
        let textFieldCell = UINib(nibName: "SymbolTableViewCell",
                                  bundle: nil)
        self.tableView.register(textFieldCell,
                                forCellReuseIdentifier: "SymbolTableViewCell")
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return symbols.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SymbolTableViewCell", for: indexPath) as? SymbolTableViewCell {
            cell.accessoryType = .disclosureIndicator
            if let symbolNames = symbolNames {
                let symbolName = symbolNames[indexPath.row]
                let symbolChange = symbols[indexPath.row].quote.change
                let symbolLast = symbols[indexPath.row].quote.last
                let symbolBid = bids[indexPath.row]
                let symbolAsk = asks[indexPath.row]
                let symbolHigh = highs[indexPath.row]
                let symbolLow = lows[indexPath.row]
                cell.symbolTitle.text = symbolName
                if formatState?.rawValue == "changePercent" {
                    cell.firstValueLabel.text = symbolChange
                    cell.secondValueLabel.text = symbolLast
                } else {
                    cell.firstValueLabel.text = symbolBid + "\n" + symbolAsk
                    cell.secondValueLabel.text = symbolHigh + "\n" + symbolLow
                }
                if Double(symbolChange) != nil && Double(symbolChange)! > 0 {
                    cell.firstValueLabel.textColor = .green
                } else if Double(symbolChange) == nil  {
                    cell.firstValueLabel.textColor = .clear
                } else {
                    cell.firstValueLabel.textColor = .red
                }
            }
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let vc = storyboard?.instantiateViewController(identifier: "SymbolDetailsViewController") as? SymbolDetailsViewController {
            vc.selectedSymbol = symbols[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            symbols.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

enum SymbolSortState: String {
    case unsorted = "unsorted"
    case ascending = "ascending"
    case descending = "descending"
}

enum FormateState: String {
    case changePercent = "changePercent"
    case bidAsk = "bidAsk"
}

