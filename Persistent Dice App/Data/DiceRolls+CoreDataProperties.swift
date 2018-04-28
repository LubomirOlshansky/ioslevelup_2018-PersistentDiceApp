//
//  DiceRolls+CoreDataProperties.swift
//  Persistent Dice App
//
//  Created by Lubomir Olshansky on 28/04/2018.
//  Copyright © 2018 Lubomir Olshansky. All rights reserved.
//
//

import Foundation
import CoreData


extension DiceRolls {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DiceRolls> {
        return NSFetchRequest<DiceRolls>(entityName: "DiceRolls")
    }

    @NSManaged public var rolls: Int16
    @NSManaged public var time: NSDate?

}
