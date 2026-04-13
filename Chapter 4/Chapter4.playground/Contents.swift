import Foundation
import UIKit
let current = Thread.current
print("current thread", current, current.stackSize)

let newThread = Thread()
newThread.name = "secondary"
print("second thread with default size",newThread, newThread.stackSize)

let newThreadTwo = Thread()
newThreadTwo.name = "tertiary"
// stack size must be a multiple of 4kb
newThreadTwo.stackSize = 4096 * 512
print("third thread", newThreadTwo, newThreadTwo.stackSize)


class ThreadTest {
    func createThread() {
        let thread = Thread(target: self, selector: #selector(print), object: nil)
        thread.start()
    }
    @objc func print() {
        Swift.print("Thread running")
    }
}

actor Bank {
    let name: String
    var balance: Int
    
    init(name: String, balance: Int) {
        self.name = name
        self.balance = balance
    }
    
    func withdraw(value: Int) {
        print("\(self.name): checking balance")
            if self.balance > value {
            print("\(self.name): Processing withdrawal")
            // sleeping for some random time, simulating a long process
            Thread.sleep(
                forTimeInterval: Double.random(in: 0...2))
                self.balance -= value
            print("\(self.name): Done: \(value) withdrawn")
                print("\(self.name): Current balance: \(self.balance)")
        } else {
            print("\(self.name): Insufficient balanceeee")
        }
    }
    
    func getBalance() -> Int {
        return balance
    }
}

class ProgramDriver {
    let bank = Bank(name: "PNC", balance: 1200)
    
    func executeTransactions() async {
        let thread = Thread(target: self,
                            selector: #selector(t1),
                            object: nil)
        let thread2 = Thread(target: self,
                             selector: #selector(t2),
                             object: nil)
        thread.start()
        thread2.start()
    }
    
    @objc func t1() {
        Task.detached {
            await self.bank.withdraw(value: 1000)
        }
    }
    
    @objc func t2() {
        Task.detached {
            await self.bank.withdraw(value: 400)
        }
    }
}

// uncomment to run
//Task{
//    await ProgramDriver().executeTransactions()
//}



class Counter {
    var count = 0
    func increment() {
        count += 1
    }
    func getCount()-> Int { return count }
}
let counter = Counter()
class Counting {

    func execute() {
        let thread = Thread(target: self,
                            selector: #selector(countingThreads),
                            object: nil)
        let thread2 = Thread(target: self,
                            selector: #selector(countingThreads),
                            object: nil)
        thread.start()
        thread2.start()

    }
    @objc func countingThreads() {
        for _ in 1...10000 {
            counter.increment()
        }
    }
}

// uncomment to run
//Counting().execute()
//sleep(1)
//print(counter.getCount())

import Dispatch
struct Philosophers {
    let left: DispatchSemaphore
    let right: DispatchSemaphore

    var leftIndex = -1
    var rightIndex = -1

    init(left: DispatchSemaphore, right: DispatchSemaphore) {
        self.left = left
        self.right = right
    }

    func run() {
        while true {
            left.wait()
            right.wait()
            print("Start Eating Philosopher")
            sleep(100)
            print("Releasing lock for Philosopher")
            left.signal()
            right.signal()
        }
    }
}
