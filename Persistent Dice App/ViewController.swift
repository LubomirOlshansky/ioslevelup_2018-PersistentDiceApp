//
//  ViewController.swift
//  Persistent Dice App
//
//  Created by Lubomir Olshansky on 27/04/2018.
//  Copyright © 2018 Lubomir Olshansky. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    let cell = "cellID"
    var diceCollection: UICollectionView!
    private var diceRolls = [DiceRolls]()
    private var appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let padding: CGFloat =  50
        let collectionViewSize = self.view.frame.size.width - padding
        layout.itemSize = CGSize(width: collectionViewSize/2.0, height: collectionViewSize/2.0)
        
        diceCollection = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        diceCollection.delegate   = self
        diceCollection.dataSource = self
        diceCollection.register(CollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        diceCollection.backgroundColor = UIColor.white
        diceCollection.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
        self.view.addSubview(diceCollection)
        
        diceCollection.translatesAutoresizingMaskIntoConstraints = false
        diceCollection.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        diceCollection.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        diceCollection.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        diceCollection.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }

    @objc func tap(sender: UITapGestureRecognizer){
        newRoll()
        fetchData()
        diceCollection.reloadData()
    }
    func newRoll() {
        let data = random(1..<7)
        let diceRoll = DiceRolls(entity: DiceRolls.entity(), insertInto: context)
        
        diceRoll.rolls = Int16(data)
        diceRoll.time = Date() as NSDate
        
        appDelegate.saveContext()
    }
    
    func fetchData() {
        let request = DiceRolls.fetchRequest() as NSFetchRequest<DiceRolls>
        let sort = NSSortDescriptor(keyPath: \DiceRolls.time, ascending: true)
        request.sortDescriptors = [sort]
        do {
            diceRolls = try context.fetch(request)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
 
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (_) in
            
            let orientation = newCollection.verticalSizeClass
            
            switch orientation {
            case .compact:
                let layout = UICollectionViewFlowLayout()
                layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
                layout.minimumLineSpacing = 50
                let collectionViewSize = self.view.frame.size.height
                layout.itemSize = CGSize(width: collectionViewSize/2.5, height: collectionViewSize/2.5)
                self.diceCollection.collectionViewLayout = layout
                self.diceCollection.reloadData()
            default:
                let layout = UICollectionViewFlowLayout()
                layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
                let padding: CGFloat =  50
                let collectionViewSize = self.view.frame.size.width - padding
                layout.itemSize = CGSize(width: collectionViewSize/2.0, height: collectionViewSize/2.0)
                self.diceCollection.collectionViewLayout = layout
                self.diceCollection.reloadData()
            }
        }, completion: { (UIViewControllerTransitionCoordinatorContext) -> Void in
            print("rotation completed")
        })
        
        super.willTransition(to: newCollection, with: coordinator)
    }
    
     func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return diceRolls.count
    }
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        
        
        let dice = DiceView(frame: cell.bounds)
        let rolls = diceRolls[indexPath.row]
        dice.result = Int(rolls.rolls)
        cell.diceView.subviews.forEach({ $0.removeFromSuperview() })
        cell.diceView.addSubview(dice)
        
        return cell
    }
}

extension ViewController {
    func random(_ range:Range<Int>) -> Int
    {
        return range.lowerBound + Int(arc4random_uniform(UInt32(range.upperBound - range.lowerBound)))
    }
}
