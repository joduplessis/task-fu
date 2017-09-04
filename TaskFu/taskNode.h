//
//  taskNode.h
//  TaskFu
//
//  Created by Johannes du Plessis on 2013/04/14.
//  Copyright (c) 2013 Johannes du Plessis. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface taskNode : UIView 

@property (assign) double taskNodeID ;
@property (assign) int taskNodeIDOrder ;
@property (assign) int radius_add ;
@property (nonatomic,strong) NSString *heading;
@property (nonatomic,strong) NSString *theme ;
@property (nonatomic,strong) NSString *background ;

- (int) getNumberOfBoards ;
- (void) checkIfCurrentNode ;
- (void) moveLeft ;
- (void) moveRight ;
- (void) clearModules ;
-(void) deleteTasks ;
- (int) getTaskNumber ;
- (UIImage *) imageWithSize:(UIImage*)image scaledToSize:(CGSize)newSize;

@end
