import UIKit

func sumArray(array: [Int], startIndex: Int, endIndex: Int) -> Int {
    var sum = 0
    for index in startIndex ... endIndex {
        sum += array[index]
    }
    return sum
}

func findIndexTest1(array: [Int]) -> String {
    for index in 1 ..< array.count - 1 {
        if sumArray(array: array, startIndex: 0, endIndex: index - 1) == sumArray(array: array, startIndex: index + 1, endIndex: array.count - 1) {
            return "middle index is \(index)"
        }
    }
    return "Index not found"
}

print(findIndexTest1(array: [1, 3, 5, 7, 9]))
print(findIndexTest1(array: [3, 6, 8, 1, 5, 10 ,1, 7]))
print(findIndexTest1(array: [3, 5, 6]))


// =====================================================================================

extension String {

    var length: Int {
        return count
    }

    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}


func checkPalindrome(s: String) -> String {
    let lowerString = String(s.lowercased())
    for index in 0 ..< lowerString.count {
        if lowerString[index] != lowerString[lowerString.count - index - 1] {
            return "\(s) isn't a palindrome"
        }
    }
    return "\(s) is a palindrome"
}

print(checkPalindrome(s: "aka"))
print(checkPalindrome(s: "Level"))
print(checkPalindrome(s: "Hello"))
