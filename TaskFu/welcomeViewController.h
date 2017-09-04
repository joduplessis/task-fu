//
//  welcomeViewController.h
//  TaskFu
//
//  Created by Johannes du Plessis on 2013/04/13.
//  Copyright (c) 2013 Johannes du Plessis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "addNode.h" 
#import "taskNode.h" 

@interface welcomeViewController : UIViewController <CustomClassDelegate> {
    NSString *background ;
    NSString *heading ;
    NSString *theme ;
    double taskNodeID ;
    BOOL theAppHasAlreadyLoaded ;
    int centerObjectOnStage ;
    int goToView ;
}

@property (nonatomic, strong) IBOutlet UIView *nodeBoard ;
@property (nonatomic, strong) IBOutlet UILabel *heading ;
@property (nonatomic, strong) IBOutlet UILabel *subheading ;
@property (nonatomic, strong) IBOutlet UIImageView *nodeBoardBacking ;

- (IBAction) startApp:(id)sender;
- (void) setCenterObjectOnStage:(int)object ;
- (void) startAppWithID ;
- (void) sayHello:(taskNode *)node;
- (void) clearModules;
- (int) updateBadgeNumber;

@end
