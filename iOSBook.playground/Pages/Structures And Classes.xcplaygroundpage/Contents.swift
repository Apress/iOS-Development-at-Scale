//: [Previous](@previous)
/*:
 # Chapter 1 - Structures and Classes
 ##  Overview
 
 The goal of this section is to provide the reader with the tools and knowledge to architect app components as well as serve as a familiarization for future sections that reference the types outlined here. This is a not a detailed overview of every Swift type and language feature. Apple already wrote that and keeps it up to date much better than any book can. It behoves the reader to ensure they understand the types used here before moving on to other sections.
 
 ### This chapter includes:
 
 1. Knowledge of classes and structs that will re-appear in the design patterns and memory management sections.
 2. A first look into how to evaluate engineering tradeoffs. This is the most basic level of this, more complex tradeoffs will include product requirements, timelines, and cross functional concerns.
 3. For those less familiar with the Apple Ecosystem, or still primarily using Objective-C, this chapter serves as a Swift primer that covers the basic types and structures that are referenced in later sections.
 
 ## Structures And Classes
 
Structures and classes are general-purpose, flexible constructs that are the building blocks for your program’s code. In Swift Classes and Structs are similar and are both used to construct **instances**, however, the class is still what is thought of when contructing an **object** in the traditional object oriented sense. [Swift Docs](https://docs.swift.org/swift-book/LanguageGuide/ClassesAndStructures.html).
 
 > Object oriented programming is a style of programming where classes are created to model real world objects that have both **state** and **behavior**. An object is an instance of a class where the **state** is the properties of the class and the **behaviors** are the things that it does (the methods).
 
 */
import Foundation
enum DogBreed {
    case other
    case germanShepard
    case bizon
    case husky
}
class Dog {
    // parameters - part of the state.
    // the dogs name
    var name: String
    // the dogs breed, which could control barking volume
    var breed: DogBreed
    // when the dog was last fed, updates when the dog is fed
    var lastFed: Date?
    
    // initializer
    init(name: String, breed: DogBreed, lastFed: Date? ) {
        self.name = name
        self.breed = breed
        self.lastFed = lastFed
    }
    
    // method - part of the behavior
    // setting the time fed to time now
    func feed() {
        lastFed = Date()
    }
    
    // method - part of the behavior
    func bark() {
        switch (breed) {
        case .germanShepard:
            print("barking loud")
        default:
            print("barking moderate")
        }
    }
}

let dog = Dog(name: "Steve", breed: .germanShepard, lastFed: nil)
dog.bark()
/*:
 ### Similarities/Differences
 
 Both Structures and Classes can:
 * Define properties to store values
 * Define methods to provide functionality
 * Define subscripts to provide access to their values using subscript syntax
 * Define initializers to set up their initial state
 * Be extended to expand their functionality beyond a default implementation
 * Conform to protocols to provide standard functionality of a certain kind

 Classes have additional capabilities that structures don’t have:
 * Inheritance which enables one class to inherit the characteristics of another.
 * Type casting which allows a program to interpret the type of a class instance at runtime.
 * Deinitializers which enable an instance of a class to free up any resources it has assigned.
 * Reference counting, which allows more than one reference to a class instance.
     
*From the [Swift Docs](https://docs.swift.org/swift-book/LanguageGuide/ClassesAndStructures.html)*
 ### Value Verse Reference Semantics.
 
 Before jumping into value verse reference semantics lets discuss types. Swift supports both value and reference types where each instance of a value type keeps a unique copy of its own data. Common value types are Structs, Enums, Arrays, Strings, Dictionaries and Tuples. For reference types, instances share a single copy of the data and the type is usually defined as a class. In Swift NSObjects are reference types meaning that iOS engineers will interact with both value and reference semantics and being familiar with them is a must.
 
 Lets walk through a brief example using our `Dog` class above, but first lets create `DogStruct` so we can reason about value semantics as well.
 */

struct DogStruct {
    var name: String
    var breed: DogBreed
    var lastFed: Date?
}
/*:
 Now that we have our dog struct we can compare modifying a reference type to a value type. In both cases we set our variable and then try to change it via a copy.
 */

var dogClass = Dog(name: "Esparanza", breed: .bizon, lastFed: nil)
var refDog = dogClass
refDog.name = "hope"
// False - we have a reference type
print(dogClass.name != dogClass.name ? "True - we have a value type" : "False - we have a reference type")

