//
//  welcomeViewController.m
//  TaskFu
//
//  Created by Johannes du Plessis on 2013/04/13.
//  Copyright (c) 2013 Johannes du Plessis. All rights reserved.
//

#import "welcomeViewController.h"
#import "ViewController.h"
#import "addNode.h"
#import "taskNode.h"
#import "colorPallete.h"
#import "imagePallete.h"
#import "nodeTitleTextInput.h"

@interface welcomeViewController ()

@end

@implementation welcomeViewController { 
    float nodeSize ;
    float nodeSizeHeight ;
    float screenSize ;
    int swipes_right ;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

-(void) sayHello:(taskNode *)node {
    
    background = node.background ;
    theme = node.theme;
    heading = node.heading ;
    taskNodeID = node.taskNodeID ;
    
    goToView = 1;
    
    [self performSegueWithIdentifier:@"nextview" sender:self];
    
}

- (IBAction)startApp:(id)sender {
    
    goToView = 0;
    
    //[self performSegueWithIdentifier:@"helpview" sender:self];
    
    NSURL *url = [NSURL URLWithString:@"http://www.joduplessis.com/"];
    if (![[UIApplication sharedApplication] openURL:url]) {
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
    }
    
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if (goToView == 1) {
    
        ViewController *mvc = [segue destinationViewController] ;
        mvc.boardBackground = background ;
        mvc.boardTitle = heading ;
        mvc.boardTheme = theme ;
        mvc.boardID = taskNodeID ;
        
    } else {
        
        ViewController *mvc = [segue destinationViewController] ;
        

        
    }
    
}


- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    UIFont *gothamBold ;
    UIFont *gothamBook ;
    

    
    if ([[UINavigationBar class]respondsToSelector:@selector(appearance)]) {
        
        UIImage *image = [UIImage imageNamed: @"nnbg.jpg"];
        [image drawInRect:CGRectMake(0, 0,30, 14)];
        
        [[UINavigationBar appearance] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
        
        UINavigationBar *bar = [self.navigationController navigationBar];
        [bar setTintColor:[self colorWithHexString:@"2c2924"]];

    }


    
    // Here we establish whether it's an Ipad or Iphone
    screenSize = [UIScreen mainScreen].bounds.size.width ;
    if ( [UIScreen mainScreen].bounds.size.width > 500 ) {
        nodeSize = 500 ;
        nodeSizeHeight = 1000 ;
        gothamBold = [UIFont fontWithName:@"Gotham-Bold" size:24];
        gothamBook = [UIFont fontWithName:@"Gotham-Book" size:16];
    } else {
        nodeSize = 300 ;
        nodeSizeHeight = 500 ;
        gothamBold = [UIFont fontWithName:@"Gotham-Bold" size:16];
        gothamBook = [UIFont fontWithName:@"Gotham-Book" size:10];
    }
    
    
    
    swipes_right = 0;
    centerObjectOnStage = 0 ;
    
    // swipes
    
    UISwipeGestureRecognizer *rightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipeHandle:)];
    rightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [rightRecognizer setNumberOfTouchesRequired:1];
    [self.nodeBoard addGestureRecognizer:rightRecognizer];
    
    UISwipeGestureRecognizer *leftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipeHandle:)];
    leftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [leftRecognizer setNumberOfTouchesRequired:1];
    [self.nodeBoard addGestureRecognizer:leftRecognizer];
    
    // heading styles
    

    
    [self.heading setFont:gothamBold] ;
    [self.subheading setFont:gothamBook] ;
    
    
    
    self.heading.textColor = [self colorWithHexString:@"fac320"] ;
    self.subheading.textColor = [self colorWithHexString:@"fac320"] ;
    
   
    

    
    // image background
    
    theAppHasAlreadyLoaded = NO ;
	
    self.nodeBoard.backgroundColor = [UIColor clearColor];
    [self.nodeBoardBacking setImage:[UIImage imageNamed:@"current.png"]] ;
    

    // add inital plus sign
    
    CGRect nodeFrame = CGRectMake(0, 0, 80,80);
    
    addNode *plusSign = [[addNode alloc] initWithFrame: nodeFrame];
    
    plusSign.backgroundColor = [UIColor clearColor];
    plusSign.autoresizesSubviews = NO ;
    plusSign.delegate = self ;
    plusSign.autoresizingMask = UIViewAutoresizingNone ;
    plusSign.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2+10, [UIScreen mainScreen].bounds.size.height/2-30);
    
    [self.nodeBoard addSubview:plusSign];
    
    [plusSign populateNodes];
    
    // create a listener for the appdelegate
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];


    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    // here we update our view wehen the application launches
    // from being inactive
    
    for (taskNode* subview in self.nodeBoard.subviews) {
        
        if ( [subview isKindOfClass:[taskNode class]] ) {
            
            [subview setNeedsDisplay] ;
            
        }
        
    }
 
    
}

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated] ;
    
    [self updateBadgeNumber] ;

    

    
    

    for (taskNode* subview in self.nodeBoard.subviews) {
        if ( [subview isKindOfClass:[taskNode class]] ) {
            [subview setNeedsDisplay] ;
        }
    }
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //[self clearModules] ;
}

