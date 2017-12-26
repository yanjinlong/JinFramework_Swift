//
//  ViewController.swift
//  JinFramework_Swift
//
//  Created by 严锦龙 on 2017/11/27.
//  Copyright © 2017年 Jin. All rights reserved.
//

import UIKit
import Contacts
import AddressBook

class AddressBookItem: NSObject {
    var name: String?
    var phoneNum: String?
}

class ViewController: JFWViewController {
    fileprivate var addressBookItems: [AddressBookItem] = [AddressBookItem]()
    
    override func customView() {
//        CNContactStore().requestAccess(for: .contacts) { (isRight, error) in
//            if isRight {
//                //授权成功加载数据。
//                print(Date())
////                self.loadContactsData()
//                self.loadAddressBook()
//                print(Date())
//                print(self.addressBookItems.count)
//            }
//        }
        
//        let vc = LectionViewController()
//        self.present(vc, animated: true, completion: nil)
        
//        let network = AFHTTPSessionManager()
//        network.requestSerializer = AFJSONRequestSerializer()
//        network.responseSerializer = AFJSONResponseSerializer()
//        var param = [String: String]()
//        param["cate"] = "1"
//        param["formSource"] = "iOS"
//        param["pageNo"] = "1"
//        param["pageSize"] = "50"
//
//        network.post("http://192.168.31.99/zb_users/plugin/haloapi/api.php?act=qryArticle", parameters: param, progress: nil, success: { (task
//            , responseData) in
//            let result = responseData as! NSDictionary
//            print(result)
//        }, failure: { (task, error) in
//            print(error)
//        })
    }
    
