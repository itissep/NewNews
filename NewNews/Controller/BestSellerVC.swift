//
//  SearchVC.swift
//  NewNews
//
//  Created by The GORDEEVS on 19.03.2022.
//

import UIKit
import SnapKit
import SkeletonView

class BestSellerVC: UIViewController {
    
    var booklists: [BookList] = []
    var books: [Book]?
    var currentList = BookList(list_name: "Education", list_name_encoded: "education")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        title = "Best Sellers".localized()
        
        layout()
        collectionView.dataSource = self
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        collectionView.showGradientSkeleton(usingGradient: .init(baseColor: .systemOrange), animated: true, delay: 0, transition: .crossDissolve(0.25))
        loadBooks()
    }
    
    
    lazy var btn: UIButton = {
        let button = UIButton()
        button.setTitle(currentList.list_name, for: .normal)
        button.setTitleColor(UIColor.systemOrange, for: .normal)
        button.backgroundColor = .white
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center
        button.layer.borderColor = UIColor.systemOrange.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let deferredMenus = UIMenu(title: "", children: [
                    UIDeferredMenuElement({ completion in
                        NetworkManager.shared.getBookLists { lists in
                            self.booklists = lists
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            let items = self.booklists.map { item in
                                UIAction(title: "\(item.list_name)") { _ in
                                    self.currentList = item
                                    self.loadBooks()
                                    self.btn.setTitle(self.currentList.list_name, for: .normal)
                                    self.btn.updateConfiguration()
                                }
                            }
                            completion([UIMenu(title: "", options: .displayInline, children: items)])
                        }
                    })
                ])
        button.menu = deferredMenus
        button.showsMenuAsPrimaryAction = true
        
        return button
    }()
    
    
    private func loadBooks(){
        collectionView.showGradientSkeleton(usingGradient: .init(baseColor: .systemOrange), animated: true, delay: 0, transition: .crossDissolve(0.25))
            
        NetworkManager.shared.getBookSellers(listName: self.currentList.list_name_encoded) { [weak self] books in
            DispatchQueue.main.async {
                self?.books = books
                self?.collectionView.reloadData()
                self?.collectionView.stopSkeletonAnimation()
                self?.view.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
            }
        }
    }
    
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = .zero
        layout.itemSize = CGSize(width: 150.0, height: 250.0)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(BookCell.self,
                                forCellWithReuseIdentifier: BookCell.reuseIdentifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isSkeletonable = true
        
        return collectionView
    }()
    
    
    private func layout(){
        view.addSubview(btn)
        btn.snp.makeConstraints { make in
            make.right.equalTo(view).offset(-10)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.width.equalTo(150)
            make.height.equalTo(50)
        }
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.left.equalTo(view).offset(35)
            make.top.equalTo(btn.snp.bottom).offset(10)
            make.width.equalTo(view.snp.width).offset(-70)
            make.bottom.equalTo(view)
        }
    }
}


//MARK: - SkeletonCollectionViewDataSource
extension BestSellerVC: SkeletonCollectionViewDataSource{
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return BookCell.reuseIdentifier
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
}


//MARK: - UICollectionViewDelegate
extension BestSellerVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {

    }
}


//MARK: - UICollectionViewDataSource
extension BestSellerVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return books?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookCell.reuseIdentifier, for: indexPath) as! BookCell
        cell.book = books?[indexPath.item]
        if let book = cell.book {
            cell.imageView.downloaded(from: book.book_image)
        }
        return cell
    }
}

