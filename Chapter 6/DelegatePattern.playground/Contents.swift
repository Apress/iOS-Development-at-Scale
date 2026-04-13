protocol OracleDelegate: AnyObject {
    func whatIsTheMeaningOfLife() -> String
}

class Oracle {
    weak var delegate: OracleDelegate?
    
    func whatIsTheMeaningOfLife() {
        guard let d = delegate else { return }
        print(d.whatIsTheMeaningOfLife())
    }
}

class HitchhikersGuideToTheGalaxyOracle: OracleDelegate {
    func whatIsTheMeaningOfLife() -> String {
        return "42"
    }
}

let h = HitchhikersGuideToTheGalaxyOracle()
let oracle = Oracle()
oracle.delegate = h
oracle.whatIsTheMeaningOfLife()

class OracleClosure {
    private let meaningOfLife: () -> Void
    
    init(predicate: @escaping () -> Void) {
        self.meaningOfLife = predicate
    }
    
    func whatIsTheMeaningOfLife() {
        meaningOfLife()
    }
}
// playing on nihilist mode
let meaningOfLife = {
    print("there is none")
}
let newOracle = OracleClosure(predicate: meaningOfLife)
newOracle.whatIsTheMeaningOfLife()

