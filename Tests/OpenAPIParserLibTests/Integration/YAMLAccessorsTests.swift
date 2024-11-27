import XCTest
@testable import OpenAPIParserLib

final class YAMLAccessorsTests: XCTestCase {

    static var allYAMLs: [String: String] = [
        "Central_Sequence_Service": "TODO: Add YAML content for Central_Sequence_Service",
        "Character_Service": "TODO: Add YAML content for Character_Service",
        "Story_Factory_Service": "TODO: Add YAML content for Story_Factory_Service",
        "Core_Script_Managment_Service": "TODO: Add YAML content for Core_Script_Managment_Service",
        "Paraphrase_Service": "TODO: Add YAML content for Paraphrase_Service",
        "Session_And_Context_Service": "TODO: Add YAML content for Session_And_Context_Service",
        "Performer_Service": "TODO: Add YAML content for Performer_Service",
        "Ensemble_Service": "TODO: Add YAML content for Ensemble_Service",
        "Action_Service": "TODO: Add YAML content for Action_Service",
        "Spoken_Word_Service": "TODO: Add YAML content for Spoken_Word_Service"
    ]

    func test_YAMLsExist() throws {
        for (name, yaml) in YAMLAccessorsTests.allYAMLs {
            XCTAssertFalse(yaml.isEmpty, "YAML for \(name) is empty.")
        }
    }
}