var dogStruct = DogStruct(name: "Esparanza", breed: .bizon, lastFed: nil)
var valDog = dogStruct
valDog.name = "hope"
// True - we have a value type
print(dogStruct.name != valDog.name ?
      "True - we have a value type" :
        "False - we have a reference type")

/*:
As you can see from the above code sample the class represents reference semantics and we are able to change the dogs name for the initlal variable. However, with the struct we were not.  From this example it is clear that value types ensure a level of protection from unintended mutation, which is especially helpful in ensuring thread safety. This is not completely safe because a reference type could be added inside a value type. For example, adding mutable class instances to an array (a value type).
 */
var dog1 = Dog(name: "Esparanza", breed: .bizon, lastFed: nil)
var dog2 = Dog(name: "Bella", breed: .germanShepard, lastFed: nil)
let arr = [dog1, dog2]
var dTemp = arr[0]
// Esparanzabadvalue!
arr[0].name.append("badvalue!")
print(dTemp.name)

/*:
 Yikes! Apple themselves has mentioned this as unintended sharing. That said, it’s not always unintended sometimes you want to do this because you want to maintain common storage for efficiency reasons. Even in this situation you would want to implement some optimizations to prevent any unintended side effects from changing state.  This is typically refered to as the copy-on-write optimization (before writing the instance is copied and the write occurs on the copy).
 
 So far we've gone over reference and value types; however, Swift has some additional complexities in how values/objects express their typing. This is typically refered to as value and reference semantics. An example of this is using the `let` keyword. Using the `let` keyword we can get a reference type to express a bit of value semantics.
 */
let dog4 = Dog(name: "Esparanza", breed: .bizon, lastFed: nil)
dog4.name = "test"
let dog5 = dog4
dog4.name = "Max"
print("Dog4: \(dog4.name) Dog5: \(dog5.name)")
// dog4 = dog5 - error cannot assign to a let constant

/*:
 Notice that above defined dog variables as constants with `let`, yet you were able to change the name property. However, you were not able to mutate the instance itself i.e. you cannot set `dog4 = dog5`

 > For reference types, `let` means the reference must remain constant. In other words, you can’t change the instance the constant references, but you can mutate the instance itself.
 
 > For value types, `let` means the instance must remain constant. No properties of the instance will ever change, regardless of whether the property is declared with `let` or `var`.
 
 ## What does this all mean?

 1. As illustrated by our above examples if you are dealing with simple struct you know that you have value semantics by default.
 
 2. If you have a struct with composite properties (composite value type) you will have to ensure they also exhibit value semantics.
 
 3. If you have a class (reference type) make it immutable using the let keyword and constant properties. Again, it is imperitive the properties of the class and those properties themselves have value semantic types.
  
 ### Wrapping Up
 Immutable reference types have value semantics. While they are reference types they have value semantics in the sense that they behave like values, and someone else can't modify them. This is in line with Apples guidance and push towards value types and value semantics.

 This imples that types have value semantics relative to their access level. This is because a variable has value semantics if the only way to modify the value of the variable is through that variable itself. So, if a type has a file-private access modifier on something related to the type, then it is only accessible by code that was defined in the same file, but if it’s not file-parivate, then code written outside of the same file could modify it.
 
 ## Inheritance
  
 In Swift classes can use inheritance. Similar to other languages, inheritance allows classes to utilize methods, properties, and other characteristics from another class. When once class inherts from another this class is called the subclass and the class it inherits from is the superclass. This behavior is often referred to as subclassing. A class that does not inherit from any other class is commonly referred to as a base class.
    
 Swift inheritance supports calling and accessing methods, properties, and subscripts belonging to their superclass and allows sub-classes to provide their own overriding versions of those methods, properties, and subscripts to modify their behavior. In addition, Swift allows for classes to add property observers to inherited properties in order to be notified when the value of a property changes this works for both stored and computed properties.
 
 > Swift does not support multi-inheritance. Multi-inheriticance is when a class can inherit from multiple base classes.

  Extending our example from above we can create a base class animal that all animals conform to. We could then create another sub-class for dogs, and say cats.
 
 */
class Animal {
    // even wild animals have names here (you just don't know them)
    var name: String
    var breed: DogBreed
    // changing to lastEaten since wild animals don't get fed
    var lastEaten: Date?
    
