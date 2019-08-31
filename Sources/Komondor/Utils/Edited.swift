import Foundation

let editedRegexString = #"\[edited ([a-z]+)((?:,[a-z]+)*)\]"#

func parseEdited(command: String) -> [String]? {
    let range = NSRange(location: 0, length: command.count)

    guard let regex = try? NSRegularExpression(pattern: editedRegexString) else {
        fatalError("Malformed regex")
    }

    guard let match = regex.firstMatch(in: command, options: [], range: range),
        let firstExtRange = Range(match.range(at: 1), in: command)
    else {
        return nil
    }

    let firstExt = String(command[firstExtRange])
    guard let restExtRange = Range(match.range(at: 2), in: command) else {
        return [firstExt]
    }

    let restExt = command[restExtRange]
    var extList = restExt.components(separatedBy: ",")
    // extList[0] will be "" since there is was a leading comma
    // replace it will the first extension
    extList[0] = firstExt

    return extList
}
