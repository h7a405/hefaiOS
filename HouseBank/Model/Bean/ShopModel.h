//
//  ShopModel.h
//  HouseBank
//
//  Created by JunJun on 15/1/15.
//  Copyright (c) 2015年 QCloud. All rights reserved.
//

#import "WXBaseModel.h"

@interface ShopModel : WXBaseModel
@property(nonatomic,strong)NSNumber *blockId;
@property(nonatomic,strong)NSNumber *cityId;
@property(nonatomic,strong)NSNumber *regionId;
@property(nonatomic,strong)NSString *address;//楼盘地址
@property (nonatomic,strong)NSNumber *shopType; //商铺类型
@property(nonatomic,strong)NSNumber *exclusiveDelegate; //委托类型
@property(nonatomic,strong)NSNumber *shouState; //一手二手
@property (nonatomic,strong)NSNumber *currentStatus; //现状
@property (nonatomic,strong)NSNumber *lookHouse;  //看房
@property (nonatomic,strong) NSNumber *shopYear; //房龄
@property (nonatomic,copy)NSString *giveHouseDate;//交房时间
@property (nonatomic,copy)NSString *developers;//开发商
@property (nonatomic,strong) NSNumber *propertyYear; //产权
@property(nonatomic,strong)NSNumber *monthPrice; //租金
@property (nonatomic,strong)NSNumber *buildArea;  //使用面积
@property (nonatomic,strong)NSNumber *seperate; //分割
@property (nonatomic,strong)NSNumber *houseFloor; //第几层
@property (nonatomic,strong)NSNumber *totalFloor; //共几层
@property (nonatomic,strong)NSNumber *decorationState; //装修程度
@property (nonatomic,copy)NSNumber *propertyPrice;//物业费
@property (nonatomic,strong)NSNumber *paymentType; //支付方式
@property (nonatomic,strong)NSNumber *transfer; // 是否转让
@property (nonatomic,strong)NSString *shopName; //商铺名称
@property (nonatomic,copy)NSString *title;//广告标题
@property (nonatomic,copy)NSString *description1; //广告内容
@property (nonatomic,copy) NSString *ownerName;   //业主姓名
@property (nonatomic,copy) NSString *mobilephone1; //业主手机
@property (nonatomic,copy)NSNumber *leftCommission; //上家佣金
@property (nonatomic,copy)NSNumber *rightCommission; //下家佣金
@property (nonatomic,strong)NSNumber *sellerDivided;//卖方经纪人
@property (nonatomic,strong)NSNumber *buyerDivided;//买方经纪人
@property (nonatomic,copy)NSString *delegateEndDate; //有效期
@property (nonatomic,copy)NSString *memo; //备注
@property (nonatomic,strong)NSNumber *facilities;
@property (nonatomic,strong)NSString *targetFormat;

@end
