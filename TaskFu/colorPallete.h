//
//  colorPallete.h
//  TaskFu
//
//  Created by Johannes du Plessis on 2013/04/15.
//  Copyright (c) 2013 Johannes du Plessis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface colorPallete : UIView {
    NSArray *  colors ;
}

@property (assign) double taskNodeID ;
@property (nonatomic,strong) NSString *theme ;
@property (nonatomic,strong) NSString *current ;

-(void)setColor:(UITapGestureRecognizer *)gesture ;
-(void)moveit ;

@end
