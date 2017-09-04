//
//  ViewController.m
//  TaskFu
//
//  Created by Johannes du Plessis on 2013/04/04.
//  Copyright (c) 2013 Johannes du Plessis. All rights reserved.
//

#import "ViewController.h"
#import "taskObject.h"
#import "taskObjectLines.h"
#import "taskPopup.h"
#import "editViewController.h"
#import <Social/Social.h>
#import "globalVariables.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    stageHasLoaded = 0;
    
    // move the keyboard in place
    
    isLandscape = NO ;
    
    CGRect frame = self.keyboardToolbar.frame;
    frame.origin.y = 200;
    frame.origin.x = 0;
    self.keyboardToolbar.frame = frame;
    
    [self.drawImage setImage:[UIImage imageNamed:self.boardBackground]] ;
    
    self.taskTitle.delegate = self;
    self.objectCounter = 0 ;
    self.title = self.boardTitle ;
    
    // remove the popup if they tap on object loader
    
    UITapGestureRecognizer *olTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(olTapping:)];
    [olTap setNumberOfTapsRequired:1];
    [self.objectHolder addGestureRecognizer:olTap];
    
}

-(void) appLoader {
    
    // remove any objects if there are any
    
    for (taskObject* subview in self.objectHolder.subviews) {
        if ([subview isKindOfClass:[taskObject class]]) {
            [subview removeFromSuperview];
        }
    }
    
    for (taskObjectLines* subview in self.objectHolder.subviews) {
        if ([subview isKindOfClass:[taskObjectLines class]]) {
            [subview removeFromSuperview];
        }
    }
    
    // Lines that connect the nodes
    
    CGRect lineFrame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);
    self.linesView = [[taskObjectLines alloc] initWithFrame: lineFrame];
    self.linesView.backgroundColor = [UIColor clearColor];
    self.linesView.autoresizesSubviews = NO ;
    self.linesView.autoresizingMask = UIViewAutoresizingNone ;
    
    [self.objectHolder addSubview:self.linesView];
    
    [self populateTasks] ;
    
}

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated] ;

    [ self removePopups];
    
    [self appLoader] ;
    
    
    
    areTherePopupsOpen = NO ;
    
    [self updateBadgeNumber] ;
    
    
    
    
    
    
    
    
    
}


- (int) updateBadgeNumber {
    
    int taskCounter = 0 ;
    
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Task"];
    NSArray *tasks = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    for (NSManagedObject *info in tasks) {
        
        NSNumber *seenalert = [info valueForKey:@"seenalert"] ;
        NSString *date = [info valueForKey:@"time"] ;
        
        if (![date isEqual: @"Anytime"]) {
            
            // Here we convert our date string to a date object
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"cccc, MMM d, hh:mm aa y";
            
            NSDate *dateFromString = [[NSDate alloc] init];
            dateFromString = [formatter dateFromString:date];
            
            NSDate *todayDeadline = [NSDate date] ;
            NSDate *thenDeadline = dateFromString ;
            NSComparisonResult result = [todayDeadline compare:thenDeadline];
            
            // here we set notifcations for dates, only if they have no yet seen dates
            if ( result == NSOrderedDescending ) {
                
                if ( ([seenalert isEqualToNumber:[NSNumber numberWithInt:0]]) || (seenalert==nil) ) {
                    
                    taskCounter++ ;
                    
                }
                
            }
            
        }
        
    }
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: taskCounter];
    
    return taskCounter ;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/* ******************************************************************************** */
