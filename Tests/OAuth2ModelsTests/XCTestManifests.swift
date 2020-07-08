import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
	return [
		testCase(OAuth2ModelsTests.allTests),
	]
}
#endif
