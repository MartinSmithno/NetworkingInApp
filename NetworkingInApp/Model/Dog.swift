import UIKit

struct Dog: Codable {
    let message: String
    let status: String
}

struct Breeds: Codable {
    let message: [String:[String]]
    let status: String
}
