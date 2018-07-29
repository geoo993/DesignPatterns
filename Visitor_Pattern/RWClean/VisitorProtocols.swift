//
//  VisitorProtocols.swift
//  RWClean
//
//  Created by Joshua Greene on 5/3/17.
//  Copyright © 2017 Razeware, LLC. All rights reserved.
//

// MARK: - StoryboardVisitor
public protocol StoryboardVisitor {
  func visit(_ vc: BathroomCountViewController)
  func visit(_ vc: BedroomCountViewController)
  func visit(_ vc: OtherRoomCountViewController)
  func visit(_ vc: HomeSquareFootageViewController)
  func visit(_ vc: KitchenSizeViewController)
}

// MARK: - StoryboardVisitable
public protocol StoryboardVisitable {
  func accept(_ visitor: StoryboardVisitor)
}
