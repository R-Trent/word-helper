//
//  String+Subscript.swift
//  WordleHelper
//
//  Created by Ryan Trent on 7/21/22.
//

extension String {
  subscript(_ i: Int) -> String {
      if i > self.count {
          return ""
      }
    let idx1 = index(startIndex, offsetBy: i)
    let idx2 = index(idx1, offsetBy: 1)
    return String(self[idx1..<idx2])
  }

  subscript (r: Range<Int>) -> String {
      if r.upperBound > self.count || r.lowerBound > self.count {
          return ""
      }
    let start = index(startIndex, offsetBy: r.lowerBound)
    let end = index(startIndex, offsetBy: r.upperBound)
    return String(self[start ..< end])
  }

  subscript (r: CountableClosedRange<Int>) -> String {
      if r.upperBound > self.count || r.lowerBound > self.count {
          return ""
      }
    let startIndex =  self.index(self.startIndex, offsetBy: r.lowerBound)
    let endIndex = self.index(startIndex, offsetBy: r.upperBound - r.lowerBound)
    return String(self[startIndex...endIndex])
  }
    func numberOfOccurrencesOf(string: String) -> Int {
            return self.components(separatedBy:string).count - 1
        }
}
