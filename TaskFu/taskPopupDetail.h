//
//  taskPopupDetail.h
//  TaskFu
//
//  Created by Johannes du Plessis on 2013/04/13.
//  Copyright (c) 2013 Johannes du Plessis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface taskPopupDetail : UIView {
    NSString *link ;
}

@property (nonatomic,strong) NSNumber *taskID ;
@property (nonatomic,strong) NSString *title ;
@property (nonatomic,strong) NSString *date ;
@property (nonatomic,strong) NSString *icon ;
@property (nonatomic,strong) NSString *theme ;
@property (nonatomic,strong) NSString *link ;
@property (nonatomic,strong) NSString *notes ;
@property (nonatomic,strong) NSString *wtf ;
@property (assign) double nodeID ;

- (UIColor *) colorWithHexString:(NSString *)str;
- (int) updateBadgeNumber;

@end