/* ******************************************************************************** */
/* ******************************************************************************** */
/* DRAGGING STUFF                                                                   */
/* ******************************************************************************** */
/* ******************************************************************************** */

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (areTherePopupsOpen == NO) {
    
        UITouch *touch = [touches anyObject];
        
        int anybody = 0 ;
        
        CGPoint location = [touch locationInView:self.objectHolder];
        
        for (taskObject* subview in self.objectHolder.subviews) {
            if ([subview isKindOfClass:[taskObject class]]) {
                if ([touch view] == subview) {
                    
                    anybody = 1 ;
                    
                    [subview resizeCreate];
                    
                    [self removePopups] ;
                    
                }
            } 
        }
        
        // Now we move EVERYBODY
        
        if (anybody == 0) {
            
            for (taskObject* subview in self.objectHolder.subviews) {
                if ([subview isKindOfClass:[taskObject class]]) {
                    
                    allDragX = location.x  ;
                    allDragY = location.y ;
                    
                }
            }
        }
        
    }

}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (areTherePopupsOpen == NO) {
        
        int anybody = 0 ;
        
        UITouch *touch = [touches anyObject];
        
        CGPoint location = [touch locationInView:self.objectHolder];
        
        for (taskObject* subview in self.objectHolder.subviews) {
            if ([subview isKindOfClass:[taskObject class]]) {
                if ([touch view] == subview) {
                    
                    subview.center = location;
                    
                    anybody = 1 ;
                    
                    [self updateLines] ;
                    [self removePopups] ;
                    [self checkProximityWithChildren:subview];
                    
                }
                
            }
        }
        
        // Now we move EVERYBODY
        
        if (anybody == 0) {

            for (taskObject* subview in self.objectHolder.subviews) {
                if ([subview isKindOfClass:[taskObject class]]) {
                    
                    float x = location.x - (allDragX - subview.center.x) ;
                    float y = location.y - (allDragY - subview.center.y) ;
                    
                    subview.center = CGPointMake(x, y);
                        
                    [self updateLines] ;
                    [self removePopups] ;
                    [self checkProximityWithChildren:subview];
                      
                }
            }
            
            allDragX = location.x  ;
            allDragY = location.y ;
        }
        
    }
    
    return;
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (areTherePopupsOpen == NO) {
        
        UITouch *touch = [touches anyObject];
        
        int anybody = 0 ;
        
        CGPoint location = [touch locationInView:self.objectHolder];
        
        for (taskObject* subview in self.objectHolder.subviews) {
            if ([subview isKindOfClass:[taskObject class]]) {
                if ([touch view] == subview) {
                    
                    anybody = 1;
                    
                    // start animation for the drag
                    
                    CGFloat start_x = subview.transform.a;
                    CGFloat start_y = subview.transform.d;
                    
                    CGAffineTransform start = CGAffineTransformMakeScale(start_x, start_y);
                    
                    CGFloat end_x = subview.transform.a + 0.1;
                    CGFloat end_y = subview.transform.d + 0.1;
                    
                    CGAffineTransform end = CGAffineTransformMakeScale(end_x, end_y);
                    
                    [UIView beginAnimations:nil context:(__bridge_retained void *)subview];
                    [UIView setAnimationDuration:0.3];
                    [UIView setAnimationDelegate:self];
                    [UIView setAnimationDidStopSelector:@selector(growAnimationDidStop:finished:context:)];
                    subview.transform = end;
                    [UIView commitAnimations];
                    
                    // end animation for the drag
                    
                    [UIView beginAnimations:nil context:(__bridge_retained void *)subview];
                    [UIView setAnimationDuration:0.3];
                    [UIView setAnimationDelegate:self];
                    [UIView setAnimationDidStopSelector:@selector(growAnimationDidStop:finished:context:)];
                    subview.transform = start;
                    [UIView commitAnimations];
                    
                    // Here we save the position of the task
                    
                    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
                    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Task"];
                    NSArray *tasks = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
                    
                    for (NSManagedObject *info in tasks) {
                        double temp = [[info valueForKey:@"node"] doubleValue] ;
                        
                        if (subview.nodeID == temp) {
                            
                            if ([subview.thisObjectID isEqualToNumber:[info valueForKey:@"id"]]) {
                                
                                NSLog(@"%@",[info valueForKey:@"id_attached"]) ;
                                NSLog(@"%@",subview.thisObjectID) ;
                                [info setValue:subview.attachedObjectID forKey:@"id_attached"];
                                NSLog(@"%@",[info valueForKey:@"id_attached"]) ;
                                NSLog(@"%@",[info valueForKey:@"id"]) ;
                                NSLog(@"%@",[info valueForKey:@"title"]) ;  
                                
                                [info setValue:[NSNumber numberWithFloat:subview.center.x] forKey:@"x"];
                                [info setValue:[NSNumber numberWithFloat:subview.center.y] forKey:@"y"];
                               
                                
                            }
                            
                        }
                        

                    }
                    
                    NSError *error = nil;
                    
                    if (![managedObjectContext save:&error]) {
                        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
                    }
                    
                }
            }
        }
        
        // Now we move EVERYBODY
        
        if (anybody == 0) {
            
            for (taskObject* subview in self.objectHolder.subviews) {
                if ([subview isKindOfClass:[taskObject class]]) {
                    
                    // Here we save the position of the task
                    
                    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
                    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Task"];
                    NSArray *tasks = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
                    
                    for (NSManagedObject *info in tasks) {
                        double temp = [[info valueForKey:@"node"] doubleValue] ;
                        if ( (subview.nodeID == temp) && ([subview.thisObjectID isEqualToNumber:[info valueForKey:@"id"]]) ) {
                            [info setValue:[NSNumber numberWithFloat:subview.center.x] forKey:@"x"];
                            [info setValue:[NSNumber numberWithFloat:subview.center.y] forKey:@"y"];
                            [info setValue:subview.attachedObjectID forKey:@"id_attached"];
                        }
                    }
                    
                    NSError *error = nil;
                    
                    if (![managedObjectContext save:&error]) {
                        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
                    }
                    
                }
            }
            
            allDragX = location.x  ;
            allDragY = location.y ;
        }
        
    }
        
        

    
}

