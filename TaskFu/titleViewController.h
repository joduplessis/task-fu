//
//  titleViewController.h
//  TaskFu
//
//  Created by Johannes du Plessis on 2013/04/18.
//  Copyright (c) 2013 Johannes du Plessis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface titleViewController : UIViewController <UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{

}

@property (nonatomic,strong) NSString * message ;
@property (nonatomic,strong) NSString * valueToEdit ;
@property (nonatomic,strong) NSString * valueToEditPlaceholder ;
@property (assign) double nodeID ;
@property (nonatomic,strong) NSNumber * taskID ;

@property (strong, nonatomic) IBOutlet UITextField *mainTextField;

- (IBAction)hitReturn:(id)sender;
- (IBAction)anytime:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *anytimeButton;

@property (strong, nonatomic) IBOutlet UITableView *tableControl;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (strong, nonatomic) IBOutlet UIDatePicker *dateControl;
- (IBAction)saveButtonAction:(id)sender;
- (int) updateBadgeNumber ;
- (int) getDateArrayIndex:(NSDate*)date ;



@end
