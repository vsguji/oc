//
//  UIButton+touch.h
//  DemoComponent
//
//  Created by lipeng on 2019/4/10.
//  Copyright © 2019 lipeng. All rights reserved.
//
// sendAction:to:forEvent: 解决多次点检UIButton问题
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#define defaultInterval .7 // 默认间隔时间
NS_ASSUME_NONNULL_BEGIN

@interface UIButton (touch)

@property (nonatomic,assign) NSTimeInterval timeInterval;

@end

NS_ASSUME_NONNULL_END
