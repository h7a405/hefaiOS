//
//  FileUtil.h
//  EasyPoster
//
//  Created by CSC on 14-8-8.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileUtil : NSObject
+(NSString *) folderPathCreateIfNotExist : (NSString *) folder;//沙盒document路径下的路径，如果不存在将创建
+(NSString *) filePath : (NSString *) fileName folder : (NSString *) folder;//沙盒document路径下的路径，如果不存在将创建,并且将带文件名
+(NSString *) createFolderIfNotExist : (NSString *) folder;
+(BOOL) isPathExist : (NSString *) path ;//文件或者路径是否存在
+(NSString *) documentPath ;//沙盒document路径
+(NSString *) cachePath ;
+(void) clearFolder : (NSString *) folder;// 清空文件夹下的文件和文件夹
+(void) deleteFile : (NSString *) path;//删除文件
+(void) createFile : (NSString *) path;//建立文件
+(void) createFile:(NSString *)path data : (NSData *) data;//创建文件，并且有相应的内容
+(NSString*)fileMD5WithPath:(NSString*)path;
+(NSArray *) fileNamesFromPath : (NSString *) path;
+(NSString *) saveImage2Path : (UIImage *) image path : (NSString *) path;
+(void) rename:(NSString *) path old : (NSString *) oldName newName : (NSString *) newName;
@end
