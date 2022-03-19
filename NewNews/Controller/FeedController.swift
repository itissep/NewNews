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
    
    @objc func buttonAction() {

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
//            make.right.equalTo(view).offset(5)
            make.width.equalTo(view).offset(-20)
            make.height.equalTo(50)
            
//            make.edges.equalTo(view).inset(UIEdgeInsets(top: 5, left: 10, bottom: 15, right: 20))
            
        }
        
    }

}


extension FeedController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: indexPath) as! TopicCell
        selectedCell.bottomView.backgroundColor = .systemOrange
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
        l.textColor = .systemGray
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
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
