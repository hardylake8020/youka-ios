//
//  QnUploadManager.m
//  ZhengChe
//
//  Created by CongCong on 16/9/9.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "QnUploadManager.h"
#import <QNUploadManager.h>
#import <QNResponseInfo.h>
#import "NSDictionary+Tool.h"
#import "NSMutableDictionary+Tool.h"
#import "NSString+Tool.h"
#import "CCUserData.h"
#import "Constants.h"
#import "CCFile.h"
#import "DBManager.h"
#import "HttpRequstManager.h"

@interface QnUploadManager (){
    QNUploadManager* qnuploadManager;
    dispatch_queue_t serialQueue;
    NSString *QN_Token;
    BOOL _isRuning;
    BOOL _isVoiceUploading;
    NSTimer *_timer;
    NSInteger _count;
    DBManager *_dbManager;
}
@property (nonatomic, strong) NSMutableArray *photosArray;
@property (nonatomic, copy)   NSString *qn_token;
@property (nonatomic, copy)   NSString *voice_token;
@property (nonatomic, strong) NSMutableArray *voicesArray;
@end

@implementation QnUploadManager                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
+(id)sharedManager
{
    static id sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        serialQueue = dispatch_queue_create("myThreadQueueImageUpload", DISPATCH_QUEUE_SERIAL);
        qnuploadManager = [[QNUploadManager alloc]init];
        _dbManager = [DBManager sharedManager];
//        [self uploadImage];
//        [self upLoadVoice];
//        [self runClock];
    }
    return self;
}
- (NSString *)qn_token{
    if (!_qn_token) {
        _qn_token = qn_token();
    }
    return _qn_token;
}

- (NSMutableArray *)photosArray{
    if (!_photosArray) {
        _photosArray = [NSMutableArray array];
    }
    return _photosArray;
}
- (NSMutableArray *)voicesArray{
    if (!_voicesArray) {
        _voicesArray = [NSMutableArray array];
    }
    return _voicesArray;
}
- (void)runClock{
    [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(uploadImage) userInfo:nil repeats:YES];
    [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(upLoadVoice) userInfo:nil repeats:YES];
}


- (void)uploadImage{
    //CCLog(@"time  out  15s");
    [self.photosArray removeAllObjects];
    [self.photosArray addObjectsFromArray:[_dbManager readAllUnUploadPhotos]];
    if ([self.qn_token isEmpty]||!self.qn_token) {
        _qn_token  = nil;
        [self getToken];
        return;
    }
    if (self.photosArray.count>0&&!_isRuning) {
        _isRuning = YES;
        [self upLoadFile:self.photosArray[0] token:self.qn_token];
    }
}

- (void)upLoadVoice{
    [self.voicesArray removeAllObjects];
    [self.voicesArray addObjectsFromArray:[_dbManager readAllUnUploadVoices]];
    if (self.voicesArray.count>0&&!_isVoiceUploading) {
        _isVoiceUploading = YES;
        [self getVoiceToken:self.voicesArray[0]];
    }
}

