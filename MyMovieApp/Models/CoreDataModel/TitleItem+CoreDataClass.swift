//
//  TitleItem+CoreDataClass.swift
//  MyMovieApp
//
//  Created by Macbook on 7/5/24.
//
//

import Foundation
import CoreData

@objc(TitleItem)
public class TitleItem: NSManagedObject, Identifiable {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TitleItem> {
        return NSFetchRequest<TitleItem>(entityName: "TitleItem")
    }

    @NSManaged public var id: Int64
    @NSManaged public var media_type: String?
    @NSManaged public var original_name: String?
    @NSManaged public var original_title: String?
    @NSManaged public var overview: String?
    @NSManaged public var poster_path: String?
    @NSManaged public var release_date: String?
    @NSManaged public var vote_average: Double
    @NSManaged public var vote_count: Int64
}
