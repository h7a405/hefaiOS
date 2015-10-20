//
//  FileUtil.m
//  EasyPoster
//
//  Created by CSC on 14-8-8.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "FileUtil.h"

#include <TargetConditionals.h>
#include <CommonCrypto/CommonDigest.h>

#define FileHashDefaultChunkSizeForReadingData 4096

CFStringRef FileMD5HashCreateWithPath(CFStringRef filePath,size_t chunkSizeForReadingData) {
    // Declare needed variables
    CFStringRef result = NULL;
    CFReadStreamRef readStream = NULL;
    // Get the file URL
    CFURLRef fileURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault,
                                                     (CFStringRef)filePath,
                                                     kCFURLPOSIXPathStyle,
                                                     (Boolean)false);
    if (!fileURL) goto done;
    // Create and open the read stream
    readStream = CFReadStreamCreateWithFile(kCFAllocatorDefault,
                                            (CFURLRef)fileURL);
    if (!readStream) goto done;
    bool didSucceed = (bool)CFReadStreamOpen(readStream);
    if (!didSucceed) goto done;
    // Initialize the hash object
    CC_MD5_CTX hashObject;
    CC_MD5_Init(&hashObject);
    // Make sure chunkSizeForReadingData is valid
    if (!chunkSizeForReadingData) {
        chunkSizeForReadingData = FileHashDefaultChunkSizeForReadingData;
    }
    // Feed the data to the hash object
    bool hasMoreData = true;
    while (hasMoreData) {
        uint8_t buffer[chunkSizeForReadingData];
        CFIndex readBytesCount = CFReadStreamRead(readStream,(UInt8 *)buffer,(CFIndex)sizeof(buffer));
        if (readBytesCount == -1) break;
        if (readBytesCount == 0) {
            hasMoreData = false;
            continue;
        }
        CC_MD5_Update(&hashObject,(const void *)buffer,(CC_LONG)readBytesCount);
    }
    // Check if the read operation succeeded
    didSucceed = !hasMoreData;
    // Compute the hash digest
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &hashObject);
    // Abort if the read operation failed
    if (!didSucceed) goto done;
    // Compute the string result
    char hash[2 * sizeof(digest) + 1];
    for (size_t i = 0; i < sizeof(digest); ++i) {
        snprintf(hash + (2 * i), 3, "%02x", (int)(digest[i]));
    }
    result = CFStringCreateWithCString(kCFAllocatorDefault,(const char *)hash,kCFStringEncodingUTF8);
    
done:
    if (readStream) {
        CFReadStreamClose(readStream);
        CFRelease(readStream);
    }
    if (fileURL) {
        CFRelease(fileURL);
    }
    return result;
}

@implementation FileUtil
+(NSString *) folderPathCreateIfNotExist : (NSString *) folder{
    NSString *documents = [self documentPath];
    NSString *folderPath = [documents stringByAppendingPathComponent:folder];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //判断temp文件夹是否存在
    BOOL fileExists = [fileManager fileExistsAtPath:folderPath];
    if (!fileExists)
        [fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    return folderPath;
};

+(NSString *) createFolderIfNotExist : (NSString *) folder{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //判断temp文件夹是否存在
    BOOL fileExists = [fileManager fileExistsAtPath:folder];
    if (!fileExists)
        [fileManager createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:nil];
    return folder;
};

+(void) deleteFile : (NSString *) path{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //判断temp文件夹是否存在
    BOOL fileExists = [fileManager fileExistsAtPath:path];
    if(fileExists)
        [fileManager removeItemAtPath:path error:NULL];
};

+(void) createFile : (NSString *) path{
    [self createFile:path data:nil];
};

+(NSString *) cachePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
};

+(void) createFile:(NSString *)path data:(NSData *)data {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //判断temp文件夹是否存在
    BOOL fileExists = [fileManager fileExistsAtPath:path];
    if(!fileExists)
        [fileManager createFileAtPath:path contents:data attributes:nil];
}

+(NSString *) filePath : (NSString *) fileName folder:(NSString *)folder{
    NSString *path = [[self folderPathCreateIfNotExist:folder] stringByAppendingPathComponent:fileName];
    return path;
};

+(BOOL) isPathExist : (NSString *) path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:path];
};

+(NSString *) documentPath {
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
};

+(void) clearFolder : (NSString *) folder{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:folder error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject])) {
        [fileManager removeItemAtPath:[folder stringByAppendingPathComponent:filename] error:NULL];
    }
};

+(NSArray *) fileNamesFromPath : (NSString *) path{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:path error:NULL];
    return contents;
};


+(NSString*)fileMD5WithPath : (NSString*)path{
    return (__bridge_transfer NSString *)FileMD5HashCreateWithPath((__bridge CFStringRef)path, FileHashDefaultChunkSizeForReadingData);
}

+(void) rename:(NSString *) path old : (NSString *) oldName newName : (NSString *) newName{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    [fileManager moveItemAtPath:[path stringByAppendingPathComponent:oldName] toPath:[path stringByAppendingPathComponent:newName] error:nil];
};

+(NSString *) saveImage2Path : (UIImage *) image path : (NSString *) path {
    NSString *cacheName =  [[NSUUID UUID] UUIDString];
    NSString *filePath = [path stringByAppendingPathComponent:cacheName];
    
    [UIImageJPEGRepresentation(image,0.99f) writeToFile:filePath  atomically:YES];
    
    NSString *md5 = [self fileMD5WithPath:filePath];
    NSString *newFileName = [md5 stringByAppendingString:@".jpg"];
    
    NSArray *files = [self fileNamesFromPath:path];
    
    BOOL isExists = NO;
    
    for (NSString *fileName in files) {
        if ([fileName isEqualToString:newFileName]) {
            isExists = YES;
            break;
        }
    }
    
    if (isExists) {
        [self deleteFile:filePath];
    }else{
        [self rename:path old:cacheName newName:newFileName];
    }
    
    return newFileName;
};

@end
