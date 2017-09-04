//
//  taskObjectLines.m
//  TaskFu
//
//  Created by Johannes du Plessis on 2013/04/12.
//  Copyright (c) 2013 Johannes du Plessis. All rights reserved.
//

#import "taskObjectLines.h"
#import "taskObject.h"

@implementation taskObjectLines {
    int count  ;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.lines = YES ;
    }
    return self;
}

- (CGPoint) getObjectPoint:(NSNumber*)objectID {
    
    CGPoint objectPoint = CGPointMake(0, 0) ;
    
    for (taskObject *subview in self.superview.subviews) {
        
        if ([subview isKindOfClass:[taskObject class]]) {
            
            taskObject *tempObject = subview;
            
  
            
            
            
            if ( [tempObject.thisObjectID isEqualToNumber:objectID] ) {
                
                CGFloat originX = tempObject.frame.size.width/2 + tempObject.frame.origin.x ;
                CGFloat originY = tempObject.frame.size.height/2 + tempObject.frame.origin.y ;
                
                objectPoint = CGPointMake(originX, originY);
                
            }
            
            
        }
        
    }
    
    return objectPoint ;
    
}

- (void)drawRect:(CGRect)rect
{

        
        CGContextRef contex = UIGraphicsGetCurrentContext() ;
        CGContextBeginPath(contex);
        CGContextSetRGBStrokeColor(contex, 1, 1, 1, 1) ;
        CGContextSetRGBFillColor(contex, 1, 1, 1, 1);
        
        for (taskObject *subview in self.superview.subviews) {
     
            if ([subview isKindOfClass:[taskObject class]]) {
                
                taskObject *tempObject = subview;
                
                if ( subview.primeObject != [NSNumber numberWithInt:1] ) {
                    
                    
                    if (tempObject.attachedObjectID == nil) {
                        
                        
                       subview.attachedObjectID = subview.thisObjectID;
                       tempObject.attachedObjectID = tempObject.thisObjectID;
                        
                        NSLog(@"subview.primeObject > %@ ", subview.primeObject);
                        NSLog(@"subview.attachedObjectID > %@ ", subview.attachedObjectID);
                        NSLog(@"subview.thisObjectID > %@ ", subview.thisObjectID);
                        
                        NSLog(@"tempObject.primeObject > %@ ", tempObject.primeObject);
                        NSLog(@"tempObject.attachedObjectID > %@ ", tempObject.attachedObjectID);
                        NSLog(@"tempObject.thisObjectID > %@ ", tempObject.thisObjectID);
                        
                        
                    }
                    
         

                    
                    if ( subview.thisObjectID != tempObject.attachedObjectID ) {
                    
                        CGPoint destinationObject = [self getObjectPoint:tempObject.attachedObjectID] ;
                        
                        CGFloat destinationX = destinationObject.x ;
                        CGFloat destinationY = destinationObject.y ;
                        
                        CGFloat originX = subview.frame.size.width/2 + subview.frame.origin.x ;
                        CGFloat originY = subview.frame.size.height/2 + subview.frame.origin.y ;
                        

                        
                        if ([subview.attachedObjectID isEqualToNumber:[self getPrimeObjectID]]) {
                            CGContextSetLineWidth(contex, 8.0);
                        } else {
                            CGContextSetLineWidth(contex, 3.0);
                        }
                        
 
                        
                        CGContextMoveToPoint(contex, destinationX, destinationY);
                        CGContextAddLineToPoint(contex, originX, originY);
                        CGContextStrokePath(contex);
                        
                    }
                //} //else {
                    //NSLog(@"tempObject.attachedObjectID is null > %@ ", tempObject.attachedObjectID);
                //}
                
                }
                

                
            }
            
        }
        
        UIGraphicsPopContext();
  
}

-(NSNumber*) getPrimeObjectID {
    NSNumber *objectID  ;
    for (taskObject *subview in self.superview.subviews) {
        if ([subview isKindOfClass:[taskObject class]]) {
            if ([subview.primeObject integerValue]==[[NSNumber numberWithInt:1] integerValue]) {
                objectID = subview.thisObjectID ;
            }
        }
    }
    return objectID ;
}


@end
