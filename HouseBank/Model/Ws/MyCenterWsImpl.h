//
//  WsImpl.h
//  HouseBank
//
//  Created by CSC on 14-9-15.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "BaseWs.h"

/**
 该类用于个人中心中所有与服务器交互的请求ws类
 */
@interface MyCenterWsImpl : BaseWs

//请求经纪人个人信息
-(AFHTTPRequestOperationManager *) requestBrokerInfo:(NSString *) url brokerId : (NSString *) brokerId result : (void(^)(BOOL isSuccess , id result,NSString* data)) result;
//修改经纪人自我介绍
-(AFHTTPRequestOperationManager *) updateBrokerResume : (NSString *) url resume : (NSString *) resume sid : (NSString *) sid result : (void(^)(BOOL isSuccess , id result,NSString* data)) result;
//请求经纪人位置信息
-(AFHTTPRequestOperationManager *) requestBrokerDetall : (NSString *) url  result : (void(^)(BOOL isSuccess , id result,NSString* data)) result;
//修改经纪人熟悉板块
-(AFHTTPRequestOperationManager *) updateBrokerBlock : (NSString *) url block1:(id) block1 block2:(id) block2 block3:(id) block3 block4:(id) block4 sid : (NSString *) sid result : (void(^)(BOOL isSuccess , id result,NSString* data)) result;
//请求自动主营小区
-(AFHTTPRequestOperationManager *) requestAutoEdit : (NSString *) url text : (NSString *) text result : (void(^)(BOOL isSuccess , id result,NSString* data)) result;
//修改经纪人主营小区
-(AFHTTPRequestOperationManager *) updateFamiliarCommunity : (NSString *)url sid : (NSString *) sid community1 : (id) community1 community2 : (id) community2 community3 : (id) community3 community4 : (id) community4 result : (void(^)(BOOL isSuccess , id result,NSString* data)) result;
//修改经纪人工作年限
-(AFHTTPRequestOperationManager *) updataWorkYear : (NSString *)url sid : (NSString *) sid workYear : (NSInteger) year result : (void(^)(BOOL isSuccess , id result,NSString* data)) result;
// 提交反馈
-(AFHTTPRequestOperationManager *) updateSuggestion : (NSString *)url sid : (NSString *) sid content : (NSString *) content mobile : (NSString *) mobile result : (void(^)(BOOL isSuccess , id result,NSString* data)) result;
//修改密码
-(AFHTTPRequestOperationManager *) updatePwd : (NSString *)url oldPwd : (NSString *) oldPwd newPwd : (NSString *) newPwd sid : (NSString *) sid result : (void(^)(BOOL isSuccess , id result,NSString* data)) result;
//检查app更新
-(AFHTTPRequestOperationManager *) requestAppUpdate : (NSString *) url  result : (void(^)(BOOL isSuccess , id result,NSString* data)) result;
//请求诚信
-(AFHTTPRequestOperationManager *) requestPersonScore : (NSString *) url brokerId : (id) brokerId targetBrokerId : (id) targetBrokerId result : (void(^)(BOOL isSuccess , id result,NSString* data)) result;
//根据联系人id请求房子信息
-(AFHTTPRequestOperationManager *) requestHouse : (NSString *) url relationIds : (NSString *) ids pageNo : (NSInteger) pageNo result : (void(^)(BOOL isSuccess , id result,NSString* data)) result;
//获取用户基本信息
- (AFHTTPRequestOperationManager *)requestUserReportWithUrl:(NSString *)url andSid:(NSString *)sid andResult: (void(^)(BOOL isSucceeded , id result,NSString* data)) result;
//获取用户推荐人信息
- (AFHTTPRequestOperationManager *)requestReportsWithUrl:(NSString *)url andSid:(NSString *)sid andLevel:(NSInteger)level andPageNo:(NSInteger)pageNo andPageSize:(NSInteger)pageSize andResult:(void(^)(BOOL isSucceeded, id result, NSString *data))result;
//获取用户收支信息
- (AFHTTPRequestOperationManager *)requestDetailWithUrl:(NSString *)url andSid:(NSString *)sid andLevel:(NSInteger)level andTab:(NSInteger)tab andPageNo:(NSInteger)pageNo andPageSize:(NSInteger)pageSize andResult:(void(^)(BOOL isSucceeded, id result, NSString *data))result;
@end