/* ******************************************************************************** */
/* ******************************************************************************** */
/* ******************************************************************************** */
/* ******************************************************************************** */
/* ******************************************************************************** */

- (void) removePopups {
    for (taskPopup *subview in self.objectHolder.subviews) {
        if ([subview isKindOfClass:[taskPopup class]]) {
            [subview removeFromSuperview] ;
        }
    }
    for (taskObject *subview in self.objectHolder.subviews) {
        if ([subview isKindOfClass:[taskObject class]]) {
            [subview.layer removeAllAnimations] ;
        }
    }
    areTherePopupsOpen = NO ;
}

- (void) checkProximityWithChildren:(taskObject *)sv {
     
     for (taskObject *subview in self.objectHolder.subviews) {
         if ([subview isKindOfClass:[taskObject class]]) {
     
             taskObject *tempObject = subview;
     
             if (tempObject.thisObjectID != sv.thisObjectID) {
     
                 CGFloat otherObjectX = tempObject.center.x ;
                 CGFloat otherObjectY = tempObject.center.y ;
                 CGFloat thisObjectX = sv.center.x ;
                 CGFloat thisObjectY = sv.center.y ;
     
                 double dx = (otherObjectX - thisObjectX) ;
                 double dy = (otherObjectY - thisObjectY) ;
                 double dist = sqrt(dx*dx + dy*dy) ;
     
                 if ( dist < (tempObject.frame.size.width/2) ) {
     
                     sv.attachedObjectID = tempObject.thisObjectID ;
                     
                     [sv setNeedsDisplay] ;
                     
                 }
     
             }
     
         }
     }
    
}

-(NSNumber *) getPrimeObjectID {
    
    NSNumber *objectID  ;
    
    for (taskObject *subview in self.objectHolder.subviews) {
        if ([subview isKindOfClass:[taskObject class]]) {
            if ([subview.primeObject isEqualToNumber:[NSNumber numberWithInt:1]]) {
                objectID = subview.thisObjectID ;
            }
        }
    }
    
    return objectID ;
    
}

