//
//  taskObject.h
//  TaskFu
//
//  Created by Johannes du Plessis on 2013/04/04.
//  Copyright (c) 2013 Johannes du Plessis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIGestureRecognizerSubclass.h>
#import <CoreText/CoreText.h>
#import "taskPopup.h"
#import "taskPopupDetail.h"

@interface taskObject : UIView {
    float oldX, oldY;
    BOOL dragging;
}

@property (nonatomic) BOOL lines ;
@property (nonatomic,strong) NSNumber *thisObjectID;
@property (nonatomic,strong) NSNumber *attachedObjectID ;
@property (nonatomic, strong) NSString *title ;
@property (nonatomic, strong) NSString *notes ;
@property (nonatomic, strong) NSString *theme ;
@property (assign) double nodeID ;
@property (nonatomic, strong) NSString *link ;
@property (nonatomic, strong) NSString *date ;
@property (nonatomic, strong) NSString *icon ;
@property (nonatomic,strong) NSNumber *primeObject ;
@property (nonatomic,strong) NSNumber *seenalert ;
@property (nonatomic) CGFloat radiusOne;
@property (nonatomic) CGFloat radiusTwo;
@property (nonatomic) CGFloat radiusThree;

-(void) drawCircle:(CGPoint)p withRadius:(CGFloat)radius inContext:(CGContextRef)contex ;
-(void) drawLine ;
-(void) updateLines ;
-(void) checkProximityWithChildren:(CGPoint)point ;
-(NSNumber*) getPrimeObjectID ;
-(void) createPopup ;
-(void) removePopups ;
-(void) shake ;
-(void) drawCircle:(CGPoint)p inContext:(CGContextRef)contex ;
- (UIColor *) colorWithHexString:(NSString *)str ;
-(BOOL) alertUserToObject ;
- (void) resizeCreate  ;
@end
