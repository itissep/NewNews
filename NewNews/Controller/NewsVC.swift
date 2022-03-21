//
//  ViewController.swift
//  NewNews
//
//  Created by The GORDEEVS on 17.03.2022.
//

import UIKit
import SnapKit
import SkeletonView
import Network


/*
 networking
    top 5

 top 5 collection view
 top 5 collection cell
 https://medium.com/swlh/swift-carousel-759800aa2952
    
 
 */

class NewsVC: UIViewController {
    
    var newswireData: [NewswireArticle]?
    var currentSection = "all"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        layout()
        
        topicsCollectionView.delegate = self
        topicsCollectionView.dataSource = self
        
        newsTableView.delegate = self
        newsTableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        newsTableView.showGradientSkeleton(usingGradient: .init(baseColor: .systemOrange), animated: true, delay: 0, transition: .crossDissolve(0.25))
        loadTableView()
    }
    
    
    lazy var logoImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "LOGO"))
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()


    lazy var topicsCollectionView: UICollectionView = {
        //TODO: first "All" selected
        
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TopicCell.self, forCellWithReuseIdentifier: TopicCell.reuseIdentifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    
    lazy var refreshControll: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.tintColor = .systemOrange
        refresh.addTarget(self, action: #selector(self.refreshing), for: .valueChanged)
        
        return refresh
    }()
    
    
    lazy var newsTableView: UITableView = {
        let tableView = UITableView()
        
        tableView.register(NewsTableCell.self, forCellReuseIdentifier: NewsTableCell.reusableId)
        tableView.separatorColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isSkeletonable = true
        return tableView
    }()
    
    
    @objc func refreshing(){
        loadTableView()
    }
    
    
    private func loadTableView(){
        newsTableView.showGradientSkeleton(usingGradient: .init(baseColor: .systemOrange), animated: true, delay: 0, transition: .crossDissolve(0.25))
        if newswireData != nil {
            self.newsTableView.scrollToTop()
        }
        
        NetworkManager.shared.getNewswire(source: "nyt", section: self.currentSection) { [weak self] articles in
            self?.newswireData = articles
            
            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                self?.newsTableView.reloadData()
                self?.refreshControll.endRefreshing()
                self?.newsTableView.stopSkeletonAnimation()
                self?.view.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
            }
        }
    }
    
    //MARK: - layout
    private func layout(){
        
        view.addSubview(logoImage)
        logoImage.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(view).offset(20)
            make.width.equalTo(100)
            make.height.equalTo(40)
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
            make.right.equalTo(view)
            make.left.equalTo(view)
            make.bottom.equalTo(view)
            
            make.width.equalTo(view)
        }
        newsTableView.addSubview(refreshControll)
        newsTableView.rowHeight = 150
    }
}


//MARK: - SkeletonTableViewDataSource
extension NewsVC: SkeletonTableViewDataSource{
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return NewsTableCell.reusableId
    }
}


//MARK: - UITableViewDelegate
extension NewsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! NewsTableCell
        let articleView = NewsArticleVC()
        articleView.article = cell.article ?? NewswireArticle(url: "https://www.youtube.com/watch?v=HNOOeRVq9Xw", abstract: "Original!!! Some words special for this perfect article about nothing and everythind at one time! ", title: "Some cool long title for an article", byline: "by someone special", published_date: "", multimedia: nil)
        articleView.coverImageView.downloaded(from: cell.article?.multimedia?.last?.url ?? "https://cdn.steemitimages.com/DQmRyzGkae4wYAg4iit6V1UrEhcdSctqRwKMMnkVc2kNFSh/Dump%20Truck%20Plastic.jpg")
        articleView.coverImageView.contentMode = .scaleAspectFill
        
        if let sheet = articleView.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }
        present(articleView, animated: true) {
            self.newsTableView.deselectRow(at: indexPath, animated: true)
        }
    }
}


//MARK: - UITableViewDataSource
extension NewsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newswireData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell = tableView.dequeueReusableCell(withIdentifier: NewsTableCell.reusableId) as! NewsTableCell
        
        let view = UIView()
        let color: UIColor = UIColor( red: CGFloat(250.0/255.0), green: CGFloat(113.0/255.0), blue: CGFloat(30.0/255.0), alpha: CGFloat(0.2) )
        view.backgroundColor = color
        cell.selectedBackgroundView = view
        
        if let article = newswireData?[indexPath.row] {
            cell.article = article
            cell.title.text = article.title
            cell.time.text = article.timeToShow
            if let imageUrl = article.multimedia?.last?.url {
                cell.image.downloaded(from: imageUrl, contentMode: .scaleAspectFill)
            }
        }
        return cell
    }
}



//MARK: - UICollectionViewDelegate
extension NewsVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: indexPath) as! TopicCell
        selectedCell.bottomView.backgroundColor = .systemOrange
        
        guard let section = selectedCell.sectionName else { return }
        currentSection = section
        loadTableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: indexPath) as! TopicCell
        selectedCell.bottomView.backgroundColor = .white
    }
}


//MARK: - UICollectionViewDelegateFlowLayout
extension NewsVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let label = UILabel(frame: CGRect.zero)
        label.text = K.topics[indexPath.item].display_name
        label.font = UIFont(name: "", size: 20)
            label.sizeToFit()
            return CGSize(width: label.frame.width, height: 32)
        }
}


//MARK: - UICollectionViewDataSource
extension NewsVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        K.topics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = K.topics[indexPath.item]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopicCell.reuseIdentifier, for: indexPath) as! TopicCell
        cell.backgroundColor = .white
        cell.sectionName = section.section
        cell.label.text = section.display_name
        
        return cell
    }
}

