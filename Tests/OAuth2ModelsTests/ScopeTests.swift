import XCTest
import OAuth2Models

final class ScopeTests: XCTestCase {
	func test__equalsOperator__scopesAreEqual__returnsTru() throws {
		let scope1 = try Scope(string: "foo bar baz")
		let scope2 = try Scope(string: "baz foo bar")

		XCTAssertTrue(scope1 == scope2)
	}

	func test__equalsOperator__scopesAreNotEqual__returnsTru() throws {
		let scope1 = try Scope(string: "foo bar baz")
		let scope2 = try Scope(string: "bazfoo bar")

		XCTAssertFalse(scope1 == scope2)
	}

	func test__equalsOperator__oneSideIsArray_contentIsEqual__returnsTrue() throws {
		let array = ["foo", "bar", "baz"]
		let scope = try Scope(string: "foo bar baz")

		XCTAssertTrue(array == scope)
		XCTAssertTrue(scope == array)
	}

	func test__init__hasZeroItems() throws {
		let scope = Scope()

		XCTAssertTrue(scope.isEmpty)
	}

	func test__initWithString__validSingleScope__hasSingleItem() throws {
		let scope = try Scope(string: "foo")

		XCTAssertEqual(1, scope.count)
		XCTAssertEqual(["foo"], Array(scope))
	}

	func test__initWithString__validThreeItemScope__hasThreeItems() throws {
		let scope = try Scope(string: "foo bar baz")

		XCTAssertEqual(3, scope.count)
		// Order need not be guaranteed. The internal data structure is an unordered Set.
		XCTAssertEqual(["foo", "bar", "baz"].sorted(), scope.sorted())
	}

	func test__initWithString__validThreeItemScope_duplicateValues__hasUniqueCasesOnly() throws {
		let scope = try Scope(string: "foo bar foo")

		XCTAssertEqual(2, scope.count)
		// Order need not be guaranteed. The internal data structure is an unordered Set.
		XCTAssertEqual(["foo", "bar"].sorted(), scope.sorted())
	}

	func test__initWithString__validThreeItemScope_differentCase__hasThreeItems() throws {
		let scope = try Scope(string: "foo Foo fOo")

		// Order need not be guaranteed. The internal data structure is an unordered Set.
		XCTAssertEqual(["foo", "Foo", "fOo"].sorted(), scope.sorted())
	}

	func test__initWithString__invalidItem__throws() throws {
		XCTAssertThrowsError(try Scope(string: "å")) { error in
			if case let CharacterSetValidationError.containsInvalidCharacters(invalidChars) = error {
				XCTAssertEqual(invalidChars, "å")
			} else {
				XCTFail("Unexpected error: \(error)")
			}
		}
	}

	func test__initWithString__twoItems_multipleSpaces__hasTwoItems() throws {
		let scope = try Scope(string: " foo  bar ")

		XCTAssertEqual(["foo", "bar"].sorted(), scope.sorted())
	}

	func test__initWithItems__validSingleScope__hasSingleItem() throws {
		let scope = try Scope(items: ["foo"])

		XCTAssertEqual(1, scope.count)
		XCTAssertEqual(["foo"], Array(scope))
	}

	func test__initWithItems__validThreeItemScope__hasThreeItems() throws {
		let scope = try Scope(items: ["foo", "bar", "baz"])

		XCTAssertEqual(3, scope.count)
		// Order need not be guaranteed. The internal data structure is an unordered Set.
		XCTAssertEqual(["foo", "bar", "baz"].sorted(), scope.sorted())
	}

	func test__initWithItems__validThreeItemScope_duplicateValues__hasUniqueCasesOnly() throws {
		let scope = try Scope(items: ["foo", "bar", "foo"])

		XCTAssertEqual(2, scope.count)
		// Order need not be guaranteed. The internal data structure is an unordered Set.
		XCTAssertEqual(["foo", "bar"].sorted(), scope.sorted())
	}

	func test__initWithItems__validThreeItemScope_differentCase__hasThreeItems() throws {
		let scope = try Scope(items: ["foo", "Foo", "fOo"])

		// Order need not be guaranteed. The internal data structure is an unordered Set.
		XCTAssertEqual(["foo", "Foo", "fOo"].sorted(), scope.sorted())
	}

	func test__initWithItems__invalidItem__throws() throws {
		XCTAssertThrowsError(try Scope(items: ["å"])) { error in
			if case let CharacterSetValidationError.containsInvalidCharacters(invalidChars) = error {
				XCTAssertEqual(invalidChars, "å")
			} else {
				XCTFail("Unexpected error: \(error)")
			}
		}
	}

	func test__initWithItems__itemWithSpace__throws() throws {
		XCTAssertThrowsError(try Scope(items: ["abc", " def", "ghi"]))
		XCTAssertThrowsError(try Scope(items: ["abc", "d ef", "ghi"]))
		XCTAssertThrowsError(try Scope(items: ["abc", "def", "ghi "]))
	}

