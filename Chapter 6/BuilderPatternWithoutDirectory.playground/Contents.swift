enum Theme: String {
    case `default`, darkMode, monopoly
}

struct MonopolyGame {
    var maxNumPlayers: Int = 0
    var theme: Theme = .default
    var startingBalance: Double = 200
    
    func printObj() {
        print("maxNumPlayers: \(maxNumPlayers), " +
              "theme: \(theme), " +
              "startingBalance: \(startingBalance)")
    }
}

class MonopolyGameBuilder {
    private var maxNumPlayers: Int = 0
    // separate enum not documented here that contains
    // UI theme information
    private var theme: Theme = .default
    private var startingBalance: Double = 200

    func set(maxNumPlayers: Int) -> Self {
        self.maxNumPlayers = maxNumPlayers
        return self
    }

    func set(theme: Theme) -> Self {
        self.theme = theme
        return self
    }

    func set(startingBalance: Double) -> Self {
        self.startingBalance = startingBalance
        return self
    }

    func reset() {
        // reset builder values
    }

    func build() -> MonopolyGame {
        return MonopolyGame(
            maxNumPlayers:maxNumPlayers,
            theme: theme,
            startingBalance: startingBalance
        );
    }
}

let monopolyGame = MonopolyGameBuilder()
    .set(maxNumPlayers: 10)
    .set(theme: Theme.default)
    .set(startingBalance: 100)
    .build()

monopolyGame.printObj()
// maxNumPlayers: 10, theme: default, startingBalance: 100.0

