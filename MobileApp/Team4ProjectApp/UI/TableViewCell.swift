//
//  TableViewCell.swift
//  Team4ProjectApp
//
//  Created by Logan Harvell on 11/29/17.
//  Copyright © 2017 Logan Harvell. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var notifyLabel: UILabel!
  @IBOutlet weak var toggleSwitch: UISwitch!
  
  var tableView: UITableView? {
    return next(UITableView.self)
  }
  
  var indexPath: IndexPath? {
    return tableView?.indexPath(for: self)
  }
}

extension UIResponder {
  
  func next<T: UIResponder>(_ type: T.Type) -> T? {
    return next as? T ?? next?.next(type)
  }
}
