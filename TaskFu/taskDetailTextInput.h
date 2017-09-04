//
//  taskDetailTextInput.h
//  TaskFu
//
//  Created by Johannes du Plessis on 2013/04/17.
//  Copyright (c) 2013 Johannes du Plessis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface taskDetailTextInput : UIView {
    CGFloat animatedDistance;
}

@property (assign) double nodeID ;
@property (nonatomic,strong) NSNumber *taskID ;
@property (nonatomic,strong) NSString *targetToUpdate ;
@property (nonatomic,strong) NSString *textFieldText ;

- (IBAction)save_clicked:(id)sender;
- (IBAction)cancel_clicked:(id)sender;

@end