-(void) clearModules {
    
    for (colorPallete* subview in self.nodeBoard.subviews) {
        if ([subview isKindOfClass:[colorPallete class]]) {
            [subview removeFromSuperview] ;
        }
    }
    
    for (imagePallete* subview in self.nodeBoard.subviews) {
        if ([subview isKindOfClass:[imagePallete class]]) {
            [subview removeFromSuperview] ;
        }
    }
    
}


-(void) swipeRight {
    swipes_right ++ ;
    
    for (taskNode* subview in self.nodeBoard.subviews) {
        if ( [subview isKindOfClass:[taskNode class]] ) {
            
            subview.center = CGPointMake(subview.center.x, subview.center.y);
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationDelay:0];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
            
            subview.center = CGPointMake(subview.center.x+screenSize, subview.center.y);
            
            [UIView commitAnimations];
            
            [subview checkIfCurrentNode] ;
            
        }
    }
    
    for (addNode* subview in self.nodeBoard.subviews) {
        if ( [subview isKindOfClass:[addNode class]] ) {
            
            subview.center = CGPointMake(subview.center.x, subview.center.y);
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationDelay:0];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            
            subview.center = CGPointMake(subview.center.x+screenSize, subview.center.y);
            
            [UIView commitAnimations];
            
            
        }
    }
    
}

-(void) swipeLeft {
    swipes_right -- ;
    
    for (taskNode* subview in self.nodeBoard.subviews) {
        if ( [subview isKindOfClass:[taskNode class]] ) {
            
            subview.center = CGPointMake(subview.center.x, subview.center.y);
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationDelay:0];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
            
            subview.center = CGPointMake(subview.center.x-screenSize, subview.center.y);
            
            [UIView commitAnimations];
            
            [subview checkIfCurrentNode] ;
            
        }
    }
    
    for (addNode* subview in self.nodeBoard.subviews) {
        if ( [subview isKindOfClass:[addNode class]] ) {
            
            subview.center = CGPointMake(subview.center.x, subview.center.y);
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationDelay:0];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            
            subview.center = CGPointMake(subview.center.x-screenSize, subview.center.y);
            
            [UIView commitAnimations];
            
            
        }
    }
}

- (void)rightSwipeHandle:(UISwipeGestureRecognizer*)gestureRecognizer
{
    [self swipeRight];
}

