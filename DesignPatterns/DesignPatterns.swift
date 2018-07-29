//
//  DesignPatterns.swift
//  DesignPatterns
//
//  Created by GEORGE QUENTIN on 29/07/2018.
//  Copyright © 2018 Geo Games. All rights reserved.
//

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

-- Model-View-Controller-Networking (MVC-N) Pattern
 MVC seperates objects into 3 types: Models, Views and Controllers. However these 3 types
 actually overlap and the overlapping code like handling taps or loading data,
 actually working with a pattern called Model-View-Controller-Networking (MVC-N) pattern.
 This is even better than MVC because it seperates objects into 4 types.
 Instead of creating networking logic, MVC-N creates a network client to handle networking logic.
 Newtork client often make network request, serialise response Data into project specific models
 or domain models. and return models via a viewcontroller using a closure callback.
 You can put authentication logic into the Networking client, but it is not really great idea,
 so you can also pull out a Auth-Client from the Nteworking client as well,
 which split authentication logic from the netwroking client. By doing so,
 Auth-Client will have the single resposability of managing authentication.
 It will prompt the user to sign-in or register, create auth tokens, handle multiple simuntaneous
 authentication requests and also take care of handling the authentication errors.

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


-- Memento Pattern
 The memento pattern captures and externalizes an object state, basically it stores and saves
 your stuff. The memento pattern consist of three parts, an Originator, Memento and Care Taker.
 The Orginator is the object that actually does the encoding, for example you may convert
 the object to data. The Memento is the object that is meant to be encoded,
 and the Care Taker stores the encoded object.
 You can use NSKeyArchiver to encode objects into data. Then you can create an <Encodable>
 protocolto which are Memento objects that we will conform. Lastly you can use UserDefault to
 store the encoded data.

-- Design Principles - Composition vs Inheritance
 A design principle is a general good advice guideline that is used by many design patterns.
 Design patterns are characterised as by design principles.
 Design by composition is one of the most central design principle,
 and is followed my most design patterns.
 Design by Composition refers to the ability to achieve polymorphic behaviour and code reuse
 by composition rather than inheritance. What this means is that you should prefer to use
 other classes instead of subclassing to share behaviours.
 There is a related design principle to composition over inheritance, which is called the
 dependency inversion principle. This states that you should prefer to depend on abstractions
 instead of details. essentially, this design principle asks 'how can you changes?'.
 The solution is to depend on things that never change. To do this, you design your classes
 to depend on protocols instead of other concrete classes directly.
 This is especially important when it is likely that the dependency will change in the future.
 For example, instead of having Network-Client depend directly on Auth-Client.
 You can make it depend on an Auth-Token provider protocol,
 which defines excatly what the Network-Client needs. this way even if you completely change how
 Auth-Client is implemented in the future, you wont change the Auth-Token provider
 and network clients wont be impacted at all.

-- DRY
 DRY is an acronym for Dont Repeat Yourself. it was introduced by the book
 'The Pragmatic Programmer'. Basically, repeating yourself, copying and pasting code or
 UI elemnets is bad because it is more likely to lead to bugs later on. in such,
 if you later decise to change code that you've copied, you will need to also remember to
 update it everywhere that you duplicated it. the more copies you make, the more likely you
 are going forget to update the one in some place which may lead to inconsistant behaviour or even
 crashes in your App.

-- Visitor Pattern
 The visitor pattern involves two main types, a Visitor and a Visitable. we can use double
 dispatch to pass around type information from the Visitable to the Visitor.
 Double Dispatch is a central idea of the visitor pattern.

 */
