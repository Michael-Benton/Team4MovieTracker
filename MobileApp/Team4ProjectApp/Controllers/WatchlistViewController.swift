//
//  WatchlistViewController.swift
//  Team4ProjectApp
//
//  Created by Logan Harvell on 11/13/17.
//  Copyright © 2017 Logan Harvell. All rights reserved.
//

import UIKit

class WatchlistViewController: UIViewController {

  private let appDelegate = UIApplication.shared.delegate as! AppDelegate
  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.rowHeight = 80
    tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
  }
  
  override func viewDidLayoutSubviews() {
    tableView.cellLayoutMarginsFollowReadableWidth = false
  }
}

extension WatchlistViewController: UITableViewDelegate, UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return (appDelegate.user?.watchlist?.count)!
  }
  
  
  internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let identifier = "TableViewCell"
    guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier,
                                                   for: indexPath) as? TableViewCell
      else {
        fatalError("Dequeued Cell is not a TableViewCell")
    }
    
    let entry = appDelegate.user?.watchlist![indexPath.row]
    
    cell.titleLabel.text = entry!.title
    cell.layer.borderWidth = 1
    cell.layer.borderColor = UIColor.black.cgColor
    
    return cell
  }
  
}

