//
//  nodeTitleTextInput.h
//  TaskFu
//
//  Created by Johannes du Plessis on 2013/04/14.
//  Copyright (c) 2013 Johannes du Plessis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface nodeTitleTextInput : UIView {
    CGFloat animatedDistance;
}

@property (assign) double taskNodeID ;
@property (nonatomic,strong) NSString *textFieldText ;
@property (assign) int landscapeAdd ;

- (IBAction)save_clicked:(id)sender;
- (IBAction)cancel_clicked:(id)sender;

@end