    init(name: String, breed: DogBreed, lastEaten: Date?) {
        self.name = name
        self.breed = breed
        self.lastEaten = lastEaten
    }
    
    func eat() {
        self.lastEaten = Date()
    }
    
    // lions roar, cats, purr, dogs bark so subclasses will define this
    func makeNoise() {
        fatalError("requires implementation in subclass")
    }
}

// Now we can define a Dog as a sub-class of an animal
class DogSubClass: Animal {
    override func makeNoise() {
        if (breed == .germanShepard) {
            print("barking loud")
        } else {
            print("barking moderate")
        }
    }
}
/*:
 This is fine and dandy, but what happens when we have wolves? And wild dogs (and lions and tigers and bears - oh my)? Should these inherit direclty from animal? Or should they have there own superclass? We can create another class that defines canines and another for felines both with a more specific set of properties and methods that these -correct this phenotypes-- share? This seems like a solid approach; however, we have very quickly established a long tightly coupled inheritance chain that over time will become brittle and hard to maintain as over time the development team changes. This begs the question, is there a better way? Can this long object chain be avoided? Enter protocols.
 
 > A long time ago this author ran into this exact situation at his job. The inherticance structure had become some complex and filled with cruft over years and years of development by different engineers that it got to the point where in order to work properly any optic (or device using an optic) whether that was a weapon, laser, gun mount, or thermal sight all had to inherit from a binocular superclass.
 
 ## Protocols
 
 A protocol, much like an interface, defines a set of methods, properties, and other requirements a class, structure, or enumeration can then adopt a protocol to provide an concrete implementation of those requirements. A type that satisfies a protocol is said to conform to the protocol and types can conform to many protocols promoting the idea of composing objects based on behaviors.
 
 Protocols support properties, methods, and initializers. They can also be extended to provide a default implementation (defining behavior on the protocol itself). Protocols allow extensions to contain methods, initializers, subscripts, and computed property implementations.
 
 > A well designed protocol suits a particular task or piece of functionality and types can conform to multiple protocols further promoting composition.
 
 Lets review our previous example, but this time with protocols.
 
 Since a type can conform to multiple protocols our example is decomposed into pieces of functionality instead of characteristics.
 */
protocol AnimalProto {
    var name: String { get set }
    var breed: DogBreed { get set }
    
    init(name: String, breed: DogBreed)
}

protocol FeedsProto {
    var lastFed: Date? { get set }
    
    mutating func eat()
}

// Provides a default implementation for eating, if an animal requires custom logic say always making a noise when eating we could override the default implementation our specific animal struct.
extension FeedsProto {
    mutating func eat() {
        lastFed = Date()
    }
}

protocol ProduceSoundProto {
    func makeNoise();
}
// Now we can easily create dogs, wolves, and any number of animals
struct Dog_ProtoExample: AnimalProto, FeedsProto, ProduceSoundProto {
    var lastFed: Date?
    var name: String
    var breed: DogBreed
    
    // conforming to our protocol
    init(name: String, breed: DogBreed) {
        self.name = name
        self.breed = breed
    }
    
    func makeNoise() {
        print("barking...")
    }
}

struct Lion_ProtoExampe: AnimalProto, FeedsProto, ProduceSoundProto {
    var lastFed: Date?
    var name: String
    var breed: DogBreed
    
    // conforming to our protocol
    init(name: String, breed: DogBreed) {
        self.name = name
        self.breed = breed
    }
    
    func makeNoise() {
        print("roar...")
    }
    
