//
//  taskPopupDetailOverlay.m
//  TaskFu
//
//  Created by Johannes du Plessis on 2013/04/16.
//  Copyright (c) 2013 Johannes du Plessis. All rights reserved.
//

#import "taskPopupDetailOverlay.h"

@implementation taskPopupDetailOverlay

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{

 CGContextRef contex = UIGraphicsGetCurrentContext();
 
 UIGraphicsPushContext(contex);
 CGContextBeginPath(contex);
 CGContextSetRGBStrokeColor(contex, 1, 1, 1, 1) ;
 CGContextSetRGBFillColor(contex, 1, 1, 1, 1);
 
 // Draw the rectangle
 
 CGRect backing = CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) ;
 [[UIColor blackColor] set] ;
 UIRectFill(backing);
    

    
    

    
    CGAffineTransform transform = CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0);
    CGContextSetTextMatrix(contex, transform);
    CGContextSetRGBFillColor(contex, 1, 1, 1, 1.0);
    CGContextSetLineWidth(contex, 10.0);
    CGContextSetCharacterSpacing(contex, 0);
    CGContextSetTextDrawingMode(contex, kCGTextFill);

    CGContextSetRGBFillColor(contex, 1, 1, 1, 1);
    

 
}


@end
