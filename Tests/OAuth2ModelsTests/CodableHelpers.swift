import Foundation

func decode<T:Decodable>(_ data: Data) throws -> T {
	let decoder = JSONDecoder()
	return try decoder.decode(T.self, from: data)
}

func encode<T:RawRepresentable>(_ data: [T:String]) throws -> Data where T.RawValue == String {
	var codableData = [String:String]()
	for (k, v) in data {
		codableData[k.rawValue] = v
	}
	return try encode(codableData)
}
func encode<T: Encodable>(_ data: T) throws -> Data {
	let encoder = JSONEncoder()
	let json = try encoder.encode(data)
	return json
}
