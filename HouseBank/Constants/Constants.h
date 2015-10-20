//
//  Constants.h
//  HouseBank
//
//  Created by CSC on 14-9-16.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

/**
 该头文件用于记录程序相关的常量 ， 包括所有与服务器交互的常量。
 该文件的常量与android版本大体是一致的，具体可查看android版本
 */

typedef NS_ENUM(NSInteger,TradeType){
    SALE = 1,//出售 ， 求购
    RENT = 2 //出租 ， 求租
};

//排序字段：升序用正数表示，降序用负数表示0：不排序（pt参数生效时，按距离由近到远排序）1：发布时间2：价格3：面积
typedef NS_ENUM(NSInteger , HouseSort){
    DefaultNoSort = 0,
    AreaFromSmall = 3,
    AreaFromBig = -3,
    PriceFromSmall = 2,
    PriceFromBig = -2
};

typedef NS_ENUM(NSInteger , ContactLevel){
    VIP = 1,
    A = 2,
    B = 3,
    C = 4,
    D = 5
};

#define VIPSTR @"VIP"
#define ASTR @"A"
#define BSTR @"B"
#define CSTR @"C"
#define DSTR @"D"

#define ABC [NSArray arrayWithObjects:@"#",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",nil]
#define ContactType [NSArray arrayWithObjects:@"房源业主",@"线索业主",@"普通业主",@"客需",@"商务",@"亲友",@"同行",@"合同",@"成交",@"其他", nil]
#define ContactSource [NSArray arrayWithObjects:@"来电",@"来访",@"客介",@"扫街",@"网络",@"报纸",@"杂志",@"电邮",@"信件",@"扫盘",@"短信",@"名单", nil]
#define LevelStrs [NSArray arrayWithObjects:VIPSTR,ASTR,BSTR,CSTR,DSTR,nil]

#ifndef HouseBank_Constants_h
#define HouseBank_Constants_h


/** app名称 与 后台设定 app_name 相同 */
#define APP_NAME    @"fybanks-b2b"
/** 当前版本信息 如有新版本 请修改版本信息  */
#define VERSION_CODE    @"1.0.8"

//#define KUrlConfig @"http://api.fybanks.com/v1/"
#define KUrlConfig @"http://116.231.0.133:88/v1/"
#define KImageUrlConfig @"http://img1.fybanks.com"

#define PROP_KEY_API_SERVER_URL    @"api_server_url"
#define PROP_KEY_API_VERSION    @"api_version"
#define PROP_KEY_IMAGE_SERVER_URL    @"image_server_url"
#define PROP_KEY_IS_DEBUG   @"is_debug"
#define PROP_KEY_DB_NAME   @"db_name"
#define PROP_KEY_APP_NAME   @"app_name"
#define PROP_KEY_APP_VERSION   @"app_version"

#define PREF_KEY_JSON_REGION_INFO   @"region_info_list"
#define PREF_KEY_JSON_LOGIN_USER   @"login_user"
#define PREF_KEY_JSON_LAST_LOGIN_USERNNAME   @"last_login_username"
#define PREF_KEY_JSON_SID   @"sid"
#define PREF_KEY_HOUSE_SEARCH_HISTORY   @"house_search_his"
#define PREF_KEY_RENTHOUSE_SEARCH_HISTORY   @"renthouse_search_his"

#define RESOURCE_HOUSE    @"house"
#define RESOURCE_NEWHOUSE    @"newhouse"
#define RESOURCE_HOUSE_COMMUNITY    @"house/community"
#define RESOURCE_RECOMMEND_HOUSE    @"house/recommend"
#define RESOURCE_SUBSCRIPTION_HOUSE    @"house/subscription"


