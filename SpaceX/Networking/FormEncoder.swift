import Foundation
class FormEncoder {
    func encode(_ dictionary: [String: String]) -> Data? {
        var allowedChars = CharacterSet.urlPathAllowed
        allowedChars.remove(charactersIn: "&=+")

        let string = dictionary.keys.sorted().compactMap { key in
            guard let eKey = key.addingPercentEncoding(withAllowedCharacters: allowedChars),
                  let val = dictionary[key]?.addingPercentEncoding(withAllowedCharacters: allowedChars) else {
                return nil
            }

            return "\(eKey)=\(val)"
        }.joined(separator: "&")

        return string.data(using: .utf8)
    }
}
