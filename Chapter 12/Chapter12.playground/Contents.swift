import XCTest
protocol ParserProto {
    func parse(json: String) -> [String: String]?
}
class Parser: ParserProto {
    func parse(json: String) -> [String: String]? {
        if let data = json.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(
                    with: data, options: []
                ) as? [String: String]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
}

class MockParser: ParserProto {
    var parseResult: [String: String]?
    
    func parse(json: String) -> [String: String]? {
        return parseResult
    }
}

protocol UserDefaultsProto {
    func object(forKey defaultName: String) -> Any?
    func set(_ value: Any?, forKey defaultName: String)
}

extension UserDefaults: UserDefaultsProto {}

class MockUserDefaults: UserDefaultsProto {
    var values: [String:Any]?
    
    func object(forKey defaultName: String) -> Any? {
        return values?[defaultName]
    }
    func set(_ value: Any?, forKey defaultName: String) {
        values?[defaultName] = value
    }
}

class WrappedUserSettings {
  func updateSettings(fromJSON json: String) {
      let parser = Parser()
      let defaults = UserDefaults.standard
      guard var newSettings = parser.parse(
        json: json) else { return }
      if let settings = defaults.object(
        forKey: "user_data") as? [String:String] {
          newSettings.merge(settings) {
              (new, _) in new
          }
      }
      defaults.set(newSettings, forKey: "user_data")
  }
}

class WrappedUserSettingsUpdated {
    private let parser: ParserProto
    private let defaults: UserDefaultsProto
    
    init(jsonParser: ParserProto, standard: UserDefaultsProto) {
        self.parser = jsonParser
        self.defaults = standard
    }
    
    func updateSettings(fromJSON json: String) {
        guard var newSettings = parser.parse(
          json: json) else { return }
        if let settings = defaults.object(
          forKey: "user_data") as? [String:String] {
            newSettings.merge(settings) {
                (new, _) in new
            }
        }
        defaults.set(newSettings, forKey: "user_data")
    }
}



class TestRunner: XCTestCase {
    private var userDefaults: MockUserDefaults!
    private var userSettings: WrappedUserSettingsUpdated!
    private var mockParser: MockParser!
    
    // runs the setup methods once before each test method starts
    override func setUp() {
        userDefaults = MockUserDefaults()
        userDefaults.values = [String:Any]()
        mockParser = MockParser()
        userSettings = WrappedUserSettingsUpdated(
            jsonParser: mockParser,
            standard: userDefaults)
        mockParser.parseResult = nil
    }
    
    // Test with the old implementation of the standard UserDefaults
    func testUpdateSettingsOld() {
       let json = "{\"name\": \"steve\"}"
       WrappedUserSettings().updateSettings(fromJSON:json)
       let expected = "steve"
       XCTAssertEqual(
        expected,
        (UserDefaults.standard.object(
            forKey: "user_data") as? [String : String])?["name"],
       "User defaults should contain the updated name")
    }

    // Test with old implementation that only passes since UserDefaults carries over
    // values from the old test
    func testUpdateSettingsOldShouldFail() {
        let json = "{\"email\": \"echo@gmail.com\"}"
        WrappedUserSettings().updateSettings(fromJSON:json)
        let expected =  "steve"
        XCTAssertEqual(
         expected,
         (UserDefaults.standard.object(
             forKey: "user_data") as? [String : String])?["name"],
        "User defaults should contain the updated name")
    }
    
    // Test's with the new setup, we are confident the only key in the dictionary is name
    func testUpdateSettingsNew() {
        mockParser.parseResult = ["name": "jim"]
        let json = "{\"name\": \"jim\"}"
        userSettings.updateSettings(fromJSON:json)
        let expected = ["name": "jim"]
        XCTAssertEqual(
         expected,
         userDefaults.object(
             forKey: "user_data") as? [String : String],
        "User defaults should contain the updated name")
    }

    func testUpdateSettingsFails() {
        let json = "{\"name\": \"steve\"}"
        mockParser.parseResult = ["name": "billy bob"]
        userSettings.updateSettings(fromJSON:json)
        let expected = ["name": "steve"]
        XCTAssertNotEqual(
         expected,
         userDefaults.object(
             forKey: "user_data") as? [String : String],
        "User defaults should contain the updated name")
    }
    
    // we do not have a carry over effect anymore and the result is not equal
    func testUpdateSettingsCarryoverEffect() {
        let json = "{\"name\": \"steve\"}"
        mockParser.parseResult = ["email": "billy bob"]
        userSettings.updateSettings(fromJSON:json)
        let expected = ["name": "steve"]
        XCTAssertNotEqual(
         expected,
         userDefaults.object(
             forKey: "user_data") as? [String : String],
        "User defaults should contain the updated name")
    }
}

TestRunner.defaultTestSuite.run()
