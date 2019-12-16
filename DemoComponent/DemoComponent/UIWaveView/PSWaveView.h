//
//  PSWaveView.h
//  Concubine
//
//  Created by open on 17/4/19.
//  Copyright © 2017年 pengsheng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^LPMeWaveViewBlock)(CGFloat currentY);


@interface PSWaveView : UIView

/**
 *  浪弯曲度
 */
@property (nonatomic, assign) CGFloat waveCurvature;

/**
 *  浪速
 */
@property (nonatomic, assign) CGFloat waveSpeed;

/**
 *  浪高
 */
@property (nonatomic, assign) CGFloat waveHeight;

/**
 *  实浪颜色
 */
@property (nonatomic, strong) UIColor *realWaveColor;

/**
 *  遮罩浪颜色
 */
@property (nonatomic, strong) UIColor *maskWaveColor;


@property (nonatomic, copy) KNMeWaveViewBlock waveBlock;

- (void)stopWaveAnimation;

- (void)startWaveAnimation;
@end
