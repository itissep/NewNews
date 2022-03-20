//
//  TopicCell.swift
//  NewNews
//
//  Created by The GORDEEVS on 19.03.2022.
//

import UIKit


class TopicCell: UICollectionViewCell {
    
    static let reuseIdentifier = "cell"
    
    var sectionName: String?
    
    
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
