import Foundation

struct CovidData: Codable {
    
    let cases: Int
    let deaths: Int
    let recovered: Int
    let countryInfo: CountryInfo
    
}

struct CountryInfo: Codable {
    
    let flag: String
    
}
