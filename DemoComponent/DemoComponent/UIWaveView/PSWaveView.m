//
//  PSWaveView.m
//  Concubine
//
//  Created by open on 17/4/19.
//  Copyright © 2017年 pengsheng. All rights reserved.
//

#import "PSWaveView.h"


@interface PSWaveViewxy : NSObject
@property (weak, nonatomic) id executor;
@end


@implementation PSMeWaveViewxy

- (void)callback {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

    [_executor performSelector:@selector(wave)];

#pragma clang diagnostic pop
}

@end


@interface PSWaveView ()

// 定时器
@property (nonatomic, strong) CADisplayLink *timer;
// 真实浪
@property (nonatomic, strong) CAShapeLayer *realWaveLayer;
// 遮罩浪
@property (nonatomic, strong) CAShapeLayer *maskWaveLayer;
// 图片偏移量
@property (nonatomic, assign) CGFloat offset;

@end


@implementation PSWaveView

- (instancetype)init {
    if (self = [super init]) {
        [self configureData];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configureData];
    }
    return self;
}

- (void)configureData {
    self.waveSpeed = 0.6;
    self.waveCurvature = 1.6;
    self.waveHeight = 8;
    self.realWaveColor = [UIColor knWhitePurpleColor];
    self.maskWaveColor = [UIColor whiteColor];
    [self.layer addSublayer:self.realWaveLayer];
    [self.layer addSublayer:self.maskWaveLayer];
}

- (CAShapeLayer *)realWaveLayer {
    if (!_realWaveLayer) {
        _realWaveLayer = [CAShapeLayer layer];
        CGRect frame = [self bounds];
        frame.origin.y = frame.size.height - self.waveHeight;
        frame.size.height = self.waveHeight;
        _realWaveLayer.frame = frame;
        _realWaveLayer.fillColor = self.realWaveColor.CGColor;
    }
    return _realWaveLayer;
}

- (CAShapeLayer *)maskWaveLayer {
    if (!_maskWaveLayer) {
        _maskWaveLayer = [CAShapeLayer layer];
        CGRect frame = [self bounds];
        frame.origin.y = frame.size.height - self.waveHeight + 10;
        frame.size.height = self.waveHeight;
        _maskWaveLayer.frame = frame;
        _maskWaveLayer.fillColor = self.maskWaveColor.CGColor;
    }
    return _maskWaveLayer;
}

- (void)setWaveHeight:(CGFloat)waveHeight {
    _waveHeight = waveHeight;
    CGRect frameR = [self bounds];
    frameR.origin.y = frameR.size.height - self.waveHeight;
    frameR.size.height = self.waveHeight;
    _realWaveLayer.frame = frameR;

    CGRect frameM = [self bounds];
    frameM.origin.y = frameM.size.height - self.waveHeight;
    frameM.size.height = self.waveHeight;
    _maskWaveLayer.frame = frameM;
}

- (void)startWaveAnimation {
    KNMeWaveViewxy *view_xy = [[KNMeWaveViewxy alloc] init];
    view_xy.executor = self;
    self.timer = [CADisplayLink displayLinkWithTarget:view_xy selector:@selector(callback)];
    [self.timer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)stopWaveAnimation {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)wave {
    self.offset += self.waveSpeed;
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = self.waveHeight;

    //真实浪
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, height);
    CGFloat y = 0.f;
    //遮罩浪
    CGMutablePathRef maskpath = CGPathCreateMutable();
    CGPathMoveToPoint(maskpath, NULL, 0, height);
    CGFloat maskY = 0.f;
    for (CGFloat x = 0.f; x <= width; x++) {
        y = height * sinf(0.01 * self.waveCurvature * x + self.offset * 0.045);
        CGPathAddLineToPoint(path, NULL, x, y);
        maskY = -y;
        CGPathAddLineToPoint(maskpath, NULL, x, maskY);
    }

    //变化的中间Y值
    CGFloat centX = self.bounds.size.width / 2;
    CGFloat CentY = height * sinf(0.01 * self.waveCurvature * centX + self.offset * 0.045);
    if (self.waveBlock) {
        self.waveBlock(CentY);
    }

    CGPathAddLineToPoint(path, NULL, width, height);
    CGPathAddLineToPoint(path, NULL, 0, height);
    CGPathCloseSubpath(path);
    self.realWaveLayer.path = path;
    self.realWaveLayer.fillColor = self.realWaveColor.CGColor;
    CGPathRelease(path);

    CGPathAddLineToPoint(maskpath, NULL, width, height);
    CGPathAddLineToPoint(maskpath, NULL, 0, height);
    CGPathCloseSubpath(maskpath);
    self.maskWaveLayer.path = maskpath;
    self.maskWaveLayer.fillColor = self.maskWaveColor.CGColor;
    CGPathRelease(maskpath);
}

@end
