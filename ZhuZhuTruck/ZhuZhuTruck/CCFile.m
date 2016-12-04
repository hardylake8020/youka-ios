//
//  CCFile.m
//  shunshouzhuanqian
//
//  Created by CongCong on 16/4/5.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "CCFile.h"
//#import "Constants.h"
/**
 [""]	<#Description#>文件夹是否存在
 [""]	@param path <#path"] description#>
 [""] */
BOOL isFileExist(NSString* path)
{
    BOOL isDirectory=[[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory];
    return isDirectory;
}


/**
 [""]	<#Description#>创建文件夹
 [""]	@param path <#path"] description#>
 [""] */
void creatPath(NSString* path)
{
    if (!isFileExist(path))
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

BOOL saveImg(UIImage* img,NSString* fileName)
{
    NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@.jpg",fileName]];
    return [UIImageJPEGRepresentation(img, 0.2) writeToFile:jpgPath atomically:YES];
}

NSString* filePathByName(NSString* fileName)
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *pathname = [path objectAtIndex:0];
    return [pathname stringByAppendingPathComponent:fileName];
}

NSString* filePathByNameAndFileType(NSString* fileName,NSString * fileType)
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *pathname = [path objectAtIndex:0];
    return [pathname stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",fileName,fileType]];
}



