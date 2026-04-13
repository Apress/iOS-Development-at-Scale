protocol LoggerService {
  var id: String { get }
}

// MARK: Factory Method
class ThirdPartyLogger: LoggerService {
    var id: String = "ThirdParty"
  // implement class methods ...

  // factory method
  public static func create() -> LoggerService {
    return ThirdPartyLogger()
  }
}

class InHouseLogger: LoggerService {
    var id: String = "InHouse"
  // implement class methods ...

  // factory method
  public static func create() -> LoggerService {
    return InHouseLogger()
  }
}

// MARK: Abstract Factory

protocol LoggerFactory {
  func create() -> LoggerService
}

class InHouseLoggerFactory: LoggerFactory {
  func create() -> LoggerService {
    return InHouseLogger()
  }
}

class ThirdPartyLoggerFactory: LoggerFactory {
  func create() -> LoggerService {
    return ThirdPartyLogger()
  }
}

// abstract factory
class AppLoggerFactory: LoggerFactory {

  enum Logger {
    case thirdParty
    case inHouse
  }

  var logger: Logger

  init(logger: Logger) {
    self.logger = logger
  }

  func create() -> LoggerService {
    switch self.logger {
      case .thirdParty:
        return ThirdPartyLoggerFactory().create()
        case .inHouse:
        return InHouseLoggerFactory().create()
    }
  }
}

let factory = AppLoggerFactory(logger: .thirdParty)
let service = factory.create()
print(service.id)
// ThirdParty
