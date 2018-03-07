//
//  ViewController.swift
//  PlayingWithJSON
//
//  Created by Christopher Taylor on 3/6/18.
//  Copyright © 2018 Christopher Taylor. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    var collectionView: UICollectionView?
    let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    let customCellIdentifier = "imageCollectionViewCell"
    var imagesMetadata = [[String : String]]()

    
    // MARK: - Lifcycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        configureCollectionView()
        fetchJSON()
    }

    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesMetadata.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: customCellIdentifier, for: indexPath) as! ImageCollectionViewCell
        cell.contentView.backgroundColor = .black
        cell.clipsToBounds = true
        cell.downloadImage(url: URL(string:imagesMetadata[indexPath.item]["image_url"]!)!)
        return cell
    }

    
    // MARK: - Private
    
    private func updateUI() {
        collectionView!.reloadData()
    }
    
    private func configureCollectionView() {
        layout.sectionInset = UIEdgeInsets(top:0, left:0,bottom:0,right:0)
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2
        let sizeOfItem = (self.view.bounds.size.width - layout.minimumInteritemSpacing) * 0.5
        layout.itemSize = CGSize.init(width: sizeOfItem, height: sizeOfItem)
        
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView!.dataSource = self
        collectionView!.delegate = self
        collectionView!.backgroundColor = .white
        collectionView!.register(ImageCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: customCellIdentifier)
        self.view.addSubview(collectionView!)
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
                    self.parseJSON(json: json)
                }
            }
            catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
    
    private func parseJSON(json : [String : Any]) {
        var results = [[String : String]]()
        guard let photosArr = json["photos"] as? [[String : Any]] else {
            print("error parsing json")
            return
        }
        
        for dictionary in photosArr {
            var image_url = ""
            let base_url = "https://500px.com"

            guard let image_url_arr = dictionary["image_url"] as? [String] else {
                print("error parsing json")
                return
            }
            
            if image_url_arr.count > 0 {
                image_url = image_url_arr[0]
            }
            
            guard let path = dictionary["url"] as? String else {
                print("error parsing json")
                return
            }

            let url = base_url + path

            if image_url.count > 0 && url.count > 0 {
                var dict = [String : String]()
                dict["image_url"] = image_url
                dict["url"] = url
                results.append(dict)
            }
        }
        imagesMetadata = results
        DispatchQueue.main.async {
            self.updateUI()
        }
    }
}