	func test__insert__validItem__insertsItem() throws {
		var scope = try Scope(string: "some scope")
		let result = try scope.insert("foo")

		XCTAssertEqual(result.0, true)
		XCTAssertEqual(result.1, "foo")
		XCTAssertEqual(["some", "scope", "foo"].sorted(), scope.sorted())
	}

	func test__insert__duplicateItem__doesNotInsert_doesNotThrow() throws {
		var scope = try Scope(string: "some scope")
		let result = try scope.insert("some")

		XCTAssertEqual(result.0, false)
		XCTAssertEqual(result.1, "some")
		XCTAssertEqual(["some", "scope"].sorted(), scope.sorted())
	}

	func test__insert__invalidItem__throws() throws {
		var scope = try Scope(string: "some scope")
		XCTAssertThrowsError(try scope.insert("å"))
	}

	func test__insert__itemWithSpace__throws() throws {
		var scope = try Scope(string: "some scope")
		XCTAssertThrowsError(try scope.insert(" foo"))
		XCTAssertThrowsError(try scope.insert("fo o"))
		XCTAssertThrowsError(try scope.insert("foo "))
	}

	func test__contains__string_itemExists__returnsTrue() throws {
		let scope = try Scope(string: "foo bar")

		XCTAssertTrue(scope.contains("foo"))
	}

	func test__contains__string_itemDoesNotExist__returnsFalse() throws {
		let scope = try Scope(string: "foo bar")

		XCTAssertFalse(scope.contains("foO"))
	}

	func test__decodable__jsonValueIsValidString__decodesWithValues() throws {
		let json = "foo bar baz"
		let data = try encode(json)
		let scope = try decode(data) as Scope

		XCTAssertEqual(["foo", "bar", "baz"].sorted(), scope.sorted())
	}

	func test__decodable__jsonValueIsInvalidString__decodesWithValues() throws {
		let json = "foåo bar baåz"
		let data = try encode(json)
		let scope = try decode(data) as Scope

		XCTAssertEqual(["foåo", "bar", "baåz"].sorted(), scope.sorted())
	}

	func test__decodable__jsonValueIsEmptyString__decodesAsEmptyObject() throws {
		let json = ""
		let data = try encode(json)
		let scope = try decode(data) as Scope

		XCTAssertTrue(scope.isEmpty)
	}

	func test__decodable__jsonValueIsStringArray__decodesWithValues() throws {
		let json = ["foo", "bar", "baz"]
		let data = try encode(json)
		let scope = try decode(data) as Scope

		XCTAssertEqual(json.sorted(), scope.sorted())
	}

	func test__decodable__jsonValueIsEmptyArray__decodesAsEmpty() throws {
		let json = "[]"
		let data = json.data(using: .utf8)!
		let scope = try decode(data) as Scope

		XCTAssertTrue(scope.isEmpty)
	}

	func test__decodable__jsonValueIsMixedArray__throws() throws {
		let datas = [
			try encode([1,2,3]),
			try encode([true]),
			#"[{"a": "b"}]"#.data(using: .utf8)!,
			#"[[1]]"#.data(using: .utf8)!,
		]
		for data in datas {
			XCTAssertThrowsError(try decode(data) as Scope)
		}
	}

	func test__decodable__jsonValueIsArrayWithInvalidStrings__returnsScopeWithInvalidKeys() throws {
		let json = ["å"]
		let data = try encode(json)
		let scope = try decode(data) as Scope

		XCTAssertEqual(json, scope.sorted())
	}

	func test__decodable__jsonValueIsArrayWithDuplicates__returnsDedupedItems() throws {
		let json = ["foo", "bar", "foo"]
		let data = try encode(json)
		let scope = try decode(data) as Scope

		XCTAssertEqual(json[0...1].sorted(), scope.sorted())
	}

	func test__decodable__jsonValueIsStringWithDuplicates__returnsDedupedItems() throws {
		let json = "foo bar foo"
		let data = try encode(json)
		let scope = try decode(data) as Scope

		XCTAssertEqual(["foo", "bar"].sorted(), scope.sorted())
	}

	func test__decodable__jsonValueIsNil__decodesAsEmpty() throws {
		let json = "null"
		let data = json.data(using: .utf8)!
		let scope = try decode(data) as Scope

		XCTAssertTrue(scope.isEmpty)
	}

	func test__encodable__scopeWithContent__encodesAsString() throws {
		let scope = try Scope(string: "foo bar baz")
		let data = try encode(scope)
		let json = String(data: data, encoding: .utf8)!

		XCTAssertEqual(json.count, 13)

		let jsonAsArray = json[json.index(after: json.startIndex)..<json.index(before: json.endIndex)].split(separator: " ").map(String.init)
		XCTAssertEqual(jsonAsArray.sorted(), scope.sorted())
	}

	func test__encodable__emptyScope__encodesAsNull() throws {
		let scope = Scope()
		let data = try encode(scope)
		let json = String(data: data, encoding: .utf8)

		XCTAssertEqual("null", json)
	}
}