    mutating func eat() {
        lastFed = Date()
        makeNoise() // lions always roar while eating (obviously)
    }
}
/*:
 
 ### Choosing
  
 A lot has been made about Protocol Oriented Programming (POP) and prefering Structs to Classes because they are easier to reason about as discussed in the [famous WWDC talk ](https://developer.apple.com/videos/play/wwdc2015/408). While this is all true there times where the additional capabilities provided by classes are required. As a senior software engineer it is your job to critically analyze the situation at hand and pick the best tool for the job. Don't start with a protocol just for the sake of protocol-oriented programming. Fully understand the problem at hand and let that drive the solution whether that is functional programming, object oriented programming, protocols, or something else entirely.
 
  For example, in our simple dog class above we modify the state every time the dog is fed. If we were using MVVM Architecture and the Dog class was a view model updated with new data either from an app action or server update then it is common to keep the model immutable. Thus we could have our dog class become a struct; however, say we wanted mutable state then the struct would no longer make sense. Or if our object was something more complex, say a network socket, then it cannot be inherintly copied and thus does not make sense as a struct.
 
  > Importantly, you can safely pass copies of values across threads without synchronization.
 
  The above example is a bit contrived, more generally value types are copied, whereas reference types get new references to the same underlying object. For reference types this means that mutations are visible to everything that has a reference, whereas mutations to value types only affect the storage you're mutating. When choosing between a value and a reference type consider how suitable your type is for copying (value type), and consider first using a value type for types that are copyable.
 
 Apple has written their own documentation on choosing [here](https://developer.apple.com/swift/blog/?id=10)
 
 ## Conclusion
 
 There are two important takeaways from this chapter:
 1. Structs and Classes both have their place and as an engineer it is important to understand both, the tradeoffs, and when to use which.
 2. Understanding reference and value semantics is a concept that extends beyond the Apple ecosystem and can impact how you develop code in many areas. Having a good understanding of this fundemental concept will assist you in debugging as well as creating bug free applications.
 
 For a complete overview of different swift types and more details see the [Swift book](https://docs.swift.org/swift-book/) and [Apple Docs]()
 */

// Develop with protocol without associated types. See it works. Now confusion is adding them
// means that we cannot create the variable the same way.

// Protocols with associated types
// Following our example from above the defined protocol encompasses animals
protocol Animal_EV_Proto { }

struct DogEV: Animal_EV_Proto { }

// now we could have
let myDog: Animal_EV_Proto = DogEV()
// and
let arrEV = [myDog]
// now lets say we add an associated type to define the type of food that the animal is eating.
// grass versus meat.
protocol Animal_EV_Proto2 {
    associatedtype Food // declare a requirement
    func eat(food: Food) -> ()
}
protocol Fodd {
}
struct Grass: Fodd {}
struct Meat: Fodd {}
struct DogEV2: Animal_EV_Proto {
    // meet the requirement
    typealias Food = Meat
    func eat(food: Food) -> () {
        print("Eating the food: ")
    }
}
struct Antelope: Animal_EV_Proto {
    // meet the requirement
    typealias Food = Grass
    func eat(food: Food) -> () {
        print("Eating the food: ")
    }
}

// but now if we have
//let dogs = [DogEV2(), Antelope()]
// Heterogeneous collection literal could only be inferred to '[Any]'; add explicit type annotation if this is intentional
// let myDog2: Animal_EV_Proto2 = DogEV2() as! Animal_EV_Proto2
// error: protocol 'Animal_EV_Proto2' can only be used as a generic constraint because it has Self or associated type requirements

// Why? Protocols allow for for a richer type expression than a typical inheritance based structure by allowing definitions like the above. For example, in an inherticance bassed structure you could not have one animal eat meat and the other grass since they do not conform to a base type. However, with protocols we can. This does bring a new constraint though where since the type of Food does not meet converge to a common type then the dynamic dispatch for type lookup will not work. Which explains the compiler message we see.

// That said how might we get around this limitation? In the previous versions of swift a wrapper class could be used to implement Type erasure. Type Erasure is a term for coallescing a strongly typed parameter to a more generic type. Below this is implemented via wrapper type for demonstration purposes.

struct AnyAnimal<Food>: Animal_EV_Proto2 {
    private let _eat: (Food) -> Void
    init<Base: Animal_EV_Proto2>(
        _ animal: Base) where Base.Food == Food {
        _eat = animal.eat
    }
    func eat(food: Food) {
        _eat(food)
    }
}


// In previous versions of Swift we could then box our types. However, Swift now requires Initializer that 'Antelope' conform to 'Animal_EV_Proto2' during initialization.
//let y = AnyAnimal(Antelope())
// let x: MyProto = Foo()
// why?? See gallagher talk - has to do with protocol witness table and way of handlign this.

// instead a good solution is to architect software to avoid running into this issue.
// for example:
enum Food {
    case grass
    case meat
}

protocol Animal_EV_Proto3 {
    func eat(food: Food) -> ()
}

// now the food is represented as an enum this actually allows more flexibility for omnivores. While this example is a bit contrived it is important to think about the overall architecture of the code and not only what fits use case, but also what is supported by the language and frameworks themselves. The nexus of this represents good design.

//: [Next](@next)
