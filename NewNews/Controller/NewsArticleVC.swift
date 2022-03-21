//
//  NewsArticleVC.swift
//  NewNews
//
//  Created by The GORDEEVS on 20.03.2022.
//

import UIKit
import SwiftUI

class NewsArticleVC: UIViewController {
    
    var article: NewswireArticle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
        
        guard let title = article?.title else { return }
        
        if RealmManager.shared.finder(title: title) {
            let image = UIImage(systemName: "bookmark.fill")?.withTintColor(.white).resizeImage(targetSize: CGSize(width: 35, height: 35))
            bookmarkBtn.setImage(image, for: .normal)
        }
    }
    
    
    lazy var coverImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "someimage")
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    

    lazy var shareBtn: UIButton = {
        let button = UIButton()
        
        let image = UIImage(systemName: "square.and.arrow.up.fill")?.withTintColor(.white).resizeImage(targetSize: CGSize(width: 35, height: 35))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(shareArticle), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    lazy var bookmarkBtn: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "bookmark")?.withTintColor(.white).resizeImage(targetSize: CGSize(width: 35, height: 35))
        button.setImage(image, for: .normal)
        
        button.tintColor = .white
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(setBookmark), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    @objc func openInBrowser(){
        guard let article = self.article else { return }
        let articleURLString = article.url
        guard let articleUrl = URL(string: articleURLString) else { return }
        UIApplication.shared.open(articleUrl)
    }
    
    
    @objc func shareArticle(){
        print("shared")
    }
    
    
    @objc func setBookmark(){
        guard let article = article else { return }
        if RealmManager.shared.finder(title: article.title) {
            RealmManager.shared.delete(title: article.title)
            let image = UIImage(systemName: "bookmark")?.withTintColor(.white).resizeImage(targetSize: CGSize(width: 35, height: 35))
            bookmarkBtn.setImage(image, for: .normal)
        } else {
            let fav = Favourite()
            
            fav.title = article.title
            fav.abstract = article.abstract
            fav.byline = article.byline
            fav.published_date = article.published_date
            fav.imageUrl = article.multimedia?.last?.url ?? "https://jaxenter.com/wp-content/uploads/2017/12/java-let-it-flow-2.3.png"

            RealmManager.shared.create(item: fav)
            
            let image = UIImage(systemName: "bookmark.fill")?.withTintColor(.white).resizeImage(targetSize: CGSize(width: 35, height: 35))
            bookmarkBtn.setImage(image, for: .normal)
        }
    }
    
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = article?.title
        label.numberOfLines = 2
        label.textColor = .black
        label.font = UIFont(name: "", size: 20)
        label.sizeToFit()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var btn: UIButton = {
        let button = UIButton()
        button.setTitle("To article", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = .systemOrange
        button.titleLabel?.adjustsFontSizeToFitWidth = true
//        button.titleLabel?.numberOfLines = 1
//        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(openInBrowser), for: .touchUpInside)
        
        return button
    }()
    
    
    lazy var abstractLabel: UILabel = {
        let label = UILabel()
        
        label.text = article?.abstract
        label.numberOfLines = 0
        label.textColor = .systemGray
        label.font = UIFont(name: "", size: 16)
        label.sizeToFit()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    lazy var titleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    lazy var orangeRect: UIView = {
        let redView = UIView()
        redView.backgroundColor = .systemOrange
        
        redView.translatesAutoresizingMaskIntoConstraints = false
        return redView
    }()
    
    
    private func layout(){
        view.backgroundColor = .white

        view.addSubview(coverImageView)
        coverImageView.snp.makeConstraints { make in
            make.left.equalTo(view)
            make.top.equalTo(view)
            make.width.equalTo(view)
            make.height.equalTo(300)
        }

        view.addSubview(bookmarkBtn)
        bookmarkBtn.snp.makeConstraints { make in
            make.right.equalTo(view).offset(-20)
            make.top.equalTo(view).offset(20)
            make.width.equalTo(35)
            make.height.equalTo(35)
        }
        
        view.addSubview(shareBtn)
        shareBtn.snp.makeConstraints { make in
            make.right.equalTo(bookmarkBtn.snp.left).offset(-20)
            make.top.equalTo(view).offset(20)
            make.width.equalTo(35)
            make.height.equalTo(35)
        }

        view.addSubview(orangeRect)
        orangeRect.snp.makeConstraints { make in
            make.top.equalTo(coverImageView.snp.bottom).offset(20)
            make.left.equalTo(view).offset(20)
            make.width.equalTo(5)
            make.height.equalTo(50)
        }
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(orangeRect.snp.top)
            make.left.equalTo(orangeRect.snp.right).offset(5)
            make.right.equalTo(view).offset(-20)
            make.height.equalTo(50)
        }
        
        let forBtn: UIView?
        if article?.abstract != ""{
            view.addSubview(abstractLabel)
            abstractLabel.snp.makeConstraints { make in
                make.top.equalTo(orangeRect.snp.bottom)
                make.left.equalTo(view).offset(20)
                make.right.equalTo(view).offset(-20)
                make.height.equalTo(150)
            }
            forBtn = abstractLabel
            
        } else {
            forBtn = titleLabel
        }
        
        if let forBtn = forBtn {
            view.addSubview(btn)
            btn.snp.makeConstraints { make in
                make.top.equalTo(forBtn.snp.bottom).offset(20)
                make.left.equalTo(view).offset(20)
                make.right.equalTo(view).offset(-20)
                make.height.equalTo(50)
            }
        }
    }
}
