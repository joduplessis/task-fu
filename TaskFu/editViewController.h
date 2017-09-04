//
//  editViewController.h
//  TaskFu
//
//  Created by Johannes du Plessis on 2013/04/17.
//  Copyright (c) 2013 Johannes du Plessis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface editViewController : UIViewController <UITableViewDelegate,UITableViewDataSource> {
    NSString *valueToEdit ;
    NSString *valueToEditPlaceholder ;
    float x ;
    float y ;
    int numberOfCandidates ;
    
}
- (IBAction)deleteTask:(id)sender;

@property (assign) double boardID ;
@property (nonatomic,strong) NSNumber *taskID ;
@property (strong, nonatomic) IBOutlet UITableView *tableControl;

- (void) loadTableData ;
- (void) rewireTasksAfterDelete ;
- (NSNumber *) getBestCandidate ;
- (void) deleteActualTask:(NSNumber*)object ;
- (void) setXYOfCandidate:(NSNumber*)candidate ;
- (void) setAttachIDOfChildren:(NSNumber*)candidate ;
- (NSNumber*) getPrimeObjectID;
- (NSNumber *) getBestCandidateForPrime;
- (void) makeCandidatePrime:(NSNumber*)object;
- (NSNumber*) getAttachedObjectID ;

@end
