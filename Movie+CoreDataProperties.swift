//
//  Movie+CoreDataProperties.swift
//  dya6 movie demo
//
//  Created by MacBook on 04/05/2025.
//
//

import Foundation
import CoreData


extension Movie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie")
    }

    @NSManaged public var genre: String?
    @NSManaged public var id: UUID?
    @NSManaged public var image: String?
    @NSManaged public var rating: String?
    @NSManaged public var releaseYear: String?
    @NSManaged public var runTime: String?
    @NSManaged public var title: String?

}

extension Movie : Identifiable {

}
