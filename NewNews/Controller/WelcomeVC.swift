//
//  WelcomeVC.swift
//  NewNews
//
//  Created by The GORDEEVS on 18.03.2022.
//

import UIKit
import SnapKit

class WelcomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        layout()

        // Do any additional setup after loading the view.
    }
    
    
    lazy var goButton: UIButton = {
        let btn = UIButton()
        
        btn.titleLabel?.text = "Go"
        btn.tintColor = .systemOrange
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    lazy var label: UILabel = {
        let l = UILabel()
        l.text = "Wanna find out news?"
        l.textColor = .systemOrange
        l.numberOfLines = 0
        
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    func layout(){
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalTo(view.center)
            make.height.equalTo(25)
            make.width.equalTo(225)
        }
        
        
        
        view.addSubview(goButton)
        goButton.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(label).offset(20)
            make.left.equalTo(label).offset(20)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