    @IBAction func gotoLection(_ sender: Any) {
        let vc = LectionViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func loadAddressBook() -> Void {
        // 2.获取联系人
        let addressBook = ABAddressBookCreate().takeRetainedValue()
        let peopleArr = ABAddressBookCopyArrayOfAllPeople(addressBook).takeRetainedValue()
        
        // 3.遍历
        let count = CFArrayGetCount(peopleArr)
        
        for i in 0..<count {
            // 获取数组的值
            let p = CFArrayGetValueAtIndex(peopleArr, i)
            // 类型转换
            let record = unsafeBitCast(p, to: ABRecord.self)
            // 获取姓名
            var name = String()
            let firstName = ABRecordCopyValue(record, kABPersonFirstNameProperty)?.takeRetainedValue() as! String? ?? ""
            let lastName = ABRecordCopyValue(record, kABPersonLastNameProperty)?.takeRetainedValue() as! String? ?? ""
            
            if firstName != "" && lastName != "" {
                name = lastName + firstName
            } else if firstName != "" {
                name = firstName
            } else if lastName != "" {
                name = lastName
            }
            
            // 获取电话号码
            let multiValue = ABRecordCopyValue(record, kABPersonPhoneProperty).takeRetainedValue() as ABMultiValue
            let phoneNums = ABMultiValueGetCount(multiValue)
            
            // 遍历
            for j in 0..<phoneNums {
                // 获取值
                let value = ABMultiValueCopyValueAtIndex(multiValue, j).takeRetainedValue() as! String
                let phone = ViewController.ww_handleSpecialCharacter(value)
                
                let bookItem = AddressBookItem()
                bookItem.name = "\(name)"
                bookItem.phoneNum = phone
                
                self.addressBookItems.append(bookItem)
            }
        }
    }
    
    class func ww_handleSpecialCharacter(_ str: String) -> String {
        var tempStr: NSString = ""
        let nsStr = str as NSString
        
        for i in 0..<nsStr.length {
            let strc = nsStr.substring(with: NSMakeRange(i, 1))
            
            if !strc.isEqual("-") && !strc.isEqual("(") && !strc.isEqual(")") && !strc.isEqual(" ") && !strc.isEqual(" ") {
                tempStr = tempStr.appending(strc) as NSString
            }
        }
        
        return tempStr as String
    }
    
    func loadContactsData() {
        //获取授权状态
        let status = CNContactStore.authorizationStatus(for: .contacts)
        //判断当前授权状态
        guard status == .authorized else { return }
        
        //创建通讯录对象
        let store = CNContactStore()
        
        //获取Fetch,并且指定要获取联系人中的什么属性
        let keys = [CNContactFamilyNameKey, CNContactGivenNameKey, CNContactNicknameKey,
                    CNContactOrganizationNameKey, CNContactJobTitleKey,
                    CNContactDepartmentNameKey, CNContactNoteKey, CNContactPhoneNumbersKey,
                    CNContactEmailAddressesKey, CNContactPostalAddressesKey,
                    CNContactDatesKey, CNContactInstantMessageAddressesKey
        ]
        
        //创建请求对象
        //需要传入一个(keysToFetch: [CNKeyDescriptor]) 包含CNKeyDescriptor类型的数组
        let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
        
        //遍历所有联系人
        do {
            try store.enumerateContacts(with: request, usingBlock: {
                (contact : CNContact, stop : UnsafeMutablePointer<ObjCBool>) -> Void in
                
                //获取姓名
                let lastName = contact.familyName
                let firstName = contact.givenName
//                print("姓名：\(lastName)\(firstName)")
//
//                //获取昵称
//                let nikeName = contact.nickname
//                print("昵称：\(nikeName)")
//
//                //获取公司（组织）
//                let organization = contact.organizationName
//                print("公司（组织）：\(organization)")
//
//                //获取职位
//                let jobTitle = contact.jobTitle
//                print("职位：\(jobTitle)")
//
//                //获取部门
//                let department = contact.departmentName
//                print("部门：\(department)")
//
//                //获取备注
//                let note = contact.note
//                print("备注：\(note)")
                
                //获取电话号码
//                print("电话：")
                for phone in contact.phoneNumbers {
                    //获得标签名（转为能看得懂的本地标签名，比如work、home）
                    var label = "未知标签"
                    if phone.label != nil {
                        label = CNLabeledValue<NSString>.localizedString(forLabel:
                            phone.label!)
                    }
                    
                    //获取号码
                    let value = phone.value.stringValue
//                    print("\t\(label)：\(value)")
                    
                    let bookItem = AddressBookItem()
                    bookItem.name = "\(lastName)\(firstName)"
                    bookItem.phoneNum = value
                    
                    self.addressBookItems.append(bookItem)
                }
//
//                //获取Email
//                print("Email：")
//                for email in contact.emailAddresses {
//                    //获得标签名（转为能看得懂的本地标签名）
//                    var label = "未知标签"
//                    if email.label != nil {
//                        label = CNLabeledValue<NSString>.localizedString(forLabel:
//                            email.label!)
//                    }
//
//                    //获取值
//                    let value = email.value
//                    print("\t\(label)：\(value)")
//                }
//
//                //获取地址
//                print("地址：")
//                for address in contact.postalAddresses {
//                    //获得标签名（转为能看得懂的本地标签名）
//                    var label = "未知标签"
//                    if address.label != nil {
//                        label = CNLabeledValue<NSString>.localizedString(forLabel:
//                            address.label!)
//                    }
//
//                    //获取值
//                    let detail = address.value
//                    let contry = detail.value(forKey: CNPostalAddressCountryKey) ?? ""
//                    let state = detail.value(forKey: CNPostalAddressStateKey) ?? ""
//                    let city = detail.value(forKey: CNPostalAddressCityKey) ?? ""
//                    let street = detail.value(forKey: CNPostalAddressStreetKey) ?? ""
//                    let code = detail.value(forKey: CNPostalAddressPostalCodeKey) ?? ""
//                    let str = "国家:\(contry) 省:\(state) 城市:\(city) 街道:\(street)"
//                        + " 邮编:\(code)"
//                    print("\t\(label)：\(str)")
//                }
//
//                //获取纪念日
//                print("纪念日：")
//                for date in contact.dates {
//                    //获得标签名（转为能看得懂的本地标签名）
//                    var label = "未知标签"
//                    if date.label != nil {
//                        label = CNLabeledValue<NSString>.localizedString(forLabel:
//                            date.label!)
//                    }
//
//                    //获取值
//                    let dateComponents = date.value as DateComponents
//                    let value = NSCalendar.current.date(from: dateComponents)
//                    let dateFormatter = DateFormatter()
//                    dateFormatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
//                    print("\t\(label)：\(dateFormatter.string(from: value!))")
//                }
//
//                //获取即时通讯(IM)
//                print("即时通讯(IM)：")
//                for im in contact.instantMessageAddresses {
//                    //获得标签名（转为能看得懂的本地标签名）
//                    var label = "未知标签"
//                    if im.label != nil {
//                        label = CNLabeledValue<NSString>.localizedString(forLabel:
//                            im.label!)
//                    }
//
//                    //获取值
//                    let detail = im.value
//                    let username = detail.value(forKey: CNInstantMessageAddressUsernameKey)
//                        ?? ""
//                    let service = detail.value(forKey: CNInstantMessageAddressServiceKey)
//                        ?? ""
//                    print("\t\(label)：\(username) 服务:\(service)")
//                }
                
//                print("----------------")
                
            })
        } catch {
            print(error)
        }
    }
    
//    var array2 = [TableRowItem]()
//
//    override func customView() {
//        var array1 = [TableRowItem]()
//
//        for _ in 0...10000 {
//            let row = TableRowItem(icon: nil, text: UUID().uuidString, code: UUID().uuidString)
//            array1.append(row)
//        }
//
//        let startTime = NSDate().string(withFormat: "yyyy-MM-dd HH:mm:ss.SSS")
//        NSLog("开始时间 \(startTime!)")
//        self.showLoading(loadTips: nil)
//
//        for item in array1 {
//            array2.append(item)
//        }
//
//        let endTime = NSDate().string(withFormat: "yyyy-MM-dd HH:mm:ss.SSS")
//        NSLog("结束时间 \(endTime!)")
//        self.dismissLoading()
//    }
}

