/*:
# iOS App Development At Scale
*Develop and maintain high-quality professional apps at scale*

 Eric Vennaro
*/
//: [Next](@next)

// due to generic type constraint we cannot implement the traditional observer pattern in swift using
//protocol SubscriberProto: AnyObject {
//  func update(_ context: PublisherProto)
//}

// MARK: Base Classes
// Base class for the Subscriber (also called observer)
class SubscriberBase: Equatable {
    static func == (lhs: SubscriberBase, rhs: SubscriberBase) -> Bool {
        lhs.name == rhs.name
    }
    
    var name: String
    var publisher: PublisherBase
    
    init(name: String, publisher: PublisherBase) {
        self.name = name
        self.publisher = publisher
    }
    
    // The subject passed to the Update operation lets the observer
    // determine which subject changed when it observes more than one
    public func update(_ changedPublisher: PublisherBase) {
        // update based on item count
//        updateUIForItemCount(context.itemCount)
        fatalError("must implement in subclass")
    }
}

// Base class for the Publisher (also called subject)
class PublisherBase {
    private var subscribers: [SubscriberBase] = []

    func add(subscriber: SubscriberBase) {
        subscribers.append(subscriber)
    }
    func remove(subscriber: SubscriberBase) {
        guard let i = subscribers.firstIndex(of: subscriber) else { return }
        subscribers.remove(at: i)
    }
    func notify() {
        for s in subscribers {
            s.update(self)
        }
    }
}

// MARK: Concrete Classes
// Item is concrete subscriber for our shopping cart
class Item: SubscriberBase {
    let _publisher: Cart
    
    init(name: String,
        publisher: Cart) {
        _publisher = publisher
        super.init(name: name, publisher: publisher)
    }
    
    override func update(_ changedPublisher: PublisherBase) {
        if (type(of: changedPublisher)  == type(of: _publisher)) {
            print("Updated item count: \(_publisher.itemsCount)")
        } else {
            print("works")
        }
    }
}

// Cart is our concrete publisher or subject
class Cart: PublisherBase {
    var subscribers: [SubscriberBase] = []
    var itemsCount = 0
    
    func updateItemsCount(_ count: Int) {
        itemsCount = count
        notify()
    }
}

var cart = Cart()
var item = Item(name: "item", publisher: cart)

cart.add(subscriber: item)
cart.updateItemsCount(5)

