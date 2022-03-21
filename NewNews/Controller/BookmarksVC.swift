//
//  FavsVC.swift
//  NewNews
//
//  Created by The GORDEEVS on 19.03.2022.
//

import UIKit
import SkeletonView
import RealmSwift

class BookmarksVC: UIViewController {
    
    var bookmarks: [Bookmark] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        title = "Bookmarks"
        
        tableView.dataSource = self
        tableView.delegate = self
        RealmManager.shared.getFavourites { results in
            self.updateTableView(results: results)
        }
        
        self.hideKeyboardWhenTappedAround()
        self.tableView.reloadData()
        layout()
    }
    
    
    lazy var searchField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "search",
                                                             attributes:[NSAttributedString.Key.foregroundColor: UIColor.systemGray])
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 16
        textField.layer.borderWidth = 3
        textField.layer.borderColor = UIColor.systemOrange.cgColor
        textField.textColor = .black
        
        let image = UIImage(named: "magnifyer")?
            .resizeImage(targetSize: CGSize(width: 40, height: 40))
            .withInset(UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0))
        
        let leftImageView = UIImageView(image: image)
        leftImageView.clipsToBounds = true
        leftImageView.contentMode = .scaleAspectFill
        textField.leftView = leftImageView
        textField.leftViewMode = .always
        
        let clearButton = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 15, height: 15)))
        let clearImage = UIImage(systemName: "clear")?
            .withInset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10))?
            .withTintColor(.systemOrange)
        clearButton.setImage(clearImage, for: .normal)

        textField.rightView = clearButton
        clearButton.addTarget(self, action: #selector(clearSearch), for: .touchUpInside)

        textField.clearButtonMode = .never
        textField.rightViewMode = .whileEditing
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    
    @objc func clearSearch(){
        searchField.text = ""
    }
    
    
    @objc func textFieldDidChange(){
        guard let string = searchField.text else { return }
        if string == "" {
            RealmManager.shared.getFavourites { results in
                self.updateTableView(results: results)
            }
        } else {
            RealmManager.shared.search(string: string) { results in
                self.updateTableView(results: results)
            }
        }
    }
    
    func updateTableView(results: Results<Bookmark>){
        var newBookmarks: [Bookmark] = []
        for result in results {
            newBookmarks.append(result)
        }
        self.bookmarks = newBookmarks
        self.tableView.reloadData()
    }
    
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.register(NewsTableCell.self, forCellReuseIdentifier: NewsTableCell.reusableId)
        tableView.separatorColor = .clear
        tableView.rowHeight = 150
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isSkeletonable = true
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    
    private func layout(){
        view.addSubview(searchField)
        searchField.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
            make.height.equalTo(50)
            make.width.equalTo(120)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchField.snp.bottom).offset(10)
            make.left.equalTo(view)
            make.width.equalTo(view)
            make.bottom.equalTo(view)
        }
    }
    
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
        
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


extension BookmarksVC: UITextFieldDelegate {

    @objc private func buttonAction(){
        searchField.endEditing(true)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let input = searchField.text {
            print(input)
        }
        searchField.text = ""
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if searchField.text != "" {
            return true
        } else {
            searchField.placeholder = "type something"
            return false
        }
    }
}


//MARK: - UITableViewDelegate
extension BookmarksVC: UITableViewDelegate {
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
        present(articleView, animated: true)
    }
}



//MARK: - UITableViewDataSource
extension BookmarksVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookmarks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell = tableView.dequeueReusableCell(withIdentifier: NewsTableCell.reusableId) as! NewsTableCell
        
        let bookmark = bookmarks[indexPath.row]
        cell.article = NewswireArticle(url: bookmark.url, abstract: bookmark.abstract, title: bookmark.title, byline: bookmark.byline, published_date: bookmark.published_date, multimedia: nil)
        cell.title.text = bookmark.title
        cell.time.text = cell.article?.timeToShow
        
        cell.image.downloaded(from: bookmark.imageUrl, contentMode: .scaleAspectFill)
        
        return cell
    }
}
