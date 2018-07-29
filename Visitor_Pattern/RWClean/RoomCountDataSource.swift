//
//  RoomCountDataSource.swift
//  RWClean
//
//  Created by Joshua Greene on 5/3/17.
//  Copyright © 2017 Razeware, LLC. All rights reserved.
//

import Foundation

public struct RoomCountDataSource: RoomCountDataSourceProtocol {
  public var imageName: String?
  public var hideNextButton: Bool
  public var roomTitlePlural: String
  
  public var count: UInt {
    get {
      return getCount()
    } set {
      setCount(newValue)
    }
  }
  public var getCount: () -> UInt
  public var setCount: (UInt) -> Void
  
}

extension RoomCountDataSource {
  
  public static func bathrooms(homeInfo: MutableHomeInfo, hideNextButton: Bool) -> RoomCountDataSource {
    return RoomCountDataSource(imageName: "bathroom", hideNextButton: hideNextButton,
                               roomTitlePlural: "Bathrooms",
                               getCount: { homeInfo.bathroomCount },
                               setCount: { homeInfo.setBathroomCount($0) })
  }
  
  public static func bedrooms(homeInfo: MutableHomeInfo, hideNextButton: Bool) -> RoomCountDataSource {
    return RoomCountDataSource(imageName: "bedroom", hideNextButton: hideNextButton,
                               roomTitlePlural: "Bedrooms",
                               getCount: { homeInfo.bedroomCount },
                               setCount: { homeInfo.setBedroomCount($0) })
  }
  
  public static func otherRooms(homeInfo: MutableHomeInfo, hideNextButton: Bool) -> RoomCountDataSource {
    return RoomCountDataSource(imageName: "other_rooms", hideNextButton: hideNextButton,
                               roomTitlePlural: "Other Rooms",
                               getCount: { homeInfo.otherRoomsCount },
                               setCount: { homeInfo.setOtherRoomsCount($0) })
  }
  
}
