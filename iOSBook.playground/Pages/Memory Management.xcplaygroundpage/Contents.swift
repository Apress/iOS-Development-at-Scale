//: [Previous](@previous)
/*:
 # Chapter 2 - Memory Management
 ## Overview
 
 Understanding memory management is is key to developing programs that perform both correctly and efficiently. This section will dive into how computer memory is allocated and released for Swift programs, the Swift memory model, and understanding proper memory management.
 
 The overall quality of an application is largely judged by its performance and reliability which is highly correlated with proper memory management and the overall management of system resources. This becomes especially important at a large scale multi-national applications where older devices are prevelant.
 
 ## Program Memory Usage
 
 As a first step into memory management lets look at the different components of system memory and how a program allocates memory. Programs manage their memory by partitioning it into different units that perform specific tasks. Two important units are the stack and the heap, which manage the program's unused memory and allocate it for different kinds of data or variables. When the program no longer needs the memory, it may deallocate it. Deallocated memory is returned to its source, either the stack or the heap, and is made available for reuse.

 ![Memory Layout](MemoryLayout.png)
 
 ### Stack
 
 At its core a stack is a simple last-in, first-out (LIFO) data structure. Stacks must support at least two operations: push and pop. Inserting or removing from the middle of a stack is not allowed. The data items pushed on the runtime stack may be any convenient size. Nevertheless, stacks are somewhat rigid in that they only allow access at the top. But this rigidity also makes stacks easy to implement and makes the push and pop operations efficient.
 
 In practice this means that when a function is called, all local instances in that function are pushed on to the current stack. And once the function has returned, all instances are removed from the stack.
 
 *Characteristics of stack memory:*
     * Static in memory and allocation happens only during compile time.
     * Stack is LIFO(Last in first out) data structure
     * Fast access through push and pop operations
     * The stack does not allow objects that change in size.
     * Each thread has its own stack
     * Stacks store value types, such as structs and enums.
     * Tracks memory allocation via a stack pointer, decrement the stack pointer to allocate and increment the stack pointer to deallocate

 ![Stack Layout](StackLayout.png)
 
 ### Heap
 
 In contrast, the heap is more flexible than the stack. Whereas the stack only allows allocation and deallocation at the top, programs can allocate or deallocate memory anywhere in a heap. The heap allocates memory by finding and returning the first memory block large enough to satisfy the request. Memory is returned or freed in any order. When the program deallocates or releases two adjacent memory blocks, the heap merges them to form a single block. Doing this allows the heap to better meet future demands for large blocks of memory.
 This is in sharp contrast to the stack were the program must return memory in the opposite order of its allocation.
 
 One caveate is that the memory allocated to the program from the heap must form a contiguous block large enough to satisfy the request with a single chunk of memory. This restriction increases the complexity of a heap because the code carrying out the allocation operation must scan the heap until it finds a contiguous block of memory that is large enough to satisfy the request. Moreover, when memory is returned to the heap, adjacent freed blocks must be coalesced to better accommodate future requests for large blocks of memory. The heap's increased complexity means that managing memory with a heap is slower than with a stack.
 
 *Characteristics of heap memory:*
    * Dynamic in memory and allocation happens during runtime.
    * Values can be referenced at any time through a memory address.
    * No limit on memory size
    * Slower access
    * When the process requests a certain amount of memory, the heap will search for a memory address that fulfils this request and return it to the process.
    * When the memory is not being used anymore, the process must tell the heap to free that section of memory.
    *  The heap is shared with everybody requiring thread safety which further increases the complexity of allocation.
    * Dynamic object creation requires the need for memory management since objects created on the heap never go out of scope.
 
 ![Heap Layout](HeapLayout.png)
 
 ## Swift Memory Model
 
 Now that we've looked at a general overview of the stack and the heap and how they help manage your programs memory we are ready to look at some Swift specifics.
 
 ### Swift Stack Allocation
 
 As a general rule of thumb Swift value types are stored on the Stack meaning that they won't increase the programs retain count (more about this in the next section). One caveate to this is if the size of your value type cannot be determined at compile time. Typically this is because the type contains a reference type (or is contained by a reference type) and will cause the valu to be allocated on the heap.
 
 > Value type doesn’t increases retain count. But If your value type contains inner references, copying it will require increasing the reference count of it’s children instead.
 
 ![Stack Allocation](StackAllocationSwift.png)

 ### Swift Heap Allocation
 
 If the size of your value type cannot be determined during compile time (because of a protocol/generic requirement), or if your value type recursively contains / is contained by a reference type (remember that closures are also reference types), then it will require heap allocation.
 
 > Strings store their characters on the heap, if your struct (stack storage) contains a string that means the string will still incur reference counting overhead and heap storage.
 
 ![Heap Allocation](HeapAllocationSwift.png)
 
 ## Automatic Reference Counting
  
 Automatic reference counting is a form of automated memory management where the compiler automatically inserts the necessary retain and release operations for the program and deallocates memory when the retain count reaches zero. In Swift a retain count is impemented every time a strong reference is made to an instance. ARC exposes the following lifetime qualifiers to help developers manage memory properly they are:
 1. Strong. Any property labeled strong will increment a reference count. As long as something has a reference to a strong object it will not be deallocated.
 2. Weak. Any property labeled weak will not increment the reference count and do not protect the object from being deallocated.
 3. Unowned. Similar to a weak reference unowned references do not increase the retain count of the object being referred. However, in Swift, an unowned reference is not an Optional. Aditionally, unowned references are non-zeroing. This means that when the object is deallocated, it does not zero out the pointer potentially leading to a dangling pointer.
 
 > ARC only frees up memory for objects when there are zero strong references to them.
 
 Having a form of memory management such as ARC is important for managing objects created dynamically by the program. Without ARC programmers would be forced to perform memory management manually which can lead to errors. In general, Poor memory management can lead to:
 1. Memory Leaks: Memory leaks occur when memory isn't freed, but there is no longer a pointer to it resulting in no way to access (or free it) now. This can cause crashes for long running processes and generally degrade your programs efficiency.
 2. Dangling Pointers: A dangling pointer is when a pointer points to memory that has already been freed (meaning the storage is no longer allocated). Trying to access it might cause undefined behavior and or a segmentation fault.
 
 > Both memory leaks and dangling pointers lead to app crashes and poor user experiences.
 
 ### Reference Counting In Action

 Here is an example of ARC where we reference and assign it to another variable thus incrementing the reference count.
 */
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