// Here we go through all the object and find the highest ID on stage
// We use that as a starting point to get the ID for the next task
// Just so that we don't duplicate anything inside the DM
// We also add one here so we don't have to do it later

- (NSNumber*)getHighestTaskIDOnStage {
    
    int highest_value_found = 0;
    
    for (taskObject *subview in self.objectHolder.subviews) {
        if ([subview isKindOfClass:[taskObject class]]) {
            if ( highest_value_found < [subview.thisObjectID intValue]) {
                highest_value_found = [subview.thisObjectID intValue] ;
            }
        }
    }
    
    return [NSNumber numberWithInt:highest_value_found+1] ;
    
}

// This is called when a user opens the node
// Here we retrieve all of the tasks
// Please note this is the same as the create task

-(void) populateTasks {
    
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Task"];
    NSArray *tasks = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    for (NSManagedObject *info in tasks) {
        
        // start of the object pulled out of data
        
        if ( [[info valueForKey:@"node"] doubleValue] == self.boardID ) {
            
            CGRect circleFrame = CGRectMake(0, 0, 130,130);
            
            taskObject *circleView = [[taskObject alloc] initWithFrame: circleFrame];
            
            circleView.backgroundColor = [UIColor clearColor];
            circleView.autoresizesSubviews = NO ;
            circleView.autoresizingMask = UIViewAutoresizingNone ;
            
            

        
            circleView.attachedObjectID = [info valueForKey:@"id_attached"] ;
            circleView.thisObjectID = [info valueForKey:@"id"] ;
            
            if (circleView.attachedObjectID == nil) {
                
                circleView.attachedObjectID = circleView.thisObjectID;
                
                NSLog(@"id > %@ ", circleView.thisObjectID);
                NSLog(@"id_attached > %@ ", circleView.attachedObjectID);

                
            }
            

            circleView.title = [info valueForKey:@"title"] ;
            circleView.date = [info valueForKey:@"time"] ;
            circleView.icon = [info valueForKey:@"icon"] ;
            circleView.primeObject = [info valueForKey:@"prime"] ;
            circleView.seenalert = [info valueForKey:@"seenalert"] ;
            circleView.notes = [info valueForKey:@"notes"] ;
            circleView.link = [info valueForKey:@"link"] ;
            circleView.nodeID = [[info valueForKey:@"node"] doubleValue] ;
            circleView.theme = self.boardTheme ;

            // popup action for the touch
            
            [circleView setUserInteractionEnabled:YES];
            UIGestureRecognizer *circleTap = [[UILongPressGestureRecognizer alloc]
                                              initWithTarget:self action:@selector(circleTapping:)];
            [circleView addGestureRecognizer:circleTap];
            
            // add it ot the stage
            
            [self.objectHolder addSubview:circleView];
            
            
            
            // and then we load the position
            
            for (taskObject* subview in self.objectHolder.subviews) {
                if ([subview isKindOfClass:[taskObject class]]) {
                    if (subview.thisObjectID == circleView.thisObjectID) {
                        
                        subview.center = CGPointMake([[info valueForKey:@"x"] floatValue], [[info valueForKey:@"y"] floatValue]);
                        
                        if (stageHasLoaded==0 || ([globalVariables getDeleted]==[subview.thisObjectID integerValue])) {
                            
                            [subview resizeCreate];
                            
                        }
                        
                    }
                }
            }
            
            
            
        }
        
    }
    
    stageHasLoaded = 1;
    [globalVariables setDeleted:0];
    
    
}

// This is the primary way we're going to add nodes to the stage
// We're going to save them & their coordinates

