//
//  FlowViewController.swift
//  New York Times App
//
//  Created by Mahmut Yazar on 9.01.2023.
//

import UIKit

class FlowViewController: UIViewController {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let apiKey = "D2SQEcAnGLdQxnrSFMT4J78qt3jbBG5G"
    
    var results: [Result]? = []
    
    var captions: [String] = []
    var imageUrls: [String] = []
    
    var multimedia: Multimedia?
    
    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "en_US_POSIX")
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss-hh:ss"
        return df
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        setupCollectionView()
    }
    
    private func fetchData() {
        
        if let url = URL(string: "https://api.nytimes.com/svc/news/v3/content/nyt/world.json?api-key=\(apiKey)") {
            
            var request: URLRequest = .init(url: url)
            request.httpMethod = "GET"
            request.setValue(apiKey , forHTTPHeaderField: "api-key")
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
                if error != nil {
                    print("error!")
                    return
                }
                
                if let data = data {
                    
                    do {
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .formatted(self.dateFormatter)
                        let news = try! decoder.decode(News.self, from: data)
                        
                        self.results = news.results!
                        
                        if self.results!.count > 0 {
                            let captions = self.results!.compactMap { new in
                                return new.multimedia?.last?.caption
                            }
                            let imageUrl = self.results!.compactMap { new in
                                return new.multimedia?.last?.url
                            }
                            var nonNilCaptions = captions.compactMap{$0}
                            var nonNilUrls = imageUrl.compactMap{$0}
                            
                            let stringToRemove = ""
                            for object in nonNilCaptions {
                                if object == stringToRemove {
                                    nonNilCaptions.remove(at: nonNilCaptions.firstIndex(of: stringToRemove)!)
                                }
                            }
                            
                            for url in nonNilUrls {
                                if url == stringToRemove {
                                    nonNilUrls.remove(at: nonNilUrls.firstIndex(of: stringToRemove)!)
                                }
                            }
                            self.captions = nonNilCaptions
                            self.imageUrls = nonNilUrls
                        }
                        print(self.imageUrls)
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                    } catch {
                        print("Decoding Error!")
                    }
                }
            }
            task.resume()
        }
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(.init(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
    }
    
    @IBAction func closeClicked(_ sender: Any) {
        dismiss(animated: true)
    }
    
}


extension FlowViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.frame.width / 2, height: collectionView.frame.height / 2)
    }
    
    
}


extension FlowViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("bana basıldı")
    }
    
}

extension FlowViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return captions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        cell.captionLabel.text = captions[indexPath.row]
        cell.clipsToBounds = true
        cell.layer.cornerRadius = 12
        return cell
    }
    
}
