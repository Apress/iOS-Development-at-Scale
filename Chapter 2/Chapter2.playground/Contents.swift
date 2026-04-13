import UIKit

// MARK: - Reference Counting In Action

// Here is an example of ARC where we reference and assign it to another variable thus incrementing the reference count.

var reference1: Car?
var reference2: Car?

class Car {
   let name: String
   var engine: Engine?
   init(name: String) {
       self.name = name
       print("\(name) is being initialized")
   }
   deinit {
       print("\(name) is being deinitialized")
   }
}

reference1 = Car(name: "Herby")
// Prints "Herby is being initialized"
reference2 = reference1
// retain called
// Now there are two strong references to the single Car instance
reference1 = nil
// release called
reference2 = nil
// release called
// Prints "Herby is being deinitialized"
// Note how both strong references had to be broken before memory deallocation occured
/*:
In this next example we explore what happens when you create a strong reference cycle. This can happen if two class instances hold a strong reference to each other, such that each instance keeps the other alive.
*/

class Engine {
   let type: String
   init(type: String) {
       self.type = type
   }
   var car: Car?
   deinit {
       print("Engine \(type) is being deinitialized")
   }
}
var herby: Car?
var inlineSix: Engine?

herby = Car(name: "Herby_V2")
inlineSix = Engine(type: "Inline Six Cylinder")

herby?.engine = inlineSix
inlineSix?.car = herby

herby = nil
inlineSix = nil
//Note neither deinitializer is called

/*
 As you can see ARC still maintains a reference for the car and the engine, niether is deallocated even after assigning each variable to `nil`.

 To fix this we can use a weak reference.
*/
class Car_V2 {
   let name: String
   var engine: Engine_V2?
   init(name: String) {
       self.name = name
       print("\(name) is being initialized")
   }
   deinit {
       print("\(name) is being deinitialized")
   }
}

class Engine_V2 {
   let type: String
   init(type: String) {
       self.type = type
   }
   weak var car: Car_V2?
   deinit {
       print("Engine \(type) is being deinitialized")
   }
}

var ford: Car_V2?
var inlineFour: Engine_V2?

ford = Car_V2(name: "Ford")
inlineFour = Engine_V2(type: "Inline Four Cylinder")

ford?.engine = inlineFour
inlineFour?.car = ford

ford = nil
inlineFour = nil
// Prints:
// "Engine Inline Four Cylinder is being deinitialized"
// "Ford is being deinitialized"

// Using an unowned reference
class Car_V3 {
   let name: String
   var engine: Engine_V3?
   init(name: String) {
       self.name = name
       print("\(name) is being initialized")
   }
   deinit {
       print("\(name) is being deinitialized")
   }
}

class Engine_V3 {
   let type: String
   unowned let car: Car_V3
   init(type: String, car: Car_V3) {
       self.type = type
       self.car = car
   }
   
   deinit {
       print("Engine \(type) is being deinitialized")
   }
}

var chevy: Car_V3? = Car_V3(name: "Chevy")
chevy!.engine = Engine_V3(type: "V8 Super", car: chevy!)
// Prints:
// "Chevy is being deinitialized"
// "Engine V8 Super is being deinitialized"