- (IBAction)quoteButtonTapped:(id)sender {
    
    // Create the actual task
    
    if (![self.taskTitle.text isEqualToString:@""]) {
    
        CGRect circleFrame = CGRectMake(0, 0, 130,130);
        
        taskObject *circleView = [[taskObject alloc] initWithFrame: circleFrame];
        
        circleView.backgroundColor = [UIColor clearColor];
        circleView.autoresizesSubviews = NO ;
        circleView.autoresizingMask = UIViewAutoresizingNone ;
        circleView.attachedObjectID = [self getPrimeObjectID] ;
        circleView.thisObjectID = [self getHighestTaskIDOnStage] ;
        circleView.theme = self.boardTheme ;
        circleView.title = self.taskTitle.text ;
        circleView.date = @"Anytime" ;
        circleView.icon = @"map.png" ;
        circleView.notes = @"No notes on this task yet." ;
        circleView.link = @"" ;
        circleView.nodeID = self.boardID ;
        circleView.seenalert = [NSNumber numberWithInt:0];
        
        NSLog(@"quoteButtonTapped circleView.thisObjectID %@",circleView.thisObjectID) ;
        NSLog(@"quoteButtonTapped self.taskTitle.text %@",self.taskTitle.text) ;
        
        if ( [circleView.thisObjectID intValue] == 1 ) {
            circleView.primeObject = [NSNumber numberWithInt:1] ;
        } else {
            circleView.primeObject = [NSNumber numberWithInt:0] ;
        }
        
        [self.taskTitle resignFirstResponder];
        
        // Create a new managed object -----------------------------------------------------
        // ---------------------------------------------------------------------------------
        
        NSManagedObjectContext *context = [self managedObjectContext];
        NSManagedObject *newTask = [NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:context];

        [newTask setValue:circleView.icon forKey:@"icon"];
        [newTask setValue:circleView.thisObjectID forKey:@"id"];
        [newTask setValue:circleView.attachedObjectID forKey:@"id_attached"];
        [newTask setValue:circleView.link forKey:@"link"];
        [newTask setValue:[NSNumber numberWithDouble:circleView.nodeID] forKey:@"node"];
        [newTask setValue:circleView.notes forKey:@"notes"];
        [newTask setValue:circleView.primeObject forKey:@"prime"];
        [newTask setValue:circleView.date forKey:@"time"];
        [newTask setValue:circleView.title forKey:@"title"];
        
        float x = [UIScreen mainScreen].bounds.size.width / 2 ;
        float y = [UIScreen mainScreen].bounds.size.height / 2 - 60 ;
        if (circleView.primeObject != [NSNumber numberWithInt:1]) { y = y + 100 ; }
        
        [newTask setValue:[NSNumber numberWithFloat:x] forKey:@"x"];
        [newTask setValue:[NSNumber numberWithFloat:y] forKey:@"y"];
        
        NSError *error = nil;
        
        if (![context save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }
        
        // ---------------------------------------------------------------------------------
        // ---------------------------------------------------------------------------------
        
        // popup action for the touch
        
        [circleView setUserInteractionEnabled:YES];
        UITapGestureRecognizer *circleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(circleTapping:)];
        [circleTap setNumberOfTapsRequired:1];
        [circleView addGestureRecognizer:circleTap];
        
        // add it ot the stage
        
        [self.objectHolder addSubview:circleView];
        
        // and then we load the position
        
        for (taskObject* subview in self.objectHolder.subviews) {
            if ([subview isKindOfClass:[taskObject class]]) {
                if (subview.thisObjectID == circleView.thisObjectID) {
                    
                    float x = [UIScreen mainScreen].bounds.size.width / 2 ;
                    float y = [UIScreen mainScreen].bounds.size.height / 2 - 60 ;
                    
                    if (subview.primeObject != [NSNumber numberWithInt:1]) {
                        y = y + 100 ;
                    }
                    
                    subview.center = CGPointMake(x,y);
                    
                    subview.transform = CGAffineTransformMakeScale(0.5, 0.5);
                    [UIView beginAnimations:nil context:(__bridge_retained void *)subview];
                    [UIView setAnimationDuration:0.3];
                    [UIView setAnimationDelegate:self];
                    [UIView setAnimationDidStopSelector:@selector(growAnimationDidStop:finished:context:)];
                    subview.transform = CGAffineTransformMakeScale(1.0, 1.0);
                    [UIView commitAnimations];
                    
                }
            }
        }
        
        self.taskTitle.text = @"" ;
        
    }
    
}

