//
//  addNode.h
//  TaskFu
//
//  Created by Johannes du Plessis on 2013/04/14.
//  Copyright (c) 2013 Johannes du Plessis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "taskNode.h"

@protocol CustomClassDelegate <NSObject>
-(void) sayHello:(taskNode *)node;
- (void) setCenterObjectOnStage:(int)object ;
@end

@interface addNode : UIView {
    int taskCounter ;
}

@property (nonatomic, assign) id<CustomClassDelegate> delegate;
@property (assign) int centerObject ;

- (UIColor *) colorWithHexString:(NSString *)str ;
- (void) createTaskNodeNewExisting:(double)nid bg:(NSString*)background th:(NSString*)theme ti:(NSString*)title ;
- (void) createTaskNodeNew ;
- (void) populateNodes ;
-(void) createNewTaskNode ;
- (void) moveLeft ;
- (void) moveRight ;
- (void) clearModules ;
- (void) makeTheCenterObjectCenterOnStage ;
-(void) clearModules ;
@end
