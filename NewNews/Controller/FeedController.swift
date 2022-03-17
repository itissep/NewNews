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
        // Do any additional setup after loading the view.
    }
    
    
    
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

    

    
    @objc func buttonAction() {
//        NetworkManager.shared.getTopNews { articles in
//            for article in articles {
//                print(article.title)
//            }
//        }
        
        NetworkManager.shared.getNewswire(source: "all", section: "all") { articles in
            for article in articles {
                print(article.title)
            }
        }
        
        
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
        
        
    }

}