- (void) updateLines {
    [self.linesView setNeedsDisplay];
}

-(void)circleTapping:(UIGestureRecognizer *)recognizer {
    [self createPopup:(taskObject *)recognizer.view ];
}

-(void)olTapping:(UIGestureRecognizer *)recognizer {
    [self removePopups] ;
}

// Create the popup for the task



-(void) shakeIt:(taskObject*)obj {
    
    CABasicAnimation* anim = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    [anim setToValue:[NSNumber numberWithFloat:0.0f]];
    [anim setFromValue:[NSNumber numberWithDouble:M_PI/16]]; // rotation angle
    [anim setDuration:0.1];
    [anim setRepeatCount:NSUIntegerMax];
    [anim setAutoreverses:YES];
    [obj.layer addAnimation:anim forKey:@"iconShake"];
    
}

- (void) createPopup:(taskObject *) obj {
    
    CGFloat locationX = obj.frame.size.width/2 + obj.frame.origin.x ;
    CGFloat locationY = obj.frame.size.height/2 + obj.frame.origin.y ;
    
    CGPoint popupPoint = CGPointMake(locationX+(obj.frame.size.width/2),locationY-10) ;
    CGRect popupFrame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,60);
    
    taskPopup *popup = [[taskPopup alloc] initWithFrame:popupFrame];
    
    popup.backgroundColor = [UIColor clearColor];
    popup.title = obj.title ;
    popup.date = obj.date ;
    popup.point = popupPoint ;
    popup.taskID = obj.thisObjectID ;
    popup.theme = obj.theme ;
    popup.icon = obj.icon ;
    popup.delegate = self ;
    popup.notes = obj.notes ;
    popup.link = obj.link ;
    popup.nodeID = self.boardID ;
    
    [self shakeIt:obj] ;
    
    areTherePopupsOpen = YES ;
    
    [self.objectHolder addSubview:popup];
    
}

- (BOOL) textFieldShouldReturn:(UITextField *) quoteTextField {
    if (quoteTextField==self.taskTitle) {
        [quoteTextField resignFirstResponder];
    }
    return YES ;
}

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void) editTask:(NSNumber*)task {
    
    taskEditID = task ;
    
    [self performSegueWithIdentifier:@"editview" sender:self];
    
}

-(void) createFacebook:(NSString*)post {
    
    NSString *postTitle = [post stringByAppendingString:@" via @TaskFuApp"];
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [controller setInitialText:postTitle];
        [self presentViewController:controller animated:YES completion:Nil];
    }
    
}

-(void) createTwitter:(NSString*)post {
    
    NSString *postTitle = [post stringByAppendingString:@" via @TaskFuApp"];
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:postTitle];
        [self presentViewController:tweetSheet animated:YES completion:nil];
        
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    
    NSLog(@"%@", taskEditID) ;
    NSLog(@"%f", self.boardID) ;
    
   editViewController *mvc = [segue destinationViewController] ;
    mvc.taskID = taskEditID ;
    mvc.boardID = self.boardID;
    
}


