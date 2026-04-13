class Printer {
    static let shared: Printer = {
        let instance = Printer()
        // setup code
        return instance
    }()
    
    func printAssignment(text: String) {
        print(text)
    }
}

let printer = Printer.shared
printer.printAssignment(text: "assignment")