- (void)upLoadFile:(NSString*)photoName token:(NSString *)token{
    
    NSString *filePath = filePathByNameAndFileType(photoName, @".jpg");
    __weak typeof(self) _Self = self;
    /*创建一个串行队列*/
    dispatch_async(serialQueue, ^{
//        CCLog(@"%@",filePath);
//        CCLog(@"%@",token);
        [qnuploadManager putFile :filePath key:photoName token:token complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp){
            CCLog(@"%@", info);
            CCLog(@"%@", resp);
            if(info.isOK){
                CCLog(@"=======>上传成功");
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_dbManager photoUploadSucceedWithPhotoName:photoName];
                    NSMutableArray *localArray = [NSMutableArray arrayWithArray:[_dbManager readAllUnUploadPhotos]];
                    //回调或者说是通知主线程刷新，
                    if (localArray.count>0) {
//                        CCLog(@"-------->还剩%lu张图片",(unsigned long)localArray.count);
                        [_Self upLoadFile:localArray[0] token:_Self.qn_token];
                    }
                    else{
                        _isRuning = NO;
                        return;
                    }
                });
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (info.statusCode==401) {
                        save_qntoken(@"");
                        _qn_token = nil;
                        [_Self getToken];
                        CCLog(@"token 失效---》code%d",info.statusCode);
                        _isRuning = NO;
                        return;
                    }
                    else if(info.statusCode==-4){
                        [_dbManager photoDeletedWithPhotoName:photoName];
                        NSMutableArray *localArray = [NSMutableArray arrayWithArray:[_dbManager readAllUnUploadPhotos]];
                        //回调或者说是通知主线程刷新，
                        if (localArray.count>0) {
                            CCLog(@"-------->还剩%lu张图片",(unsigned long)localArray.count);
                            [_Self upLoadFile:localArray[0] token:_Self.qn_token];
                        }
                        else{
                            _isRuning = NO;
                            return;
                        }
                    }else{
                        CCLog(@"上传失败---》code%d",info.statusCode);
                        _isRuning = NO;
                        return;
                    }
                });
            }
        } option:nil];
    });
}

- (void)getToken{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    [parameters put:accessToken() key:ACCESS_TOKEN];
    
    [[HttpRequstManager requestManager] getWithRequestBodyString:QN_IMAGE_TOKEN parameters:parameters resultBlock:^(NSDictionary *result, NSError *error) {
        if (error) {
            CCLog(@"err%@",error.localizedDescription);
        }
        else{
            NSString *token = [result objectForKey:@"token"];
            _qn_token = token;
            save_qntoken(token);
        }
    }];
}

- (void)getVoiceToken:(NSString *)fileName{
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    [parameters put:accessToken() key:ACCESS_TOKEN];
    [parameters put:fileName key:@"mp3_key"];
    [[HttpRequstManager requestManager] getWithRequestBodyString:QN_VOICE_TOKEN parameters:parameters resultBlock:^(NSDictionary *result, NSError *error) {
        if (error) {
            CCLog(@"err%@",error.localizedDescription);
            _isVoiceUploading = NO;
        }
        else{
            NSString *token = [result objectForKey:@"token"];
            _voice_token = token;
            [self uploadVoiceFile:fileName];
        }
    }];
}


- (void)uploadVoiceFile:(NSString *)fileName{
    
    if (!_voice_token||[_voice_token isEmpty]) {
        _isVoiceUploading = NO;
        return;
    }
    dispatch_async(serialQueue, ^{
        CCLog(@"%@",fileName);
        CCLog(@"path%@",filePathByName(fileName));
        [qnuploadManager putFile:filePathByName(fileName) key:fileName token:_voice_token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            if (info.isOK) {
                CCLog(@"info:%@",info);
                CCLog(@"%@", resp);
                CCLog(@"=======>上传成功");
                dispatch_async(dispatch_get_main_queue(), ^{
                    _voice_token = nil;
                    [_dbManager voiceUploadSucceedWithVoiceName:fileName];
                    NSArray *leftVoices = [_dbManager readAllUnUploadPhotos];
                    if (leftVoices.count>0) {
                        [self getVoiceToken:leftVoices[0]];
                    }else{
                        _isVoiceUploading = NO;
                    }
                });
            }else {
                CCLog(@"info:%@",info.error);
                CCLog(@"上传失败---》code%d",info.statusCode);
                dispatch_async(dispatch_get_main_queue(), ^{
                    _voice_token = nil;
                    if (info.error.code == 614||info.error.code == 260) {
                        CCLog(@"=======>文件不存在");
                        [_dbManager voiceDeleteWithVoiceName:fileName];
                    }
                    NSArray *leftVoices = [_dbManager readAllUnUploadPhotos];
                    if (leftVoices.count>0) {
                        [self uploadVoiceFile:leftVoices[0]];
                    }else{
                        _isVoiceUploading = NO;
                    }
                });
            }
        } option:nil];
    });

}

@end
