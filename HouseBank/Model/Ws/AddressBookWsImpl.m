//
//  AddressBookWsImpl.m
//  HouseBank
//
//  Created by CSC on 14/12/31.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "AddressBookWsImpl.h"

@implementation AddressBookWsImpl

-(AFHTTPRequestOperationManager *) requestAddressBook : (NSString *) sid result : (Result) result{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:sid forKey:@"sid"];
    [params setObject:@"1" forKey:@"pageNo"];
    [params setObject:@"10000" forKey:@"pageSize"];
    NSString *url = [KUrlConfig stringByAppendingString:@"contact/search"];
    return [super doGet:url method:@"" params:params result:result];
};

-(AFHTTPRequestOperationManager *) addContact : (NSString *) sid name : (NSString *) name nickName : (NSString *) nickName mobilePhone : (NSString *)mobilePhone telPhone : (NSString *) phone email : (NSString *) email qq : (NSString *) qq weixin : (NSString *) weixin industry : (NSString *) industry company : (NSString *)company position : (NSString *)position birthday : (NSString *) birthday memorialDay : (NSString *) memorialDay importantLevel : (NSString *) level sourceId : (NSString *) sourceId memo :(NSString *) memo address : (NSString *) address linkType : (NSString *) linkType result : (Result) result {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:sid forKey:@"sid"];
    [params setObject:name forKey:@"name"];
    [params setObject:nickName forKey:@"nickName"];
    [params setObject:mobilePhone forKey:@"mobilePhone1"];
    [params setObject:phone forKey:@"telPhone1"];
    [params setObject:email forKey:@"email"];
    [params setObject:qq forKey:@"qq"];
    [params setObject:weixin forKey:@"weixin"];
    [params setObject:industry forKey:@"industry"];
    [params setObject:company forKey:@"company"];
    [params setObject:position forKey:@"position"];
    //    [params setObject:birthday forKey:@"birthday"];
    //    [params setObject:memorialDay forKey:@"memorialDay"];
    [params setObject:level forKey:@"importantLevel"];
    [params setObject:sourceId forKey:@"sourceId"];
    [params setObject:memo forKey:@"memo"];
    [params setObject:address forKey:@"address"];
    [params setObject:linkType forKey:@"linkType"];
    
    NSString *url = [KUrlConfig stringByAppendingString:@"contact/add"];
    
    return [super doPost:url method:@"" params:params result:result];
};

-(AFHTTPRequestOperationManager *) updateContact : (NSString *) sid contactId : (NSString *) contactId name : (NSString *) name nickName : (NSString *) nickName mobilePhone : (NSString *)mobilePhone telPhone : (NSString *) phone email : (NSString *) email qq : (NSString *) qq weixin : (NSString *) weixin industry : (NSString *) industry company : (NSString *)company position : (NSString *)position birthday : (NSString *) birthday memorialDay : (NSString *) memorialDay importantLevel : (NSString *) level sourceId : (NSString *) sourceId memo :(NSString *) memo address : (NSString *) address linkType : (NSString *) linkType result : (Result) result {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:sid forKey:@"sid"];
    [params setObject:name forKey:@"name"];
    [params setObject:nickName forKey:@"nickName"];
    [params setObject:mobilePhone forKey:@"mobilePhone1"];
    [params setObject:phone forKey:@"telPhone1"];
    [params setObject:email forKey:@"email"];
    [params setObject:qq forKey:@"qq"];
    [params setObject:weixin forKey:@"weixin"];
    [params setObject:industry forKey:@"industry"];
    [params setObject:company forKey:@"company"];
    [params setObject:position forKey:@"position"];
    //    [params setObject:birthday forKey:@"birthday"];
    //    [params setObject:memorialDay forKey:@"memorialDay"];
    [params setObject:level forKey:@"importantLevel"];
    [params setObject:sourceId forKey:@"source_Id"];
    [params setObject:memo forKey:@"memo"];
    [params setObject:address forKey:@"address"];
    [params setObject:linkType forKey:@"linkType"];
    [params setObject:contactId forKey:@"contactId"];
    
    NSString *url = [KUrlConfig stringByAppendingString:@"contact/update"];
    
    return [super doPut:url method:@"" params:params result:result];
};

-(AFHTTPRequestOperationManager *) requestContactInfo : (NSString *) contactId result : (Result) result{
    NSString *url = [NSString stringWithFormat:@"%@%@%@",KUrlConfig,@"contact/",contactId];
    return [super doGet:url method:@"" params:nil result:result];
};

-(AFHTTPRequestOperationManager *) deleteContactInfo : (NSString *) contactId sid:(NSString *)sid result : (Result) result {
    NSString *url = [NSString stringWithFormat:@"%@%@%@/%@",KUrlConfig,@"contact/delete/",sid,contactId];
    return [super doGet:url method:@"" params:nil result:result];
};

@end
