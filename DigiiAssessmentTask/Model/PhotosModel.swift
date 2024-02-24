

import Foundation

struct Photos: Codable {
    let id, author: String
    let width, height: Int
    let url, download_url: String
}

struct PhotoDetails: Codable {
    let id, author: String
    let width, height: Int
    let url, download_url: String
}
