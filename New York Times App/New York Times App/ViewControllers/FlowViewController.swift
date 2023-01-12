//
//  FlowViewController.swift
//  New York Times App
//
//  Created by Mahmut Yazar on 9.01.2023.
//

import UIKit
import AVKit

class FlowViewController: UIViewController {
        
    @IBOutlet weak var collectionView: UICollectionView!
    
    let apiKey = "D2SQEcAnGLdQxnrSFMT4J78qt3jbBG5G"
    
    var results: [NewCellModel]? = []
    
    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "en_US_POSIX")
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss-hh:ss"
        return df
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        
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
                        
                        let apiNews = try! decoder.decode(News.self, from: data)
                        
                        guard let results = apiNews.results else {return}
                        
                        self.results = results.compactMap{
                            guard let slugname = $0.slugName,
                                  let imageUrl = $0.multimedia?.last?.url,
                                  let caption = $0.multimedia?.last?.caption,
                                  let newUrl = $0.url
                            else {return nil}
                            
                            return .init(
                                slugName: slugname,
                                imageUrl: imageUrl,
                                caption: caption,
                                newUrl: newUrl
                            )
                        }
                        
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

    extension FlowViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "WebVC") as! WebViewController
//        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
        
        NotificationCenter.default.post(name: Notification.Name("Text"), object: self.results![indexPath.row].newUrl)
        
    }
    
}

    extension FlowViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.results!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
        cell.captionLabel.text = self.results![indexPath.row].caption
//        cell.clipsToBounds = true
//        cell.layer.cornerRadius = 12
        
        downloadImage(from: self.results![indexPath.row].imageUrl) { response in
            DispatchQueue.main.async {
                cell.imageView.image = response.image
                cell.imageView.layer.cornerRadius = 3.0
                cell.imageView.layer.masksToBounds = true
            }
        }
        
        return cell
    }
}

extension FlowViewController: PinterestLayoutDelegate {
    func collectionView(collectionView: UICollectionView, heightForPhotoAt indexPath: IndexPath, with width: CGFloat) -> CGFloat {
        
//        if let news = results[indexPath.item], let photo = news.image {
            let boundingRect = CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
        let rect = AVMakeRect(aspectRatio: .init(width: 200, height: 400), insideRect: boundingRect)

            return rect.size.height
//        }
//        return 0
    }
    
    func collectionView(collectionView: UICollectionView, heightForCaptionAt indexPath: IndexPath, with width: CGFloat) -> CGFloat {
        
        if let news = results?[indexPath.item] {
            let topPadding = CGFloat(8)
            let bottomPadding = CGFloat(12)
            let captionFont = UIFont.systemFont(ofSize: 15)
            let captionHeight = self.height(for: news.caption, with: captionFont, width: width) + bottomPadding
            
            return captionHeight
        }
        return 0
    }
    
    func height(for text: String, with font: UIFont, width: CGFloat) -> CGFloat {
        let nsstring = NSString(string: text)
        let maxHeight = CGFloat(64.0)
        let textAttributes = [NSAttributedString.Key.font: font]
        let boundingRect = nsstring.boundingRect(with: CGSize(width: width, height: maxHeight), options: .usesLineFragmentOrigin, attributes: textAttributes, context: nil)
        
        return ceil(boundingRect.height)
    }
    
}


//MARK: - Image Downloader

extension FlowViewController {
    func downloadImage(from URLString: String, with completion: @escaping (_ response: (status: Bool, image: UIImage? ) ) -> Void) {
        guard let url = URL(string: URLString) else {
            completion((status: false, image: nil))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                completion((status: false, image: nil))
                return
            }
            
            guard let httpURLResponse = response as? HTTPURLResponse,
                  httpURLResponse.statusCode == 200,
                  let data = data else {
                completion((status: false, image: nil))
                return
            }
            guard let image = UIImage(data: data) else {return}
//            self.downloadedImage = image
            completion((status: true, image: image))
        }.resume()
    }
}