- (void)leftSwipeHandle:(UISwipeGestureRecognizer*)gestureRecognizer
{
[self swipeLeft];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setCenterObjectOnStage:(int)object {
    centerObjectOnStage = object ;
}

- (void) startAppWithID {

}

-(void) viewWillAppear: (BOOL) animated {
    
    [super viewWillAppear: animated];
    
}

-(void) willAnimateRotationToInterfaceOrientation: (UIInterfaceOrientation) interfaceOrientation duration: (NSTimeInterval) duration {
    [self updateLayoutForNewOrientation: interfaceOrientation];
}

- (void) updateLayoutForNewOrientation: (UIInterfaceOrientation) orientation {
    
    /*
    
    // LANDSCAPE --------------------------------------------------------------
    
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        
        CGRect frame = self.nodeBoard.frame ;
        frame.size.height = [UIScreen mainScreen].bounds.size.width - 50 ;
        frame.size.width = [UIScreen mainScreen].bounds.size.height + 40;
        frame.origin.x = -40 ;
        frame.origin.y = 0 ;
        self.nodeBoard.frame = frame ;
        
        CGRect frame1 = self.nodeBoardBacking.frame ;
        frame1.size.height = [UIScreen mainScreen].bounds.size.width ;
        frame1.size.width = [UIScreen mainScreen].bounds.size.height ;
        frame1.origin.x = 0 ;
        frame1.origin.y = 0 ;
        self.nodeBoardBacking.frame = frame1 ;
        
        self.heading.hidden = YES  ;
        self.subheading.hidden = YES ;
        
        for (taskNode* subview in self.nodeBoard.subviews) {
            if ([subview isKindOfClass:[taskNode class]]) {
                subview.center = CGPointMake(subview.center.x,self.nodeBoard.frame.size.height/2);
                subview.radius_add = -160 ;
                [subview checkIfCurrentNode] ;
            }
        }
        
        for (UIView* subview in self.nodeBoard.subviews) {
            if ([subview isKindOfClass:[addNode class]]) {
                subview.center = CGPointMake(subview.center.x,self.nodeBoard.frame.size.height/2-30);
            }
        }
        
        for (colorPallete* subview in self.nodeBoard.subviews) {
            if ([subview isKindOfClass:[colorPallete class]]) {
                [subview moveit];
            }
        }
        
        for (imagePallete* subview in self.nodeBoard.subviews) {
            if ([subview isKindOfClass:[imagePallete class]]) {
                [subview moveit];
            }
        }
        
        for (nodeTitleTextInput* subview in self.nodeBoard.subviews) {
            if ([subview isKindOfClass:[nodeTitleTextInput class]]) {
                subview.landscapeAdd = 40 ;
                [subview setNeedsDisplay];
            }
        }
        
        [self swipeRight];
        
    }
    
    // PORTRAIT --------------------------------------------------------------
    
    if (UIInterfaceOrientationIsPortrait(orientation))  {
        
        CGRect frame = self.nodeBoard.frame ;
        frame.size.height = [UIScreen mainScreen].bounds.size.height-60 ;
        frame.size.width = [UIScreen mainScreen].bounds.size.width ;
        frame.origin.x = 0 ;
        frame.origin.y = 0 ;
        self.nodeBoard.frame = frame ;
        
        CGRect frame1 = self.nodeBoardBacking.frame ;
        frame1.size.height = [UIScreen mainScreen].bounds.size.width ;
        frame1.size.width = [UIScreen mainScreen].bounds.size.height ;
        frame1.origin.x = 0 ;
        frame1.origin.y = -50 ;
        self.nodeBoardBacking.frame = frame1 ;
        
        self.heading.hidden = NO  ;
        self.subheading.hidden = NO ;
        
        for (taskNode* subview in self.nodeBoard.subviews) {
            if ([subview isKindOfClass:[taskNode class]]) {
                subview.center = CGPointMake(subview.center.x,self.nodeBoard.frame.size.height/2);
                subview.radius_add = 0 ;
                [subview checkIfCurrentNode] ;
            }
        }
        
        for (UIView* subview in self.nodeBoard.subviews) {
            if ([subview isKindOfClass:[addNode class]]) {
                subview.center = CGPointMake(subview.center.x,self.nodeBoard.frame.size.height/2-30);
            }
        }
        
        for (colorPallete* subview in self.nodeBoard.subviews) {
            if ([subview isKindOfClass:[colorPallete class]]) {
                [subview moveit];
            }
        }
        
        for (imagePallete* subview in self.nodeBoard.subviews) {
            if ([subview isKindOfClass:[imagePallete class]]) {
                [subview moveit];
            }
        }
        
        for (nodeTitleTextInput* subview in self.nodeBoard.subviews) {
            if ([subview isKindOfClass:[nodeTitleTextInput class]]) {
                subview.landscapeAdd = 0 ;
                [subview setNeedsDisplay];
            }
        }
        
        if (theAppHasAlreadyLoaded==YES) {
        
            [self swipeLeft];
            
        }
        
    }
    
    

    */

        
        theAppHasAlreadyLoaded = YES ;
        
        
    
}




- (UIColor *) colorWithHexString:(NSString *)str {
    NSScanner *scanner = [NSScanner scannerWithString:str] ;
    unsigned hex ;
    if (![scanner scanHexInt:&hex]) return nil ;
    int r = (hex >> 16) & 0xFF ;
    int g = (hex >> 8) & 0xFF ;
    int b = (hex) & 0xFF;
    return [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f];
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
                
                if ( (seenalert==[NSNumber numberWithInt:0]) || (seenalert==nil) ) {
                    
                    taskCounter++ ;
                    
                }
                
            }
            
        }
        
    }
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: taskCounter];
    
    return taskCounter ;
    
}

@end
