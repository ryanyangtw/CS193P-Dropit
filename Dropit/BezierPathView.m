//
//  BezierPathView.m
//  Dropit
//
//  Created by Ryan on 2015/1/29.
//  Copyright (c) 2015年 Ryan. All rights reserved.
//

#import "BezierPathView.h"

@implementation BezierPathView


- (void)setPath:(UIBezierPath *)path{

    _path = path;
    [self setNeedsDisplay];
}





// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    

    [[UIColor orangeColor] setStroke];
    [self.path stroke];
}


@end
