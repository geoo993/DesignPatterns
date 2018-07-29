//
//  DesignPatterns.swift
//  DesignPatterns
//
//  Created by GEORGE QUENTIN on 29/07/2018.
//  Copyright © 2018 Geo Games. All rights reserved.
//

import Foundation

/* DESIGN PATTERNS

 design Patterns are re-usable solutions to development problems,
 they arent necessarilly temporary solutions but rather templates,
 that you can use in your own projects.
 Collectively they embody a form of best practices, promoting polymorphism,
 code reuse and much more.
 UIKit if full of design patterns such as model ViewController, Delegate and much more.
 When should you learn design pattern?
 well instead of re-inventing the wheel every time, you could leverage design patterns, and save
 yourself a lot of time by doing so.
 By learning design pattern you will also gain a common vocabulary that you can use with other
 developers.
 and by using design patterns, you are also likely to write maintainable code and testable code too.
 when we are talking about design pattern we are mostly talking about these specifically:
 - Structuring for design patterns
 - MVC-N
 - MVVM
 - Multicast Closure Delegate
 - Auto Re-Login Auth Client
 - Memento
 - Composition over inheritance
 - Visitor


 -- Grouping by Type
 One way to structire your project, is grouping only by types is only useful for small apps,
 because as you start using more
 Controllers, more Views, or more Models. You are more likely to start miss-using
 dependencies, and create tangled tightly coupled code.

-- Grouping by function
 Another way to structure your project is grouping by function, or purpose, such as Login,
 Welcome, Services, Home, Networking, etc...
 and within each of these groups you can start grouping by types.
 By grouping by function, it is easier to scale later on.

-- Model-View-Controller (MVC) Pattern
 MVC seperates objects into 3 types: Models, Views and Controllers. However these 3 types
 actually overlap and the overlapping code like handling taps or loading data,
 actually working with a pattern called Model-View-Controller-Networking (MVC-N) pattern.
 This is even better than MVC because it seperates objects into 4 types.
 Instead of creating networking logic, MVC-N creates a network client to handle networking logic.
 Newtork client often make netwrok request, serialise response Data into project specific models
 or domain models. and return models via a viewcontroller using a closure callback

-- Model-View-View-Model (MVVM) Pattern
 MVVM seprates objects into 3 types, Models, Views and View Models.
 Controllers still do excist in MVVM, but they arent the main focus of the pattern.
 Instead, View Models are. Instead of a controller owning models directly, it now owns View Models
 instead, in turn View Models will run the Models. This allows View Models to act as an
 intermediary to the Models and perform a critical role such as, transforming Model data
 into a View representation.

-- Delegate Pattern
 The delegate pattern uses a delegating or sending object, a delegate protocol and
 also a delegate object that implements the protocol. Whenever something delegate worthy happens
 the sender sends a message to the delegate. This is a fancy way of saying that it calls
 a delagate function on the delegate. However is fine of think of this as a sender launching a
 rocket into its delegate. The multi cast delegate pattern is a spin-off pattern from delegate.
 Instead of just one delegate however, it has many. When ever something delegate worthy happens,
 it notifies all its delegates, The multicast closure delegate pattern, is a spin off pattern from
 the multicast delegate pattern. It uses a multicast closure delegate instance,
 which accepts closure instead of requiring delegates to conform to a delegate protocol.
 Instead of being called directly the delegates will be called indirectly
 to keep the closures strongly references.





 */
