// import foundation for usage with NSDate
import Foundation

// Chapter 1: Structures and Classes

// - MARK: Structures and Classes
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

let dog = Dog(name: "Steve",
              breed: .germanShepard,
              lastFed: nil)
dog.bark()

/*
Lets walk through a brief example using our `Dog` class above, but first lets create `DogStruct` so we can reason about value semantics as well.
*/

struct DogStruct {
   var name: String
   var breed: DogBreed
   var lastFed: Date?
}

/*
 Now that we have our dog struct we can compare modifying a reference type to a value type. In both cases we set our variable and then try to change it via a copy.
 */

var dogClass = Dog(name: "Esparanza", breed: .bizon, lastFed: nil)
var refDog = dogClass
refDog.name = "hope"
// False - we have a reference type
print(dogClass.name != refDog.name ? "True - we have a value type" : "False - we have a reference type")

var dogStruct = DogStruct(name: "Esparanza", breed: .bizon, lastFed: nil)
var valDog = dogStruct
valDog.name = "hope"
// True - we have a value type
print(dogStruct.name != valDog.name ?
      "True - we have a value type" :
        "False - we have a reference type")

/*
As you can see from the above code sample the class represents reference semantics and we are able to change the dogs name for the initlal variable. However, with the struct we were not.  From this example it is clear that value types ensure a level of protection from unintended mutation, which is especially helpful in ensuring thread safety. This is not completely safe because a reference type could be added inside a value type. For example, adding mutable class instances to an array (a value type).
 */
var dog1 = Dog(name: "Esparanza", breed: .bizon, lastFed: nil)
var dog2 = Dog(name: "Bella", breed: .germanShepard, lastFed: nil)
let arr = [dog1, dog2]
var dTemp = arr[0]
// Esparanzabadvalue!
arr[0].name.append("badvalue!")
print(dTemp.name)

/*
 Swift has some additional complexities in how values/objects express their typing. This is typically refered to as value and reference semantics. An example of this is using the `let` keyword. Using the `let` keyword we can get a reference type to express a bit of value semantics.
 */
let dog4 = Dog(name: "Esparanza", breed: .bizon, lastFed: nil)
dog4.name = "test"
let dog5 = dog4
dog4.name = "Max"
print("Dog4: \(dog4.name) Dog5: \(dog5.name)")
// dog4 = dog5 - error cannot assign to a let constant

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

//  Lets review our previous example, but this time with protocols.

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

// - MARK: Generics In Action

func swap<T>(_ a: inout T, _ b: inout T) {
  let temp = a
  a = b
  b = temp
}
//call the function as normal
var x = 0;
var y = 5;
swap(&x, &y)

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
