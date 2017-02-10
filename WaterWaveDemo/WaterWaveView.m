//
//  WaterWaveView.m
//  WaterWaveDemo
//
//  Created by HuDaQian on 2017/1/26.
//  Copyright © 2017年 HuXiaoQian. All rights reserved.
//

#import "WaterWaveView.h"

@interface WaterWaveView(){
    CGFloat amplitude;//振幅
    CGFloat angularVelocity;//角速度
    CGFloat earlyPhase;//初相
    
    CGFloat viewHeight;
    CGFloat viewWidth;
    
    CGFloat speed;
    
    CGFloat progress;
    
    CADisplayLink *displayLink;
    
    CGFloat resultProgress;
    NSTimer *displayTimer;
    
    UILabel *resultLab;
}

@end

@implementation WaterWaveView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        
        viewWidth = self.frame.size.width;
        viewHeight = self.frame.size.height;
        
        amplitude = viewHeight/15;
        angularVelocity = 2*M_PI/(viewWidth*0.9);
        
        speed = 0.1f;
        
        displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(waveAnimation)];
        [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        
        displayTimer = [NSTimer scheduledTimerWithTimeInterval:0.005 target:self selector:@selector(progressAnimation) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:displayTimer forMode:NSRunLoopCommonModes];
        
        resultLab = [[UILabel alloc] initWithFrame:CGRectMake(0, viewHeight - 50, viewWidth, 30)];
        resultLab.textColor = [UIColor orangeColor];
        resultLab.font = [UIFont systemFontOfSize:12.0f];
        resultLab.contentMode = UIViewContentModeCenter;
        resultLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:resultLab];
    }
    return self;
}

- (void)progressAnimation {
    if (direction) {
        if (progress > resultProgress) {
            [displayTimer invalidate];
            return;
        }
        progress = progress+0.001;
    } else {
        if (progress < resultProgress) {
            [displayTimer invalidate];
            return;
        }
        progress = progress-0.001;
    }
 
    [self setNeedsDisplay];
}


- (void)waveAnimation {
    earlyPhase += speed;
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [self drawBackground];
    [self drawWaveShade];
    [self drawWave];
    resultLab.text = [NSString stringWithFormat:@"进度:%.1f%@",progress*100,@"%"];
}

- (void)drawWave {
    UIBezierPath *path = [UIBezierPath bezierPath];
    for (CGFloat x = 0.0; x<viewWidth; x++) {
        CGFloat y = amplitude*sin(angularVelocity*x + earlyPhase) + (1-progress)*(viewHeight + 2*amplitude);
        if (x == 0) {
            [path moveToPoint:CGPointMake(x, y-amplitude)];
        } else {
            [path addLineToPoint:CGPointMake(x, y-amplitude)];
        }
    }
    [path addLineToPoint:CGPointMake(viewWidth, viewHeight)];
    [path addLineToPoint:CGPointMake(0, viewHeight)];
    [path closePath];
    
    [[UIColor cyanColor] setFill];
    [path fill];
}
- (void)drawWaveShade {
    UIBezierPath *path = [UIBezierPath bezierPath];
    for (CGFloat x = 0.0; x<viewWidth; x++) {
        CGFloat y = amplitude*sin(angularVelocity*(x-viewWidth/3) + earlyPhase) + (1-progress)*(viewHeight + 2*amplitude);
        if (x == 0) {
            [path moveToPoint:CGPointMake(x, y-amplitude)];
        } else {
            [path addLineToPoint:CGPointMake(x, y-amplitude)];
        }
    }
    [path addLineToPoint:CGPointMake(viewWidth, viewHeight)];
    [path addLineToPoint:CGPointMake(0, viewHeight)];
    [path closePath];
    
    [[UIColor lightGrayColor] setFill];
    [path fill];
}

- (void)drawBackground {
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, viewWidth, viewHeight) cornerRadius:viewWidth/2];
    [path closePath];
    [[UIColor whiteColor] setFill];
    [path fill];
    [path addClip];
}

static bool direction = YES;
- (void)setEndProgress:(CGFloat)endProgress {
    if (progress > endProgress) {
        direction = NO;
    } else {
        direction = YES;
    }
    resultProgress = endProgress;
    if ([displayTimer isValid]) {
        displayTimer = [NSTimer scheduledTimerWithTimeInterval:0.005 target:self selector:@selector(progressAnimation) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:displayTimer forMode:NSRunLoopCommonModes];
    }
    [self setNeedsDisplay];
}

- (void)dealloc {
    [displayLink invalidate];
    displayLink = nil;
    [displayTimer invalidate];
    displayTimer = nil;
}

@end
