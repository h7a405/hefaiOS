//
//  WsImpl.m
//  HouseBank
//
//  Created by CSC on 14-9-15.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "MyCenterWsImpl.h"

@implementation MyCenterWsImpl

-(AFHTTPRequestOperationManager *) requestBrokerInfo:(NSString *) url brokerId : (NSString *) brokerId result : (void(^)(BOOL isSuccess , id result ,NSString* data)) result{
    NSString *method = [NSString stringWithFormat:@"broker/%@",brokerId];
    return [super doGet:url method:method params:nil result:result];
};

-(AFHTTPRequestOperationManager *) updateBrokerResume : (NSString *) url resume:(NSString *)resume sid : (NSString *) sid result : (void(^)(BOOL isSuccess , id result,NSString* data)) result{
    NSDictionary *dic = @{@"resume":resume , @"updateCode": @"3" , @"sid":sid};
    return [super doPut:url method:@"" params:dic result:result];
};

-(AFHTTPRequestOperationManager *) requestBrokerDetall : (NSString *) url  result : (void(^)(BOOL isSuccess , id result,NSString* data)) result{
    return [super doGet:url method:@"" params:nil result:result];
};

-(AFHTTPRequestOperationManager *) updateBrokerBlock : (NSString *) url block1:(id) block1 block2:(id) block2 block3:(id) block3 block4:(id) block4 sid : (NSString *) sid result : (void(^)(BOOL isSuccess , id result,NSString* data)) result{
    NSDictionary *dic = @{@"familiarBlock1": [NSString stringWithFormat:@"%@",block1] , @"familiarBlock2": [NSString stringWithFormat:@"%@",block2],@"familiarBlock3": [NSString stringWithFormat:@"%@",block3],@"familiarBlock4": [NSString stringWithFormat:@"%@",block4] ,@"sid":sid , @"updateCode" : @"1"};
    return [super doPut:url method:@"" params:dic result:result];
};

-(AFHTTPRequestOperationManager *) requestAutoEdit : (NSString *) url text : (NSString *) text result : (void(^)(BOOL isSuccess , id result,NSString* data)) result{
    NSDictionary *dic = @{@"kw":text , @"pageSize":@"15"};
    return [super doGet:url method:@"" params:dic result:result];
};

-(AFHTTPRequestOperationManager *) updateFamiliarCommunity : (NSString *)url sid : (NSString *) sid community1 : (id) community1 community2 : (id) community2 community3 : (id) community3 community4 : (id) community4 result : (void(^)(BOOL isSuccess , id result,NSString* data)) result{
    NSDictionary *dic = @{@"sid":sid , @"familiarCommunity1": [NSString stringWithFormat:@"%@",community1],@"familiarCommunity2":[NSString stringWithFormat:@"%@",community2] , @"familiarCommunity3": [NSString stringWithFormat:@"%@",community3] ,@"familiarCommunity4":[NSString stringWithFormat:@"%@",community4] ,@"updateCode":@"2"};
    return [super doPut:url method:@"" params:dic result:result];
};

-(AFHTTPRequestOperationManager *) updataWorkYear : (NSString *)url sid : (NSString *) sid workYear : (NSInteger) year result : (void(^)(BOOL isSuccess , id result,NSString* data)) result{
    NSDictionary *dic = @{@"workYear":[NSString stringWithFormat:@"%d",year ] , @"sid":sid , @"updateCode":@"4"};
    return [super doPut:url method:@"" params:dic result:result];
};

-(AFHTTPRequestOperationManager *) updateSuggestion : (NSString *)url sid : (NSString *) sid content : (NSString *) content mobile : (NSString *) mobile result : (void(^)(BOOL isSuccess , id result,NSString* data)) result{
    NSDictionary *dic = @{@"content":content,@"source":@"2",@"contactInfo":mobile ,@"sid":sid};
    return [super doPost:url method:@"" params:dic result:result];
};

-(AFHTTPRequestOperationManager *) updatePwd : (NSString *)url oldPwd : (NSString *) oldPwd newPwd : (NSString *) newPwd sid : (NSString *) sid result : (void(^)(BOOL isSuccess , id result,NSString* data)) result{
    NSDictionary *dic = @{@"oldpwd":oldPwd,@"newpwd":newPwd,@"sid":sid};
    return [super doPut:url method:@"" params:dic result:result];
};

-(AFHTTPRequestOperationManager *) requestAppUpdate : (NSString *) url  result : (void(^)(BOOL isSuccess , id result,NSString* data)) result {
    return [super doGet:url method:@"" params:nil result:result];
};

-(AFHTTPRequestOperationManager *) requestPersonScore : (NSString *) url brokerId : (id) brokerId targetBrokerId : (id) targetBrokerId result : (void(^)(BOOL isSuccess , id result,NSString* data)) result{
    NSDictionary *dic = @{@"brokerId":brokerId , @"targetBrokerId":targetBrokerId};
    return [super doGet:url method:@"" params:dic result:result];
};

-(AFHTTPRequestOperationManager *) requestHouse : (NSString *) url relationIds : (NSString *) ids pageNo : (NSInteger) pageNo result : (void(^)(BOOL isSuccess , id result,NSString* data)) result{
    NSDictionary *dic = @{@"pageNo": [NSString stringWithFormat:@"%d",pageNo] , @"houseIds": ids};
    return [super doGet:url method:@"" params:dic result:result];
};

- (AFHTTPRequestOperationManager *)requestUserReportWithUrl:(NSString *)url andSid:(NSString *)sid andResult: (void(^)(BOOL isSucceeded , id result,NSString* data)) result{

    return [super doGet:[NSString stringWithFormat:@"%@/%@", url, sid] method:@"" params:nil result:result];
}

- (AFHTTPRequestOperationManager *)requestReportsWithUrl:(NSString *)url andSid:(NSString *)sid andLevel:(NSInteger)level andPageNo:(NSInteger)pageNo andPageSize:(NSInteger)pageSize andResult:(void(^)(BOOL isSucceeded, id result, NSString *data))result{
    NSDictionary *dic = @{@"sid" : sid, @"level" : [NSNumber numberWithInteger:level]};
    NSLog(@"%s || parameters for recommended:%@", __FUNCTION__, dic);
    return [super doGet:url method:@"" params:dic result:result];
}

- (AFHTTPRequestOperationManager *)requestDetailWithUrl:(NSString *)url andSid:(NSString *)sid andLevel:(NSInteger)level andTab:(NSInteger)tab andPageNo:(NSInteger)pageNo andPageSize:(NSInteger)pageSize andResult:(void(^)(BOOL isSucceeded, id result, NSString *data))result{
    NSDictionary *dic = @{@"sid" : sid, @"level" : [NSNumber numberWithInteger:level], @"tab" : [NSNumber numberWithInteger:tab]};
    NSLog(@"%s || parameters for detail:%@", __FUNCTION__, dic);
    return [super doGet:url method:@"" params:dic result:result];
}

@end