// Keyboard stuff

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    // Here we establish whether it's an Ipad or Iphone
    
    float screenSize = [UIScreen mainScreen].bounds.size.width ;
    
    CGRect frame = self.keyboardToolbar.frame;
    
    // IPHONE / IPAD
    
    if ( [UIScreen mainScreen].bounds.size.width > 500 ) {
        
        if (isLandscape) {
            frame.origin.y = self.view.frame.size.height - 250.0;
        } else {
            frame.origin.y = self.view.frame.size.height - 305.0;
        }
    } else {

        if (isLandscape) {
            frame.origin.y = self.view.frame.size.height - 205.0;
        } else {
            frame.origin.y = self.view.frame.size.height - 260.0;
        }
    }
    

    self.keyboardToolbar.frame = frame;
    
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    CGRect frame = self.keyboardToolbar.frame;
    frame.origin.y = self.view.frame.size.height - self.keyboardToolbar.frame.size.height;
    self.keyboardToolbar.frame = frame;
    
    [UIView commitAnimations];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([self.taskTitle.text length] > 20) {
        self.taskTitle.text = [self.taskTitle.text substringToIndex:20];
        return NO;
    }
    return YES;
}

// layout stuff

-(void) willAnimateRotationToInterfaceOrientation: (UIInterfaceOrientation) interfaceOrientation duration: (NSTimeInterval) duration {
    [self updateLayoutForNewOrientation: interfaceOrientation];
}

- (void) updateLayoutForNewOrientation: (UIInterfaceOrientation) orientation {
    
    // LANDSCAPE --------------------------------------------------------------
    
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        
        isLandscape = YES;
        
        CGRect frame = self.objectHolder.frame ;
        frame.size.height = [UIScreen mainScreen].bounds.size.width  ;
        frame.size.width = [UIScreen mainScreen].bounds.size.height ;
        frame.origin.x = 0 ;
        frame.origin.y = 0 ;
        self.objectHolder.frame = frame ;
        self.drawImage.frame = frame ;
        self.linesView.frame = frame ;
        
        [self updateLines] ;
        
        CGRect framek = self.keyboardToolbar.frame;
        framek.size.width = [UIScreen mainScreen].bounds.size.height ;
        self.keyboardToolbar.frame = framek;
        
        CGRect framet = self.taskTitle.frame;
        framet.size.width = [UIScreen mainScreen].bounds.size.height-60 ;
        self.taskTitle.frame = framet;
        
        for (taskPopup* subview in self.objectHolder.subviews) {
            if ([subview isKindOfClass:[taskPopup class]]) {
                CGRect frametp = subview.frame ;
                frametp.size.width = [UIScreen mainScreen].bounds.size.height ;
                frametp.origin.y = 0 ;
                subview.frame = frametp ;
                [subview setNeedsDisplay];
            }
        }
        
    }
    
    // PORTRAIT --------------------------------------------------------------
    
    if (UIInterfaceOrientationIsPortrait(orientation))  {
        
        isLandscape = NO ;
        
        CGRect frame = self.objectHolder.frame ;
        frame.size.height = [UIScreen mainScreen].bounds.size.height  ;
        frame.size.width = [UIScreen mainScreen].bounds.size.width ;
        frame.origin.x = 0 ;
        frame.origin.y = 0 ;
        self.objectHolder.frame = frame ;
        self.drawImage.frame = frame ;
        self.linesView.frame = frame ;
        
        [self updateLines] ;
        
        CGRect framek = self.keyboardToolbar.frame;
        framek.size.width = [UIScreen mainScreen].bounds.size.width ;
        self.keyboardToolbar.frame = framek;
        
        CGRect framet = self.taskTitle.frame;
        framet.size.width = [UIScreen mainScreen].bounds.size.width-60 ;
        self.taskTitle.frame = framet;
        
        for (taskPopup* subview in self.objectHolder.subviews) {
            if ([subview isKindOfClass:[taskPopup class]]) {
                CGRect frametp = subview.frame ;
                frametp.size.width = [UIScreen mainScreen].bounds.size.width ;
                frametp.origin.y = 0 ;
                subview.frame = frametp ;
                [subview setNeedsDisplay];
            }
        }
        
    }
    
    
    
    
    
}

@end
