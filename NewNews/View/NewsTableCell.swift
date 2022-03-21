//
//  TableCell.swift
//  NewNews
//
//  Created by The GORDEEVS on 20.03.2022.
//

import UIKit
import SnapKit
import SkeletonView


class NewsTableCell: UITableViewCell {
    static let reusableId = "newsTableCellId"
    var article: NewswireArticle?
    
    lazy var title: UILabel = {
        let label = UILabel()
        label.text = "Some great label!"
        label.numberOfLines = 3
        label.isSkeletonable = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    lazy var time: UILabel = {
        let label = UILabel()
        label.text = "today"
        label.numberOfLines = 1
        label.textColor = .systemGray
        label.isSkeletonable = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    lazy var image: UIImageView = {
        let imageV = UIImageView()
        imageV.isSkeletonable = true
        imageV.image = UIImage(named: "someimage")
        imageV.clipsToBounds = true
        imageV.contentMode = .scaleAspectFill
        imageV.layer.cornerRadius = 10
        
        imageV.translatesAutoresizingMaskIntoConstraints = false
        return imageV
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        
        self.contentView.addSubview(image)
        image.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(10)
            make.left.equalTo(contentView).offset(20)
            make.height.equalTo(120)
            make.width.equalTo(120)
        }
    
        self.contentView.addSubview(title)
        title.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(30)
            make.left.equalTo(image.snp.right).offset(10)
            make.right.equalTo(contentView).offset(-20)
            make.height.equalTo(70)
        }

        self.contentView.addSubview(time)
        time.snp.makeConstraints { make in
            make.bottom.equalTo(contentView).offset(-20)
            make.left.equalTo(image.snp.right).offset(10)
            make.right.equalTo(contentView).offset(-20)
            make.height.equalTo(40)
        }
        
        self.isSkeletonable = true
        
    }
}

