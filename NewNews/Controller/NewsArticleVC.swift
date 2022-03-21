//
//  NewsArticleVC.swift
//  NewNews
//
//  Created by The GORDEEVS on 20.03.2022.
//

import UIKit


class NewsArticleVC: UIViewController {
    
    var article: NewswireArticle?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
        
        guard let title = article?.title else { return }
        
        if RealmManager.shared.finder(title: title) {
            setImageForBtn(btn:bookmarkBtn, imageName: "bookmark.fill")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        RealmManager.shared.update()
    }
    
    lazy var coverImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "someimage")
        imageView.clipsToBounds = true
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    

    lazy var shareBtn: UIButton = {
        let button = UIButton()
        
        setImageForBtn(btn:button, imageName: "square.and.arrow.up")
        button.tintColor = .systemOrange
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(shareArticle), for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFit
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    lazy var bookmarkBtn: UIButton = {
        let button = UIButton()
        setImageForBtn(btn:button, imageName: "bookmark")
        
        button.tintColor = .systemOrange
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
        guard let string = article?.url, let url = URL(string: string) else { return }
        let shareSheetVC = UIActivityViewController(activityItems: [
            url
        ], applicationActivities: nil)
        present(shareSheetVC, animated: true)
        
    }
    
    
    private func setImageForBtn(btn:UIButton, imageName: String){
        let config = UIImage.SymbolConfiguration(
            pointSize: 28, weight: .regular, scale: .medium)
        let image = UIImage(systemName: imageName, withConfiguration: config)
        btn.setImage(image, for: .normal)
    }
    
    
    @objc func setBookmark(){
        guard let article = article else { return }
        if RealmManager.shared.finder(title: article.title) {
            RealmManager.shared.delete(title: article.title)
            setImageForBtn(btn:bookmarkBtn, imageName: "bookmark")
        } else {
            let fav = Bookmark()
            
            fav.title = article.title
            fav.abstract = article.abstract
            fav.byline = article.byline
            fav.published_date = article.published_date
            fav.imageUrl = article.multimedia?.last?.url ?? "https://jaxenter.com/wp-content/uploads/2017/12/java-let-it-flow-2.3.png"

            RealmManager.shared.create(item: fav)
            setImageForBtn(btn:bookmarkBtn, imageName: "bookmark.fill")
        }
    }
    
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = article?.title
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont(name: "", size: 20)
        label.sizeToFit()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    lazy var btn: UIButton = {
        let button = UIButton()
        button.setTitle("To article".localized(), for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = .systemOrange
        button.titleLabel?.adjustsFontSizeToFitWidth = true
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
    
    
    //MARK: - layout
    private func layout(){
        view.backgroundColor = .white

        view.addSubview(coverImageView)
        coverImageView.snp.makeConstraints { make in
            make.left.equalTo(view)
            make.top.equalTo(view)
            make.width.equalTo(view)
            make.height.equalTo(300)
        }
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(coverImageView.snp.bottom).offset(20)
            make.left.equalTo(view).offset(30)
            make.right.equalTo(view).offset(-110)
        }
        
        view.addSubview(orangeRect)
        orangeRect.snp.makeConstraints { make in
            make.top.equalTo(coverImageView.snp.bottom).offset(20)
            make.left.equalTo(view).offset(20)
            make.width.equalTo(5)
            make.height.equalTo(titleLabel.snp.height)
        }
        
        view.addSubview(bookmarkBtn)
        bookmarkBtn.snp.makeConstraints { make in
            make.right.equalTo(view.snp.right).offset(-20)
            make.centerY.equalTo(orangeRect.snp.centerY)
            make.width.equalTo(35)
            make.height.equalTo(35)
        }
        
        view.addSubview(shareBtn)
        shareBtn.snp.makeConstraints { make in
            make.right.equalTo(bookmarkBtn.snp.left).offset(-10)
            make.centerY.equalTo(orangeRect.snp.centerY)
            make.width.equalTo(35)
            make.height.equalTo(35)
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
