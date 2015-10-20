//
//  AddressBookWsImpl.h
//  HouseBank
//
//  Created by CSC on 14/12/31.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "BaseWs.h"

@interface AddressBookWsImpl : BaseWs

-(AFHTTPRequestOperationManager *) requestAddressBook : (NSString *) sid result : (Result) result;

-(AFHTTPRequestOperationManager *) addContact : (NSString *) sid name : (NSString *) name nickName : (NSString *) nickName mobilePhone : (NSString *)mobilePhone telPhone : (NSString *) phone email : (NSString *) email qq : (NSString *) qq weixin : (NSString *) weixin industry : (NSString *) industry company : (NSString *)company position : (NSString *)position birthday : (NSString *) birthday memorialDay : (NSString *) memorialDay importantLevel : (NSString *) level sourceId : (NSString *) sourceId memo :(NSString *) memo address : (NSString *) address linkType : (NSString *) linkType result : (Result) result ;

-(AFHTTPRequestOperationManager *) updateContact : (NSString *) sid contactId : (NSString *) contactId name : (NSString *) name nickName : (NSString *) nickName mobilePhone : (NSString *)mobilePhone telPhone : (NSString *) phone email : (NSString *) email qq : (NSString *) qq weixin : (NSString *) weixin industry : (NSString *) industry company : (NSString *)company position : (NSString *)position birthday : (NSString *) birthday memorialDay : (NSString *) memorialDay importantLevel : (NSString *) level sourceId : (NSString *) sourceId memo :(NSString *) memo address : (NSString *) address linkType : (NSString *) linkType result : (Result) result ;

-(AFHTTPRequestOperationManager *) requestContactInfo : (NSString *) contactId result : (Result) result ;

-(AFHTTPRequestOperationManager *) deleteContactInfo : (NSString *) contactId sid : (NSString *) sid result : (Result) result ;

@end
