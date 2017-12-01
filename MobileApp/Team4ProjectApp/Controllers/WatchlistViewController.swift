//
//  WatchlistViewController.swift
//  Team4ProjectApp
//
//  Created by Logan Harvell on 11/13/17.
//  Copyright © 2017 Logan Harvell. All rights reserved.
//

import UIKit
import UserNotifications

class WatchlistViewController: UIViewController {

  private let appDelegate = UIApplication.shared.delegate as! AppDelegate
  
  @IBOutlet weak var headerLabel: UILabel!
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    headerLabel.layer.borderWidth = 2
    headerLabel.layer.borderColor = UIColor.black.cgColor
    
    tableView.rowHeight = 80
    tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
  }
  
  override func viewDidLayoutSubviews() {
    tableView.cellLayoutMarginsFollowReadableWidth = false
  }
  
  @IBAction func notifyToggle(_ sender: UISwitch) {
    guard let tableEntry = sender.superview?.superview as? TableViewCell else {
      return
    }
    if (sender.isOn) {
      let index = tableEntry.indexPath!.row
      print(index)
      guard let movieTV = appDelegate.user?.watchlist?[index] else {
        return
      }
      
      let title = movieTV.title
      let releaseDate = movieTV.getReleaseDate()
      
      let content = UNMutableNotificationContent()
      content.title = "Movie/TV Tracker"
      content.sound = UNNotificationSound.default()
      content.setValue("YES", forKeyPath: "shouldAlwaysAlertWhileAppIsForeground")
      
      var trigger: UNCalendarNotificationTrigger?
      if (movieTV.movie_id != nil) {
        content.body = "\(title) has just released!"
        
        let triggerDate = Calendar.current.dateComponents([.year, .month,
                                                           .day, .hour,
                                                           .minute, .second,],
                                                          from: releaseDate)
        trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate,
                                                    repeats: false)
      }
      
      if (movieTV.tv_id != nil) {
        content.body = "A new episode of \(title) is starting now!"

        let triggerWeekly = Calendar.current.dateComponents([.weekday, .hour,
                                                             .minute, .second],
                                                            from: releaseDate)
        trigger = UNCalendarNotificationTrigger(dateMatching: triggerWeekly,
                                                repeats: true)
      }

      guard trigger != nil else {
        print("Notifiation type could not be identified")
        return
      }

      let center = UNUserNotificationCenter.current()
      let identifier = "MovieTVNotification\(index)"
      let request = UNNotificationRequest(identifier: identifier,
                                          content: content, trigger: trigger)
      
      
      center.add(request, withCompletionHandler: { (error) in
        if error != nil {
          print("Notification request couuld not be completed.")
        }
      })
    
      center.getPendingNotificationRequests() {
        requests in
        print(requests)
        print("END")
      }
      
      center.getDeliveredNotifications() {
        requests in
        print("\n\n\n\(requests)")
      }
    }
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
    cell.layer.borderWidth = 2
    cell.layer.borderColor = UIColor.black.cgColor
    
    return cell
  }
  
}