#define RESOURCE_BROKER    @"broker"
#define RESOURCE_BROKER_DETAIL    @"broker/detail"
#define RESOURCE_BROKER_PHONE    @"broker/phone"
#define RESOURCE_BROKER_LOGIN    @"broker/login"
#define RESOURCE_BROKER_LOGOUT    @"broker/logout"
#define RESOURCE_BROKER_RELATED    @"broker/related"
#define RESOURCE_BROKER_SCORE    @"broker/score"
#define RESOURCE_BROKER_CREDIT    @"broker/credit"
#define MODYFY_BROKER_PWD    @"broker/password"
#define BROKER_COMMON_FRIENDS_NUM    @"broker/common/friendnum"
#define UPDATE_BROKER_INFO    @"broker/update"

#define RESOURCE_REGCHAIN @"broker/regchain"

#define RESOURCE_NEW_HOUSE    @"newhouse"
#define RESOURCE_NEW_HOUSE_INFO    @"new/house/info"
#define RESOURCE_NEW_HOUSE_RESERVATION    @"new/house/reservation"
#define RESOURCE_NEW_HOUSE_CALLRECORD    @"/new/house/callRecord"

#define SUGGESTION    @"suggestion"
#define RESOURCE_COMMUNITY    @"community"
#define RESOURCE_HOUSEUNIT    @"houseunit"
#define RESOURCE_VERSION   @"version"
#define RESOURCE_REGION    @"data/region"
#define RESOURCE_PAGE_VIEWCOUNT    @"pageiewcount"
#define RESOURCE_PAGE_VIEW   @"pageiew"
#define RESOURCE_NOTIFICATION    @"notification"
#define RESOURCE_NOTIFICATION_TIME    @"notification/time"

#define COOPERATION_HOUSE    @"cooperation"
#define COOPERATION_HOUSE_COMMENT    @"cooperation/comment"
#define COOPERATION_HOUSE_COMPLAINT    @"cooperation/complaint"
#define COOPERATION_HOUSE_DETAIL    @"cooperation/detail"
#define HAVE_HOUSE_COOPERATION    @"cooperation/havecooper"

#define RESOURCE_SUBSCRIPTION   @"subscription"

#define RESOURCE_LINK_MEMBER    @"linkmem"
#define RESOURCE_LINK_NEAR    @"broker/near"
#define CALLRECORD_HOUSE    @"house/callRecord"
#define LINK_INVITE_SMS    @"linkinvite/sms"
#define LINK_INVITE_EMAIL    @"linkinvite/email"
#define REQUEST_RECEIVE    @"request/receive"
#define REQUEST_SEND    @"linkinvitend"
#define REQUEST_OPERATE    @"request/updatestatus"
#define RESOURCE_ARTICLE    @"apparticle"
#define RESOURCE_APP_AD    @"app/ad"
#define PUSH_MASAGE_VIEW    @"com.hefa.fybanks.b2b.activity.UPDATE_LISTVIEW"

#define IMAGE_SERVER_NUM    3

#define FYBANKS_WAP_ADDRESS    @"http://m.fybanks.cn"

#define FYBANKSB2B_NEW_VERSION_ADDRESS    @"http://www.fybanks.com/about/appdownload.html"

#define ORIGIN_INTENT    @"origin_intent"
#define PAGE_HOUSE_DETAIL    101

#define PARAM_SID    @"sid"
#define PARAM_NOTIFICATION_MSG    @"nm"


#define NOTIFICATION_ID_SUBSCRIPTION_HOUSE    1

#define NOTICE_SUBSCRIPTION_TYPE  1  //订阅房源

#define NOTICE_CONTACT_TYPE    2  //人脉

#define NOTICE_COOPERATION_HOUSE_TYPE  3  //合作

#define NOTICE_SYSTEM_MARKING_TYPE    4  //营销

#define NOTICE_NOMAL_TYPE    0  //默认

/**
 分享
 */
#define SHARE_SINA_TYPE    1
#define SHARE_WEIBO_TYPE    2
#define SHARE_QQ_TYPE    3
#define SHARE_WEIXIN_TYPE    4
#define SHARE_PYQ_TYPE    5
#define SHARE_KJ_TYPE    6
#define SHARE_SMS_TYPE    7


#endif