/*:
 ![Strong Reference Cycle](StrongReferenceCycle.png)
 
 As you can see ARC still maintains a reference for the car and the engine, niether is deallocated even after assigning each variable to `nil`.
 
 ![Strong Reference Cycle Dealloc](StrongReferenceCycleDealloc.png)
 
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
/*:
 Pretty cool right? Now we can avoid memory leaks, however, we could slightly improve this. Since we know a car must always have an engine we could also set the property  an `unowned` reference. This will remove the need to unwrap the optional and mirrors our hypothetical product requirement of a car always having an engine.
 
 ![Weak Reference Cycle](WeakReference.png)
 */
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
/*:
  A very common scenario to see a retain cycle is when implementing the delegate pattern such as
 ```
 class ViewController: ViewModelDelegate {
     let model = ViewModel()
     init() {
         model.delegate = self
     }

     func willLoadData() {
         // do something
     }
 }
 
 protocol ViewModelDelegate {
     func willLoadData()
 }

 class ViewModel: ViewModelType {
     // if this is a not labeled weak it will lead to a retain cycle
     weak var delegate: ViewModelDelegate?

     func bootstrap() {
         delegate?.willLoadData()
     }
 }
 
 ```
 Another common usecase for this is within capture lists for closures. These function the same way a the above examples
 
 ```
 let closure = { [weak self] in
     self?.doSomething() //Remember, all weak variables are Optionals
 }
 //Look at that sweet, sweet Array of capture values.
 let closure = { [weak self, unowned Person] in
     self?.doSomething() //weak variables are Optionals
     person.eat() //unowned variables are not.
 }
 ```
 
 ### ARC Observed Lifetime bugs
 
 In Swift it is possible to observe these object lifecycles, in fact we did this throughout the above code. In practice, this is widely considered a bad practice because relying on observed object lifetime relies on the swift compliler, if the compiler changes then the observed lifecycle may change causing complex bugs.
 
 #### Some potential solutions
 
 1. Use the extended lifetime modifier. This can extend the scope of weak references, however, you would need to sprinkle this across the code base (increasing maintenance) and puts the additional burdent of correctness and maintenance on individual engineers and code reviewers.
 2. Think critically about the API design and encapsulating logic to avoid unintended access. This amy not work in all circumstances.
 2. Think critically when weak and unknowned are used, do we need this? Can we redesignthe class to avoid any potential of a reference cycle and or deinitializer side effects. This could compoletely eliminate the class of bugs, but may not be possible depending on the code.
 
 None of these are a silver bullet, but when reviewing code, writing code, and bugfixing it is important to think thorugh these tradeoffs and thorughly understand ARC so that code is well written, designed and bug free.
 
 ## Method Dispatch
 
 The last area of the Swift memory model we will touch on here is method dispatch. Swift needs to execute the correct method implementation when called at runtime, this is generally refered to as method dispatching. The way that the programming language, Swift, assertains the correct method to call occurs at either comple time (statically), or at runtime(dynamically). Objective-C heavily utilized the runtime dispatch which gave the language immense flexibility, however, Swift leans heavily on static dispatch which allows the compiler to optimize the code. With runtime dispatch dispatches cannot be determined at compile time and must be looked up at runtime blocking compile time visibility and optimizations.
 
  > Inlining is when during compilation the dispatch is replaced with the actual implementation of the function, removing the overhead of static dispatch and associated setup and tear down of the callstack. This is more of a performance enhancement when an entire chain of dispatches can be inlined.
 
 ### Direct Static Dispatch
 
 This type of method dispatch is simplistic and fast. The reason for its speed is because it impies that there is only one implementation of this method that will be stored somewhere in memory during runtime. The runtime can directly jump to that memory address and execute it. In this form static dispatch does not support polymorphism.
 
 TODO: Add simple static dispatch diagram
 
 ### Dynamic Dispatch
 
 As mentioned above, dynamic dispatch provides a great deal of flexibility. It provides polymorphism and inhertiance for reference types and is implemented via a v-table lookup. Essentially a lookup table is created at compile time during SIL (Swift Intermediate Language) generation which specifies the actual implementation of the method that needs to be called at runtime. During runtime this lookup table is held as an array of addresses to the actual location in memory where the implementation resides (virtual pointer). V-Tables help inherited classes generate the correct calls to overrident and non-overriden methods. Swift also provides an optimization to remove the dynamic dispatch for classes if it is marked as `final` and statically dispatch those methods.
 
 To better understand V-Tables it is helpful to visualize what is going on. For the diagram below we have an array of `Animal` objects, the array has no specific type information; they each point to an object of type `Animal` dog, cat, tiger all fit into this category because they are derived from `Animal` (and thus have the same interface, and can respond to the same messages), so their addresses can also be placed into the array. However, the compiler doesn’t know that they are anything more than `Animal` objects.

 TODO: Add V-Table dynamic dispatch diagram
 
 If the sub-classes of animal override a function declared on the base class the compiler creates a unique V-Table for that class, seen on the right of the diagram. In that table it places the addresses of all the functions that are declared in this class or in the base class. If a function is overriden, the compiler uses the address of the base-class version in the derived class. (You can see this in the adjust entry in the tiger V-Table.)  Then the compilerplaces the virtual pointer (vptr) in the class. Once the vptr is initialized to the proper V-Table, the object in effect “knows” what type it is.
 
 In practice, when the function is called through the base class address (our `Animal` array) the compiler generates a lookup through the type to the virtual method table which contains the virtual pointer to proper method implementation.
 
 ### Supporting Polymorphism For Value Types
 
 As stated earlier static dispatch in its symplistic sense does not support polymorphism and value types utilize static dispatch, so how do value types support polymorphism in Swift? We cannot use V-Table dispatch due to the lack of a common inheritance chain so a Protocol Witness Table (PWT) is used. Protocol variables and lookup are optimized to use value semantics and avoid heap allocation (copy-on-write optimization) where possible. This allows for faster code while still getting the power of dynamic dispatch through the PWT. The mechanism to support this relationship is more complex and the V-Table lookup mainly due to value types having different memory sizes. This section breaks donw the varius components that make this work. We will cover the:
 1. Protocol Witness Table - Similar to a V-Table
 2. Existential Container - Wraps different protocol types to allow for array based storage
 3. Inline Value Buffer - Allows for storage of larger types
 4. Value Witness Table - Handles a values lifecycle
 
 > Being able to use protocols for polymorphic relationships can improve your performance as some compiler optimizations are made.
 
 #### The Existential Container
 The Existential Container solves the problem of how to store protocol value types in an array since the different types have different memory layouts. The existential container does this by "boxing values of protocol types". The local existential table contains:
 1. Inline Value Buffer
 2. Pointer to the Value Witness Table
 3. Pointer to the Protocol Witness Table
 
 ![Existential Container](ExistentialContainer.png)
 
 #### Inline Value Buffer
 
 Three words are value buffer, if type is too large the exestential container will point to the value in memory where the large value is stored on the heap
 
 ![Existential Container With Large Type](ExistentialContainerWithLargeReference.png)
 
 #### Value Witness Table (VWT)
 
 Value Witness Table manages the lifetime of a value type. It handles allocation, copy, destruct and deallocate for a value.  There is one VWT per type in the program and this is linked to the exestential container.

 #### Protocol Witness Table (PWT)
 
 Lastly the existential container includes a reference to the PWT. For each type that implements a protocol a separate protocol witness table is created. Each entry in the table links to the implementation in the type. This essentially wraps the protocol types for storage in an array to enable dynamic dispatch.
 
 Now lets walk through an example of this in practice.
 
 ![Combined Method Dispatch](CombiningProtocolDispatch.png)
 
 In the above diagram VWT table tracks the allocation of the value types and tracks the pointer to the existential container. When allocate is called on the type the VWT will allocate memory one the heap and store pointer to that memory in the value buffer of the existential container.

 Next the copy function is called to copy the value from the source of the assignment (where the local variable was initialized) to the existential container’s value buffer. Note that since the type is large it is not stored directly in the value buffer.

 When deallocate is called the VWT will call the destruct entry to decrement any reference counts if they exist. Lastly deallocate is called which deallocates the memory on the heap for the value. If any references exist deallocate will also remove any references in the existential container.
 
 ### Handling Nested Reference Types
 
 In some cases a value type may contain a reference type in this situation the references will still utilize the value buffer. This can lead to unintended sharing of state if a copy of the value type is created since the underlying reference will stay the same (just increasing the reference count). To avoid this Swift implements copy-on-write (before write to the class we check the reference count if >1 we copy the instance and then write to the copy).
 
 ![Nested Reference](NestedReferenceType.png)

 Pseudocode for copy-on-write
 ```
 class CatStorage {
   // implement all attributes of an Animal
 }
 
 struct Cat: Animal {
   var storage: CatStorage
   init() {
     storage = AnimalSotrage()
   }
   // implement any functions
   mutating func move() {
     // check reference count >= 1
     if !uniquelyReferenced(&storage) {
       storage = CatStorage(storage)
     }
   }
 ```
 
 By implementing this optimization the heap storage needs are decreased by using indirect storage.
 
 ### Handling Generics
 
 Generics in Swift are a form of static parametric poymorphism and Swift Generics leverages this to further optimize code at compile time. Swift will create a type specific version of the generic function for each type used in code. This allows for compiler optimization by inlining the method calls (and further substitutions along the callstack), only creating specific functions for types used in code and whole module optimization. In practice, this means that using generic types (where applicable) and allow for additional performance enhancements as well code architecture improvements.
 
 > The Whole Module Optimization removes this limit for Swift code allowing the optimizer to analyze across all the source files in a module.
 
 ### The Implications Of Different Sized Types On PWT Memory Management
 
 #### Small Types
 For both Protocol Types and Generic Types:
 1. Small types will fit in the value buffer (avoiding heap allocation).
 2. Incur a reference counting overhead only if the type is a class (reference type).
 3. Utilize the Protocol Witness Table for dynamic dispatch.
  
 #### Large Types
 For both Protocol Types and Generic Types:
 1. Large types will still incur heap allocation (use indirect storag as a workaround for value types).
 2. Incur a reference counting overhead only if the value contains reference types
 3. Utilize the Protocol Witness Table for dynamic dispatch.
 
## Applied Memory Management
 
 Choosing a fitting memory abstraction with the least dynamic runtime requirements by leveraging value types will enable static type checking, additional compiler optimizations, and less sharing of state. One example of providing a better fitting memory abstraction is to replace a String type to value type UID which would avoid heap allocation providing better performance and type safety.
 
 More broadly, when evaluating design decisions consider what we've discussed:
 1. Stack vs Heap Allocation:
     1. Is heap storage opening the program to unintended sharing?
     2. Is unecessary heap allocation causing a performance overhead?
 2. Dynamic verses static dispatch:
     1. Is too much dynamic dispatch not allowing the program to take advantage of compiler optimizations associated with static dispatching?
 3. Reference counting overhead?
     1. Are reference types causing a lot of reference counting calls? Can these be modified to use value types?
 
 ### Bug Fixing
 
 A lot times you will not only be tasked with writing quality code, but also fixing bugs. Especially as a mobile engineer a portion of these bugs will be related to mismanaged memory. For debugging these issues it is important to understand them and what tools XCode and the iOS ecosystem provide to help fix them.
 1. Instruments - don't forget to profile on device, the runtime architeture of the simulator is different and may not be helpful when debugging.
 2. Memory graph - excellent tool to look through features 

 ## Conclusion
 
 This chapter walked through the Swift memory model, how automatic reference counting works, and how to avoid common memory management pitfalls. While most of this chapter was more theoretical in discussing how things work this is applicable to day to day software engineering as it:
 1. Improvings debugging - understanding how Swift functions will help debugging issues and understanding stack traces.
 2. Improves feature architecture: knowledge for feature development and fitting the best memory architecture helps develop performant features as well as narrow the design space. This generally assists in *building things right* the first time which in turn speeds up longterm development
 3. Depending on your specific team this may directly impact your work as performance reliability engineer or potentially on a lower level client team working on something like a modular plugin system or compiler optimizations.
 */

//: [Next](@next)
