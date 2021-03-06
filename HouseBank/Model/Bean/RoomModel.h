//
//  RoomModel.h
//  HouseBank
//
//  Created by JunJun on 15/1/14.
//  Copyright (c) 2015年 QCloud. All rights reserved.
//

#import "WXBaseModel.h"

@interface RoomModel : WXBaseModel
@property(nonatomic,strong)NSNumber *communityId;
@property(nonatomic,strong)NSNumber *blockId;
@property(nonatomic,strong)NSNumber *cityId;
@property(nonatomic,strong)NSNumber *regionId;
@property(nonatomic,strong)NSNumber *exclusiveDelegate; //委托类型
@property(nonatomic,strong)NSNumber *monthPrice; //租金
@property(nonatomic,strong)NSNumber *totalPrice; //总价 万元
@property (nonatomic,strong)NSNumber *buildArea;  //使用面积
@property(nonatomic,strong)NSNumber *unitPrice;  //单价 平方米
@property (nonatomic,strong) NSString *buildingNum; //栋号
@property(nonatomic,strong)NSNumber *houseNum;  //房号
@property (nonatomic,strong)NSNumber *houseType;//类别
@property(nonatomic,strong)NSNumber *lookHouse; //看房
@property (nonatomic,strong)NSNumber *houseFloor; //第几层
@property (nonatomic,strong)NSNumber *totalFloor; //共几层
@property (nonatomic,strong)NSNumber *decorationState; //装修程度
@property (nonatomic,copy) NSString *ownerName;   //业主姓名
@property (nonatomic,copy) NSString *mobilephone1; //业主手机
@property (nonatomic,strong)NSNumber *bedRooms; //房间数
@property (nonatomic,strong)NSNumber *livingRooms; //厅
@property (nonatomic,strong)NSNumber *washRooms;  //卫生间
@property (nonatomic,strong)NSNumber *paymentType; //支付方式
@property (nonatomic,strong)NSNumber *toward;//朝向
@property (nonatomic,strong)NSNumber *liftState;//几梯几户
@property (nonatomic,copy)NSString *title;//广告标题
@property (nonatomic,copy)NSNumber *propertyPrice;//物业费
@property (nonatomic,copy)NSString *description1; //广告内容
@property (nonatomic,copy)NSNumber *leftCommission; //上家佣金
@property (nonatomic,copy)NSNumber *rightCommission; //下家佣金
@property (nonatomic,strong)NSNumber *sellerDivided;//卖方经纪人
@property (nonatomic,strong)NSNumber *buyerDivided;//买方经纪人
@property (nonatomic,copy)NSString *delegateEndDate; //有效期
@property (nonatomic,copy)NSString *memo; //备注
@property (nonatomic,strong)NSNumber *facilities;//配套设施
@end
