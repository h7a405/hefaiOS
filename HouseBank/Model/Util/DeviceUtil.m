//
//  DeviceUtil.m
//  HouseBank
//
//  Created by CSC on 14/12/1.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "DeviceUtil.h"
#import "Reachability.h"
#import <AddressBookUI/AddressBookUI.h>

@implementation DeviceUtil

+(BOOL)checkNetWork{
    Reachability *reach=[Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch (reach.currentReachabilityStatus) {
        case kNotReachable:
        {
            [[[UIAlertView alloc]initWithTitle:@"提示" message:@"当时无网络！" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
            return NO;
        }
        case kReachableViaWWAN:
            NSLog(@"wifi");
            break;
        case kReachableViaWiFi:
            NSLog(@"手机上网");
            break;
    }
    return YES;
}


//读取所有联系人

+(NSArray *)allContact{
    NSMutableArray *array = [NSMutableArray new];
    
    //取得本地通信录名柄
    ABAddressBookRef tmpAddressBook = nil;
    
    if ([[UIDevice currentDevice].systemVersion floatValue]>=6.0) {
        tmpAddressBook=ABAddressBookCreateWithOptions(NULL, NULL);
        dispatch_semaphore_t sema=dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(tmpAddressBook, ^(bool greanted, CFErrorRef error){
            dispatch_semaphore_signal(sema);
        });
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }
    
    //取得本地所有联系人记录
    if (tmpAddressBook==nil) {
        return array;
    };
    
    NSArray* tmpPeoples = (__bridge NSArray*)ABAddressBookCopyArrayOfAllPeople(tmpAddressBook);
    
    for(id tmpPerson in tmpPeoples){
        NSMutableDictionary *dict = [NSMutableDictionary new];
        [array addObject:dict];
        
        //获取的联系人单一属性:First name
        NSString* tmpFirstName = (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonFirstNameProperty);
        
        //获取的联系人单一属性:Last name
        NSString* tmpLastName = (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonLastNameProperty);
        
        NSString *name = [NSString stringWithFormat:@"%@%@",tmpLastName?tmpLastName:@"",tmpFirstName?tmpFirstName:@""];
        name = ([name isEqualToString:@""]) ? @"未命名" : name;
        [dict setObject:name forKey:@"name"];
        
        //获取的联系人单一属性:Nickname
        
        NSString* tmpNickname = (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonNicknameProperty);
        
        [dict setObject:tmpNickname?tmpNickname:@"" forKey:@"nickName"];
        
        //获取的联系人单一属性:Company name
        NSString* tmpCompanyname = (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonOrganizationProperty);
        
        [dict setObject:tmpCompanyname?tmpCompanyname:@"" forKey:@"company"];
        
        NSMutableArray *phones = [NSMutableArray new];
        [dict setObject:phones forKey:@"phones"];
        
        //获取的联系人单一属性:Generic phone number
        ABMultiValueRef tmpPhones = ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonPhoneProperty);
        
        for(NSInteger j = 0; j < ABMultiValueGetCount(tmpPhones); j++){
            NSString* tmpPhoneIndex = (__bridge NSString*)ABMultiValueCopyValueAtIndex(tmpPhones, j);
            
            [phones addObject:tmpPhoneIndex];
        }
        
        CFRelease(tmpPhones);
    }
    
    //释放内存
    CFRelease(tmpAddressBook);
    
    return array ;
}

@end
