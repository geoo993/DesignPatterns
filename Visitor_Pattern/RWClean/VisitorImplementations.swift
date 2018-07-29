//
//  VisitorImplementations.swift
//  RWClean
//
//  Created by Joshua Greene on 5/3/17.
//  Copyright © 2017 Razeware, LLC. All rights reserved.
//



// MARK: - StoryboardVisitable
extension BathroomCountViewController: StoryboardVisitable {
  public func accept(_ visitor: StoryboardVisitor) {
    visitor.visit(self)
  }
}

extension BedroomCountViewController: StoryboardVisitable {
  public func accept(_ visitor: StoryboardVisitor) {
    visitor.visit(self)
  }
}


extension OtherRoomCountViewController: StoryboardVisitable {
  public func accept(_ visitor: StoryboardVisitor) {
    visitor.visit(self)
  }
}

extension HomeSquareFootageViewController: StoryboardVisitable {
  public func accept(_ visitor: StoryboardVisitor) {
    visitor.visit(self)
  }
}

extension KitchenSizeViewController: StoryboardVisitable {
  public func accept(_ visitor: StoryboardVisitor) {
    visitor.visit(self)
  }
}

// MARK: - DefaultStoryboardVisitor
public struct DefaultStoryboardVisitor: StoryboardVisitor {
  
  public func visit(_ vc: BathroomCountViewController) {
    vc.countDataSource = RoomCountDataSource.bathrooms(homeInfo: vc.homeInfo, hideNextButton: false)
  }
  public func visit(_ vc: BedroomCountViewController) {
    vc.countDataSource = RoomCountDataSource.bedrooms(homeInfo: vc.homeInfo, hideNextButton: false)
  }
  public func visit(_ vc: OtherRoomCountViewController) {
    vc.countDataSource = RoomCountDataSource.otherRooms(homeInfo: vc.homeInfo, hideNextButton: false)
  }
  public func visit(_ vc: HomeSquareFootageViewController) {
    // nothing
  }
  public func visit(_ vc: KitchenSizeViewController) {
    // nothing
  }
}

// MARK: - ReviewStoryboardVisitor
public struct ReviewStoryboardVisitor: StoryboardVisitor {
  
  public func visit(_ vc: BathroomCountViewController) {
    vc.countDataSource = RoomCountDataSource.bathrooms(homeInfo: vc.homeInfo, hideNextButton: true)
  }
  public func visit(_ vc: BedroomCountViewController) {
    vc.countDataSource = RoomCountDataSource.bedrooms(homeInfo: vc.homeInfo, hideNextButton: true)
  }
  public func visit(_ vc: OtherRoomCountViewController) {
    vc.countDataSource = RoomCountDataSource.otherRooms(homeInfo: vc.homeInfo, hideNextButton: true)
  }
  public func visit(_ vc: HomeSquareFootageViewController) {
    vc.homeInfoDataSource = HomeInfoDataSource(imageName: nil, hideNextButton: true)
  }
  public func visit(_ vc: KitchenSizeViewController) {
    vc.homeInfoDataSource = HomeInfoDataSource(imageName: nil, hideNextButton: true)
  }
}


