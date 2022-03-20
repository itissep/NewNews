//
//  ViewController.swift
//  NewNews
//
//  Created by The GORDEEVS on 17.03.2022.
//

import UIKit
import SnapKit


/*
 networking
    top 5
    latest
 
 
 Types collection view
 Types collection cell
 
 top 5 collection view
 top 5 collection cell
 https://medium.com/swlh/swift-carousel-759800aa2952
 
 latest table view
 latest table cell
 
 menu
    main
    search
    favorite
    
 
 */

class FeedController: UIViewController {
    
    var newswireData: [NewswireArticle]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        layout()
        
        topicsCollectionView.delegate = self
        topicsCollectionView.dataSource = self
        
        newsTableView.dataSource = self
        
        loadTableView(section: "all")

    }
    
    @objc func buttonAction() {
        
    }
    
    
    lazy var logoImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "LOGO"))
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    
    lazy var btn: UIButton = {
        let button = UIButton()
        button.setTitle("Problem", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemOrange
        button.layer.cornerRadius = 16
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()


    lazy var topicsCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TopicCell.self, forCellWithReuseIdentifier: TopicCell.reuseIdentifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    
    lazy var newsTableView: UITableView = {
        let tableView = UITableView()
        
        tableView.backgroundColor = .systemOrange
        tableView.register(NewsTableCell.self, forCellReuseIdentifier: NewsTableCell.reusableId)
        tableView.separatorColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    
    private func loadTableView(section: String){
        NetworkManager.shared.getNewswire(source: "nyt", section: section) { [weak self] articles in
            self?.newswireData = articles
            
            DispatchQueue.main.async {
                self?.newsTableView.reloadData()
            }
        }
    }
    
    
    private func layout(){
        
        view.addSubview(logoImage)
        logoImage.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(view).offset(20)
            make.width.equalTo(100)
            make.height.equalTo(40)
        }
        
        view.addSubview(btn)
        btn.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.right.equalTo(view).offset(-20)
        }
        
        view.addSubview(topicsCollectionView)
        topicsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(70)
            make.left.equalTo(view).offset(20)
            make.width.equalTo(view).offset(-20)
            make.height.equalTo(50)
            
        }
        
        view.addSubview(newsTableView)
        newsTableView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(topicsCollectionView.snp.bottom).offset(10)
            make.right.equalTo(view).offset(-20)
            make.left.equalTo(view).offset(20)
            make.bottom.equalTo(view)
            
            make.width.equalTo(view).offset(-40)
        }
        
        newsTableView.rowHeight = 150
    }

}


extension FeedController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newswireData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell = tableView.dequeueReusableCell(withIdentifier: NewsTableCell.reusableId) as! NewsTableCell
        if let article = newswireData?[indexPath.row] {
            cell.title.text = article.title
            cell.time.text = article.timeToShow
            if let imageUrl = article.multimedia?[2].url {
                cell.image.downloaded(from: imageUrl, contentMode: .scaleAspectFill)
            }
        }
        return cell
    }
}



//MARK: - UICollectionViewDelegate
extension FeedController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: indexPath) as! TopicCell
        selectedCell.bottomView.backgroundColor = .systemOrange
        
        guard let section = selectedCell.sectionName else { return }
        loadTableView(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: indexPath) as! TopicCell
        selectedCell.bottomView.backgroundColor = .white
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension FeedController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let label = UILabel(frame: CGRect.zero)
        label.text = K.topics[indexPath.item].display_name
        label.font = UIFont(name: "", size: 20)
            label.sizeToFit()
            return CGSize(width: label.frame.width, height: 32)
        }
}

//MARK: - UICollectionViewDataSource
extension FeedController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        K.topics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = K.topics[indexPath.item]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TopicCell
        cell.backgroundColor = .white
        cell.sectionName = section.section
        cell.label.text = section.display_name
        
        return cell
    }
    
    
}

