//
//  GetContactPersonList.m
//  WmjrApp
//
//  Created by 霍锐 on 2018/1/28.
//  Copyright © 2018年 Baimifan. All rights reserved.
//

#import "GetContactPersonList.h"
#import <Contacts/Contacts.h>

@interface GetContactPersonList()

@property (nonatomic, strong)NSMutableArray *personList;

@end

@implementation GetContactPersonList

+ (GetContactPersonList *)sharedManager {
    static GetContactPersonList *sharedSingletonInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSingletonInstance = [[self alloc] init];
    });
    return sharedSingletonInstance;
}

- (NSString *)getPeronListMethod {
    
    _personList = [[NSMutableArray alloc]init];
    
    // 1.获取授权状态
//    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    
    // 2.判断授权状态,如果不是已经授权,则直接返回
//    if (status != CNAuthorizationStatusAuthorized) return;
    
    // 3.创建通信录对象
    CNContactStore *contactStore = [[CNContactStore alloc] init];
    
    // 4.创建获取通信录的请求对象
    // 4.1.拿到所有打算获取的属性对应的key
    NSArray *keys = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey];
    
    // 4.2.创建CNContactFetchRequest对象
    CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:keys];
    
    // 5.遍历所有的联系人
    [contactStore enumerateContactsWithFetchRequest:request error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        // 1.获取联系人的姓名
        NSString *lastname = contact.familyName;
        NSString *firstname = contact.givenName;
//        NSLog(@"%@ %@", lastname, firstname);
        
        NSString *personName = [lastname stringByAppendingString:firstname];
        
        // 2.获取联系人的电话号码
        NSArray *phoneNums = contact.phoneNumbers;
        NSString *phoneNumber = @"";
        for (CNLabeledValue *labeledValue in phoneNums) {
//            // 2.1.获取电话号码的KEY
//            NSString *phoneLabel = labeledValue.label;
            
            // 2.2.获取电话号码
            CNPhoneNumber *phoneNumer = labeledValue.value;
            NSString *phoneValue = phoneNumer.stringValue;
            
//            NSLog(@"%@ %@", phoneLabel, phoneValue);
            phoneNumber = phoneValue;
        }
        NSDictionary *dict = @{@"mobile":phoneNumber,@"name":personName};
        [_personList addObject:dict];
        
    }];
    
    NSData *data=[NSJSONSerialization dataWithJSONObject:_personList options:NSJSONWritingPrettyPrinted error:nil];
    NSString *personListString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    return personListString;
    
}

@end
