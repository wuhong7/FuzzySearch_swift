//
//  WHSortString.swift
//  FuzzySearch_swift
//
//  Created by 盖特 on 2017/5/19.
//  Copyright © 2017年 盖特. All rights reserved.
//

import UIKit

class WHSortString: NSObject {
 
    ///大写首字母
    var initial = ""
    ///最原始的字符串
    var string = ""
    ///转化得到的大写英文字符串
    var englishString = ""
    ///model类型
    var model : NSObject?
    

    
    class func sortForStringAry(ary : [String]) -> [String]{
        
        let sortAry = NSMutableArray.init(array: ary)
        let descriptor = NSSortDescriptor(key: nil, ascending: true)
        let descriptorAry = [descriptor]
        sortAry.sort(using: descriptorAry)
        
        //将 # 数据放到末尾
        var removeAry = [String]()
        for str in sortAry {
            
            if let str = str as? String,str == "#" {
                removeAry.append(str)
                break
            }

        }
        
        sortAry.removeObjects(in: removeAry)
        sortAry.addObjects(from: removeAry)
        
        return sortAry as! [String]
        
        
        
    }
    
    
    class func sortAndGroupForArray(ary:[Any],PropertyName:String) -> [String : [Any]]{
    
        var sortDic = [String : [Any]]()
        var sortAry = [WHSortString]()
        var objAry = [WHSortString]()
        var type : String?
        
        if ary.count <= 0 {
            
            return sortDic
        }
        //FIXME:需要注意
        let objc = ary.first as! NSObject
        
        if objc is String {
            type = "string"
            for str:String in ary as! [String]{
               
                let sortString = WHSortString()
                sortString.string = str
                objAry.append(sortString)
            }
        }
        
        
        sortAry = sortAsInitialWithArray(ary: objAry)
        
        var item = [Any]()
        var itemString : String?
        for sort in sortAry {
            
            //首字母不同则item重新初始化，相同则共用一个item
            if itemString != sort.initial {
                itemString = sort.initial
                item = [WHSortString]()
                if type == "string" {
                    item.append(sort.string)
                }else if type == "model" {
                    item.append(sort.model!)
                }else{
                    item.append(sort.string)
                }
                sortDic[itemString!] = item
            }else{
            //item已添加到 regularAry，所以item数据改变时，对应regularAry中也会改变
                if type == "string" {
                    item.append(sort.string)
                }else if type == "model" {
                    item.append(sort.model!)
                }else{
                    item.append(sort.string)
                }
                sortDic[itemString!] = item
            }
        }
        
        return sortDic;

    }
    
}

extension WHSortString{
    
    /**
     *  将数组按首字母排序
     */
    class func sortAsInitialWithArray(ary:[WHSortString]) -> [WHSortString]{
        
        //存储包含首字母和字符串的对象
        var objectAry = [WHSortString]()
        
        //遍历的同时把首字符和对应的字符串存入到srotString对象属性中
        for (_,item) in ary.enumerated() {
            
            item.englishString = transform(chinese: item.string)
            
            //判断首字符是否为字母
            let regex = "[A-Za-z]+"
            let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
            //得到字符串的首个字符
            let header = item.string.substring(to: 1)
            if predicate.evaluate(with: header) {
                item.initial = header.capitalized
            }else{
                
                if item.string != "" {
                    //特殊处理的一个字
                    if header == "长" {
                        item.initial = "C"
                        if let range = item.englishString.range(from: NSMakeRange(0, 1)) {
                            item.englishString = item.englishString.replacingCharacters(in:range , with: "C")
                        }
                    }else{
                        
                        let initial = item.englishString.substring(to: 1)
                        
                        if initial >= "A" && initial <= "Z" {
                            item.initial = initial
                        }else{
                            item.initial = "#"
                        }
                    }
                    
                }else{
                    item.initial = "#"
                }
            }
            objectAry.append(item)
        }
        
        //先按照首字母initial排序，然后对于首字母相同的再按照englishString排序
        let descriptor: NSSortDescriptor = NSSortDescriptor(key: "initial", ascending: true)
        let descriptor2: NSSortDescriptor = NSSortDescriptor(key: "englishString", ascending: true)
        let descriptorAry: NSArray = [descriptor,descriptor2]
        objectAry.sort(sortDescriptors: descriptorAry as! [NSSortDescriptor])
        
        return objectAry
    }
    
    
    /**
     * 将中文转化为英文(英文不变)
     *@param   chinese   传入的字符串
     *@return  返回去掉空格并大写的字符串
     */
    class func transform(chinese : String) -> String{
        
        let english = NSMutableString(string: chinese)
        
        CFStringTransform(english as CFMutableString, nil, kCFStringTransformMandarinLatin, false)
        CFStringTransform(english as CFMutableString, nil, kCFStringTransformStripCombiningMarks, false)
        
        //去除两端空格和回车 中间空格不用去，用以区分不同汉字
        english.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        return english.uppercased
        
    }
    

    
    
    
}


// MARK: - 分类拓展

extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return substring(from: fromIndex)
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return substring(to: toIndex)
    }
    
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return substring(with: startIndex..<endIndex)
    }
    
    
    
    func nsRange(from range: Range<String.Index>) -> NSRange {
        let from = range.lowerBound.samePosition(in: utf16)
        let to = range.upperBound.samePosition(in: utf16)
        return NSRange(location: utf16.distance(from: utf16.startIndex, to: from),
                       length: utf16.distance(from: from, to: to))
    }
    
    
    func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location + nsRange.length, limitedBy: utf16.endIndex),
            let from = from16.samePosition(in: self),
            let to = to16.samePosition(in: self)
            else { return nil }
        return from ..< to
    }
}


extension Character
{
    func toInt() -> Int
    {
        var intFromCharacter:Int = 0
        for scalar in String(self).unicodeScalars
        {
            intFromCharacter = Int(scalar.value)
        }
        return intFromCharacter
    }
}

 
extension MutableCollection where Self : RandomAccessCollection {
    /// Sort `self` in-place using criteria stored in a NSSortDescriptors array
    public mutating func sort(sortDescriptors theSortDescs: [NSSortDescriptor]) {
        sort { by:
            for sortDesc in theSortDescs {
                switch sortDesc.compare($0, to: $1) {
                case .orderedAscending: return true
                case .orderedDescending: return false
                case .orderedSame: continue
                }
            }
            return false
        }
        
    }
}

extension Sequence where Iterator.Element : AnyObject {
    /// Return an `Array` containing the sorted elements of `source`
    /// using criteria stored in a NSSortDescriptors array.
    
    public func sorted(sortDescriptors theSortDescs: [NSSortDescriptor]) -> [Self.Iterator.Element] {
        return sorted {
            for sortDesc in theSortDescs {
                switch sortDesc.compare($0, to: $1) {
                case .orderedAscending: return true
                case .orderedDescending: return false
                case .orderedSame: continue
                }
            }
            return false
        }
    }
}
