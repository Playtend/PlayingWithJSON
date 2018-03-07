//
//  ViewController.swift
//  PlayingWithJSON
//
//  Created by Christopher Taylor on 3/6/18.
//  Copyright © 2018 Christopher Taylor. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchJSON()
    }

    private func fetchJSON() {
        let url = URL(string:"https://api.500px.com/v1/photos?feature=fresh_today&sort=created_at&page=1&limit=10&image_size=4&include_store=store_download&include_states=voted&consumer_key=mSDECDmxoEEEw32OgaNxZxhUFuwiZetUaK9xTyTW")!
        let session = URLSession.shared
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request, completionHandler: {
            data, response, error in
            guard error == nil else {
                if let apiError = error {
                    print(apiError)
                }
                return
            }
            guard let data = data else {
                print("no data")
                return
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String : Any] {
                    print("json: \(json)")
                }
            }
            catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
}

