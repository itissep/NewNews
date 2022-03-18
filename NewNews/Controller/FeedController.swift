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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        layout()
        
        topicsCollectionView.delegate = self
        topicsCollectionView.dataSource = self
        
        
        

    }
    
    
    
    let topics = ["first", "second", "third", "very big one", "first", "second", "third", "first", "second", "third", ]
    
    
    lazy var logoImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "LOGO"))
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    
    
    lazy var btn: UIButton = {
        let button = UIButton()
        button.setTitle("Go", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemRed
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
    
    @objc func buttonAction() {
//        NetworkManager.shared.getNewswire(source: "all", section: "all") { articles in
//            for article in articles {
//                print(article.title)
//            }
//        }
        
        let nav = UITabBarController()
        
        let vc1 = FirstVC()
        let vc2 = SecondVC()
        let vc3 = ThirdVC()
        let vc4 = ForthVC()
        
        
        vc4.title = "Settings"
        vc3.title = "Favourite"
        vc2.title = "Search"
        vc1.title = "Feed"
        
        nav.tabBar.isTranslucent = false
        nav.view.backgroundColor = .white
        nav.tabBar.tintColor = .systemOrange
        
        nav.setViewControllers([vc1, vc2, vc3, vc4], animated: true)
        
        guard let items = nav.tabBar.items else  { return }
        let images = ["newspaper", "magnifyingglass", "bookmark", "gearshape"]
        
        for i in 0 ..< items.count {
            items[i].image = UIImage(systemName: images[i])
        }

        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
        
    }
    
    
    lazy var navBar: UITabBarController = {
        let nav = UITabBarController()
        
        let vc1 = FirstVC()
        let vc2 = SecondVC()
        let vc3 = ThirdVC()
        let vc4 = ForthVC()
        
        vc4.title = "Settings"
        vc3.title = "Favourite"
        vc2.title = "Search"
        vc1.title = "Feed"
        nav.tabBar.isTranslucent = false
//        nav.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.orange]
        nav.tabBar.tintColor = .black
        nav.tabBar.barTintColor = .orange
        nav.setViewControllers([vc1, vc2, vc3, vc4], animated: true)
        
        
        
        
        return nav
    }()
    
    
    
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
//            make.right.equalTo(view).offset(5)
            make.width.equalTo(view).offset(-20)
            make.height.equalTo(50)
            
//            make.edges.equalTo(view).inset(UIEdgeInsets(top: 5, left: 10, bottom: 15, right: 20))
            
        }
        
        
        
        
    }

}


extension FeedController: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//        let selectedCell = collectionView.cellForItem(at: indexPath) as! TopicCell
//        selectedCell.bottomView.backgroundColor = .green
//
//    }
    

//
//    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
//        let selectedCell = collectionView.cellForItem(at: indexPath) as! TopicCell
//        selectedCell.bottomView.backgroundColor = .white
//    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: indexPath) as! TopicCell
        selectedCell.bottomView.backgroundColor = .red
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: indexPath) as! TopicCell
        selectedCell.bottomView.backgroundColor = .white
    }
}

extension FeedController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let label = UILabel(frame: CGRect.zero)
            label.text = topics[indexPath.item]
        label.font = UIFont(name: "", size: 20)
            label.sizeToFit()
            return CGSize(width: label.frame.width, height: 32)
        }
}

extension FeedController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        topics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TopicCell
        cell.backgroundColor = .white
        cell.label.text = topics[indexPath.item]
        return cell
    }
    
    
}



class TopicCell: UICollectionViewCell {
    
    static let reuseIdentifier = "cell"
    
    
    
    lazy var label: UILabel = {
        let l = UILabel()
        l.textColor = .green
        l.text = "wow"
        return l
    }()
    
    lazy var bottomView: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 2
        v.backgroundColor = .white
        
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.addSubview(label)
        contentView.addSubview(bottomView)
        
        bottomView.snp.makeConstraints { make in
            make.width.equalTo(self.contentView)
            make.height.equalTo(4)
            make.bottom.equalTo(self.contentView)
        }
        label.snp.makeConstraints { make in
            make.center.equalTo(self.contentView)
            make.width.equalTo(self.contentView)
//            make.left.equalTo(5)
//            make.height.equalTo(10)
//            make.top.equalTo(self.contentView)
//            make.left.equalTo(self.contentView)
//            make.width.equalTo(self.contentView)
            
            
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




class FirstVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        title = "Feed"
    }
}
class SecondVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .green
        title = "Search"
    }
}
class ThirdVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .blue
        title = "Favourite"
    }
}
class ForthVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .purple
        title = "Settings"
    }
}
