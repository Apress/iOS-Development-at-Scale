enum Theme: String {
    case `default`, darkMode, monopoly
}
// Monopoly does not share a common protocol with other games
struct MonopolyGame {
    let maxNumPlayers: Int
    // separate enum not documented here that contains
    // UI theme information
    let theme: Theme
    let startingBalance: Double
    
    init(maxNumPlayers: Int,
         theme: Theme,
         startingBalance: Double) {
        self.maxNumPlayers = maxNumPlayers
        self.theme = theme
        self.startingBalance = startingBalance
    }
    
    func printObj() {
        print("maxNumPlayers: \(maxNumPlayers), " +
              "theme: \(theme), " +
              "startingBalance: \(startingBalance)")
    }
}
 
protocol MonopolyGameBuilderProto {
    func setTheme(_ theme: Theme)
    func setStartingBalance(_ startingBalance: Double)
    func setMaxNumPlayers(_ maxNumPlayers: Int)
    func reset()
    func build() -> MonopolyGame
}
 
class MonopolyGameBuilder: MonopolyGameBuilderProto {
    public private(set) var maxNumPlayers: Int = 0
    public private(set) var theme: Theme = .default
    public private(set) var startingBalance: Double = 200

    func setTheme(_ theme: Theme) {
        self.theme = theme
    }

    func setStartingBalance(_ startingBalance: Double) {
        self.startingBalance = startingBalance
    }
  
    func setMaxNumPlayers(_ maxNumPlayers: Int) {
        self.maxNumPlayers = maxNumPlayers
    }

    func reset() {
        self.theme = .default
        self.maxNumPlayers = 0
        self.startingBalance = 200
    }

    func build() -> MonopolyGame {
        return MonopolyGame(
            maxNumPlayers:maxNumPlayers,
            theme: theme,
            startingBalance: startingBalance
        );
    }
}


// The director which is responsible for executing the building steps in sequence.
class MonopolyGameDirector {
    let builder: MonopolyGameBuilderProto
    init(builder: MonopolyGameBuilderProto) {
        self.builder = builder
    }
    func buildStandardMonopolyGame() {
        // separate enum not documented here that contains UI theme information
        builder.reset()
        builder.setTheme(.monopoly)
        builder.setStartingBalance(200)
        builder.setMaxNumPlayers(8)
    }

    // the director allows for the building of product variations such as the expansion pack
}

// client code creates the builder object, passes it to the director and initiates the construction process.
class GameManager {
    func makeMonopolyGame() {
        let monopolyBuilder = MonopolyGameBuilder();
        let gameBuilder = MonopolyGameDirector(
            builder: monopolyBuilder);
        

        gameBuilder.buildStandardMonopolyGame();
        // Here final object is retrieved from the builder
        // object directly since the director isn't aware of and not
        // dependent on concrete builders and products.
        let game = monopolyBuilder.build()
        game.printObj()
    }
}
GameManager().makeMonopolyGame()
// maxNumPlayers: 8, theme: monopoly, startingBalance: 200.0

