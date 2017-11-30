//
//  WebAppApi.swift
//  Team4ProjectApp
//
//  Created by Logan Harvell on 11/23/17.
//  Copyright © 2017 Logan Harvell. All rights reserved.
//

import Foundation

final class WebAppApi {
  
  static let config = URLSessionConfiguration.default
  static let hostURL = String("http://127.0.0.1:5000")
  static var currentTask: URLSessionTask?
  
  struct JSON: Codable {
    let response: Response
  }
  
  struct Response: Codable {
    let user: User
  }
  
  struct User: Codable {
    let authentication_token: String
    let id: String
  }

  internal static func login(email: String, password: String,
                             completionBlock: @escaping (User?) -> ()) {
    
    let json: [String: Any] = ["email": email, "password": password]
    let jsonData = try? JSONSerialization.data(withJSONObject: json)
    
    guard let url = URL(string: hostURL + "/login") else {
      print("Error initializing URL for login.")
      return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.httpBody = jsonData
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let session = URLSession(configuration: self.config)
    currentTask = session.dataTask(with: request) {
      (data, response, error) in
      
      guard data != nil else {
        print("Error: did not receive data\n")
        return
      }
      guard error == nil else {
        return
      }
      
      var jsonObject: JSON?

      let decoder = JSONDecoder()
      do {
        jsonObject = try decoder.decode(JSON.self, from: data!)
      } catch {
        print("error trying to convert JSON authentication\n")
        print(error)
        completionBlock(nil)
        return
      }
  
      completionBlock(jsonObject!.response.user)
      return
    }
    currentTask?.resume()
  }
  
  
  internal static func getWatchlist(user: User,
                                    completionBlock: @escaping ([AppUser.movieTVEntry]) -> ()) {
    
    let session = URLSession(configuration: self.config)
    
    guard let url = URL(string:hostURL + "/getAppWatchlist/\(user.id)") else {
      print("URL could not be initialized.")
      return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.addValue(user.authentication_token,
                     forHTTPHeaderField: "Authentication-Token")
    
    currentTask = session.dataTask(with: request) {
      (data, response, error) in
      
      guard data != nil else {
        print("Error: did not receive data\n")
        return
      }
      guard error == nil else {
        return
      }
            
      var watchlist: [AppUser.movieTVEntry]?
      let decoder = JSONDecoder()
      do {
        watchlist = try decoder.decode([AppUser.movieTVEntry].self, from: data!)
      } catch {
        print("error trying to convert data to JSON")
        print(error)
        return
      }
    
      completionBlock(watchlist!)
      return
    }
    currentTask?.resume()
  }
  
}

