////
////  TypesCollectionVC.swift
////  NewNews
////
////  Created by The GORDEEVS on 17.03.2022.
////
//
//import UIKit
//
//
//
//
//class TypesCollectionVC: UICollectionViewController {
//    
//    private let reuseIdentifier = "Cell"
//    
//    let topics = ["first", "second", "third", "very big one", "first", "second", "third", "first", "second", "third", ]
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        layout()
//
//        // Uncomment the following line to preserve selection between presentations
//        // self.clearsSelectionOnViewWillAppear = false
//
//
//
//        // Do any additional setup after loading the view.
//    }
//    
//    
//    func layout(){
//
//        if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//                layout.scrollDirection = .vertical  // .horizontal
//            }
//        
//        collectionView.register(TopicCell.self, forCellWithReuseIdentifier: TopicCell.reuseIdentifier)
//        collectionView.showsHorizontalScrollIndicator = false
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//    }
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using [segue destinationViewController].
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//    // MARK: UICollectionViewDataSource
//
//    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of items
//        return 0
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
//    
//        // Configure the cell
//    
//        return cell
//    }
//
//    // MARK: UICollectionViewDelegate
//
//    
//    
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let selectedCell = collectionView.cellForItem(at: indexPath) as! TopicCell
//        selectedCell.bottomView.backgroundColor = .red
//    }
//    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        let selectedCell = collectionView.cellForItem(at: indexPath) as! TopicCell
//        selectedCell.bottomView.backgroundColor = .white
//    }
//}
//
//
//extension FeedController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//            let label = UILabel(frame: CGRect.zero)
//            label.text = topics[indexPath.item]
//        label.font = UIFont(name: "", size: 20)
//            label.sizeToFit()
//            return CGSize(width: label.frame.width, height: 32)
//        }
//}
