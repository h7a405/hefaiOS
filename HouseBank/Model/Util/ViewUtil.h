//
//  ViewUtil.h
//  Jnrlink
//
//  Created by apple on 14-4-21.
//  Copyright (c) 2014年 allin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ViewUtil : NSObject
/**
 从UIColor（颜色）对象获得一张Uiimage对象，
 */
+(UIImage*) imageWithColor:(UIColor*)color;

/**
 压缩图片到指定的大小
 */
+(UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;

+(UIImage *) imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size;
/**
 从字符获取UIColor对象，为8位、6位、9位和7位，
 e.g. ffffff   ff123456  #ff123456 #ffffff
  不合法字符串返回 #00ffffff对应的uicolor
 */
+(UIColor *) string2Color : (NSString *) color;
/**
 将系统所有的字体打印，用于调试
 */
+(void) logFontNames ;
/**
 打印区域，用于调试
 */
+(void) logRect : (CGRect) rect ;
/**
 打印点，用于调试
 */
+(void) logPoint : (CGPoint) point ;
/**
 打印view的变换，用于调试
 */
+(void) logTramform : (CGAffineTransform) transform;
/**
 打印尺寸，用于调试
 */
+(void) logSize : (CGSize) size;

/**
 判断系统中某字体是否存在，存在返回
 true ：存在
 false ： 不存在
 */
+(BOOL) isFontExists : (NSString *) fontName ;
/**
 从一个UIView对象获取一个UIImage，该图片与UIView是大小一致，显示一致的
 */
+(UIImage*)imageFromView:(UIView*)view ;
/**
 判断某个点是否在对应的点的包围的区域之中
 true ：在
 false ： 不在
 */
+(BOOL) containsPoint:(CGPoint) point vertex: (CGPoint[]) vertexPointFs lenght : (int) length;
/**
 判断某个点是否在某个区域之中
 */
+(BOOL) containsPoint:(CGPoint)point vertex:(CGRect) rect;
/**
 从一个UIView对象获取一个UIImage，该图片的大小与指定的大小一致，显示一致的
 */
+(UIImage *)imageFromView: (UIView *) theView   atFrame:(CGRect)r;

/**
 两点之间的距离
 */
+(float) distanceBetweenPoint : (CGPoint )point1 point2 : (CGPoint ) point2;

/**
 *  xib初始化view
 *
 *  @param name
 *
 *  @return
 */
+(UIView *)xibView:(NSString *)name;

/**
 *  对部份字体进行着色
 *
 *  @param content 全部内容
 *  @param search  要着色的内容
 *
 *  @return NSAttributedString
 */
+(NSAttributedString *)content:(NSString *)content colorString:(NSString *)search;

@end
