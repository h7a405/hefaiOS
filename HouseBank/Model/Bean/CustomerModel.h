//
//  CustomerModel.h
//  客需
//
//  Created by JunJun on 14/12/30.
//  Copyright (c) 2014年 JunJun. All rights reserved.
//

#import "WXBaseModel.h"

@interface CustomerModel : WXBaseModel
@property(nonatomic,strong)NSNumber *purpose;//用途(1:住宅 2：写字楼, 3:商铺 )
@property(nonatomic,strong)NSNumber *tradeType;//交易类型(1:出售 2:出租)
@property(nonatomic,strong)NSNumber *blockId1;//板块Id(Int)
@property(nonatomic,strong)NSNumber *blockId2;
@property(nonatomic,strong)NSNumber *blockId3;
@property(nonatomic,strong)NSNumber *blockId4;
@property(nonatomic,strong)NSNumber *communityid1;//小区Id(Int)
@property(nonatomic,strong)NSNumber *communityid2;
@property(nonatomic,strong)NSNumber *communityid3;
@property(nonatomic,strong)NSNumber *communityid4;
@property(nonatomic,strong)NSNumber *areaFrom;//面积范围从
@property(nonatomic,strong)NSNumber *area_to;//面积范围到
@property(nonatomic,strong)NSNumber *priceFrom;//售价/租金范围从
@property(nonatomic,strong)NSNumber *priceTo;//售价/租金范围到
@property(nonatomic,strong)NSNumber *decorationState;// 程度(1:毛胚 2:简装 3:精装 4:豪装,5:中装)
@property(nonatomic,strong)NSNumber *bedRooms;
@property(nonatomic,strong)NSNumber *toward;//朝向(1=东 2=南 3=西 4=北 5=南北 6=东西 7=东南 8=西南 9=东北 10=西北 11=不知道朝向)
@property(nonatomic,strong)NSNumber *houseType;
@property(nonatomic,strong)NSNumber *houseFloorFrom;
@property(nonatomic,strong)NSNumber *houseFloorTo;
/*
 1，住宅类型,写字楼(1:多层,2:小高层,3:高层,4:复式,5:商住,6:酒店式公寓,7:叠加别墅,8:联排别墅,9:双拼别墅,10:独栋别墅,11:新式里弄,12:洋房,13:四合院,255:其它)
 2，商铺类型1, 住宅底商, 2, 商业街商铺,3, 写字楼配套底商, 4, 购物中心/百货,5, 其他;
 
 */
@property(nonatomic,copy)NSString *memo;//备注信息
@property(nonatomic,strong)NSNumber *targetFormat;//目标业态 1, 餐饮美食, 2,百货超市，3, 酒店宾馆,4,家居建材,5,服饰鞋包,6, 生活服务,7, 美容美发, 8, 休闲娱乐, 255, 其他;
@property(nonatomic,copy)NSString *customerName;//客户姓名
@property(nonatomic,copy)NSString *customerMobilephone;//客户手机
@property(nonatomic,strong)NSNumber *cityId;//客需所属城市
@property(nonatomic,copy)NSString *sid;//会话ID
@property (nonatomic,strong)NSNumber *facilities;


@end
