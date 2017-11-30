//
//  AppUser.swift
//  Team4ProjectApp
//
//  Created by Logan Harvell on 11/28/17.
//  Copyright © 2017 Logan Harvell. All rights reserved.
//

import Foundation

final class AppUser {
  
  var id: Int
  var email: String
  var password: String
  var auth_token: String
  var watchlist: [movieTVEntry]?
  
  struct movieTVEntry : Codable {
    let id: Int
    let movie_id: Int?
    let tv_id: Int?
    let title: String
    let releaseDate: String
    let notify:Bool?
    
    func getReleaseDate() -> Date {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-mm-dd'T'hh:mm:ss"
      return dateFormatter.date(from: releaseDate)!
    }
  }
  
  required init(id: Int, email: String, password: String,
                auth_token: String, watchlist: [movieTVEntry]) {
    self.id = id
    self.email = email
    self.password = password
    self.auth_token = auth_token
    self.watchlist = watchlist
  }
  
  public static func initUserFromWebApp(email: String,
                                        password: String) -> AppUser? {
    var authenticated = false
    var watchlistReceieved = false
    
    var userJSON: WebAppApi.User?
    var watchlist: [movieTVEntry]?
    
    WebAppApi.login(email: email, password: password) { (completionBlock) in
      userJSON = completionBlock
      authenticated = true
    }
    
    repeat {
      RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.1))
    } while !authenticated
    
    if (userJSON == nil) {
      return nil
    }
    
    WebAppApi.getWatchlist(user: userJSON!) { (completionBlock) in
      watchlist = completionBlock
      watchlistReceieved = true
    }

    repeat {
      RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.1))
    } while !watchlistReceieved

    WebAppApi.currentTask?.cancel()

    let user = AppUser.init(id: Int(userJSON!.id)!, email: email, password: password,
                            auth_token: userJSON!.authentication_token,
                            watchlist: watchlist!)
    return user
  }
}
