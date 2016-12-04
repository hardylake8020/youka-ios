//
//  CCToast.h
//  shunshouzhuanqian
//
//  Created by CongCong on 16/4/27.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define DEFAULT_DISPLAY_DURATION 4.0f

@interface CCToast : NSObject{
    NSString *text;
    UIButton *contentView;
    CGFloat  duration;
}
+ (void)showWithText:(NSString *) text_;
+ (void)showWithText:(NSString *) text_
            duration:(CGFloat)duration_;

+ (void)showWithText:(NSString *) text_
           topOffset:(CGFloat) topOffset_;
+ (void)showWithText:(NSString *) text_
           topOffset:(CGFloat) topOffset
            duration:(CGFloat) duration_;

+ (void)showWithText:(NSString *) text_ bottomOffset:(CGFloat) bottomOffset_;
+ (void)showWithText:(NSString *) text_ bottomOffset:(CGFloat) bottomOffset_ duration:(CGFloat) duration_;
@end
