//
//  BookCell.swift
//  NewNews
//
//  Created by The GORDEEVS on 20.03.2022.
//

import UIKit
import SkeletonView



class BookCell: UICollectionViewCell {
    static let reuseIdentifier = "bookCellId"
    
    var book: Book?
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "someimage")
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.isSkeletonable = true
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.width.equalTo(self.contentView)
            make.height.equalTo(self.contentView)
            make.top.equalTo(self.contentView)
            make.left.equalTo(self.contentView)
        }
        
        self.isSkeletonable = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
