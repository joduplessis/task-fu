//
//  addNode.m
//  TaskFu
//
//  Created by Johannes du Plessis on 2013/04/14.
//  Copyright (c) 2013 Johannes du Plessis. All rights reserved.
//

#import "addNode.h"
#import "taskNode.h"
#import "colorPallete.h"
#import "imagePallete.h"
#import "nodeTitleTextInput.h"

@implementation addNode {
    float nodeSize ;
    float nodeSizeHeight ;
    float screenSize ;
    UIView *temp ;
}

@synthesize delegate ;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
    }
    
    return self;
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



- (void)drawRect:(CGRect)rect
{
    
    
    

    
    // Draw the plus circle
    
    taskCounter = [self getNumberNodes] ;
    
    CGContextRef contex = UIGraphicsGetCurrentContext();
 
    UIGraphicsPushContext(contex);
    
    int radius = 30 ;
    
    CGContextBeginPath(contex);
    CGContextSetLineWidth(contex, 5.0);
    
    
    
    // logo icon
    
    UIImage *iconLogo = [UIImage imageNamed:@"logo.png"];
    UIImageView *iconLogoObject = [[UIImageView alloc] initWithImage:iconLogo] ;
    iconLogoObject.frame = CGRectMake(0,0,80,80);
    iconLogoObject.center = CGPointMake(radius,radius-10);
    [self addSubview:iconLogoObject] ;
    
    /*
    
    CGContextSetFillColorWithColor(contex, [self colorWithHexString:@"e7e5dd"].CGColor);
    CGContextSetStrokeColorWithColor(contex, [self colorWithHexString:@"c2c1ba"].CGColor);
    CGContextAddArc(contex, radius, radius, radius-5, 0, 2*M_PI, YES);
    
    CGContextMoveToPoint(contex, 15, 30);
    CGContextAddLineToPoint(contex, 45, 30);
    CGContextMoveToPoint(contex, 30, 15);
    CGContextAddLineToPoint(contex, 30, 45);
    
    CGContextDrawPath(contex, kCGPathFillStroke);
    UIGraphicsPopContext();
     
     */
    
    UIGraphicsPopContext();
    
}

- (NSManagedObjectContext *)managedObjectContext {
    
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
    
}

- (int)getNumberNodes {
    
    int counter = 0 ;
    for (UIView* subview in self.superview.subviews) {
        if ([subview isKindOfClass:[taskNode class]]) {
            counter ++ ;
        }
    }
    return counter;
    
}

-(void) populateNodes {
    
    // Here we establish whether it's an Ipad or Iphone
    screenSize = [UIScreen mainScreen].bounds.size.width ;
    if ( [UIScreen mainScreen].bounds.size.width > 500 ) {
        nodeSize = 500 ;
        nodeSizeHeight = 1000 ;
    } else {
        nodeSize = 300 ;
        nodeSizeHeight = 500 ;
    }

 NSError *error;
    
    taskCounter = [self getNumberNodes] ;
    

    
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Node" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *info in fetchedObjects) {
        
        double temp = [[info valueForKey:@"id"] doubleValue] ;
        
        NSString *theme = [info valueForKey:@"theme"] ;
        NSString *background = [info valueForKey:@"background"] ;
        NSString *title = [info valueForKey:@"title"] ;
        
        [self createTaskNodeNewExisting:temp bg:background th:theme ti:title] ;
        
 

    }
    

/*
    
    
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Node"];
    NSArray *tasks = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    for (NSManagedObject *info in tasks) {
        
        double temp = [[info valueForKey:@"id"] doubleValue] ;
        
        NSString *theme = [info valueForKey:@"theme"] ;
        NSString *background = [info valueForKey:@"background"] ;
        NSString *title = [info valueForKey:@"title"] ;
        
        [self createTaskNodeNewExisting:temp bg:background th:theme ti:title] ;

        
        
    }
 
*/
    
    
    
}

- (void) createTaskNodeNewExisting:(double)nid bg:(NSString*)background th:(NSString*)theme ti:(NSString*)title {
    
    // We create the task node that is already in the DB
    
    taskCounter = [self getNumberNodes] + 1;
    
    NSLog(@"%f <-",nodeSize);
    
    CGRect nodeFrame = CGRectMake(0, 0, nodeSize,nodeSizeHeight);
    
    taskNode *nodeSign = [[taskNode alloc] initWithFrame: nodeFrame];
    nodeSign.taskNodeID = nid ;
    nodeSign.taskNodeIDOrder = taskCounter ;
    nodeSign.backgroundColor = [UIColor clearColor];
    nodeSign.autoresizesSubviews = NO ;
    nodeSign.autoresizingMask = UIViewAutoresizingNone ;
    nodeSign.taskNodeID = nid ;
    nodeSign.heading = title ;
    nodeSign.theme = theme ;
    nodeSign.background = background ;
    
    nodeSign.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2 + ([UIScreen mainScreen].bounds.size.width*(taskCounter-1)), [UIScreen mainScreen].bounds.size.height/2+30);
    
    // Add the tap behaviour
    // ---------------------
    [nodeSign setUserInteractionEnabled:YES];
    UITapGestureRecognizer *openTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openTapping:)];
    [openTap setNumberOfTapsRequired:1];
    [nodeSign addGestureRecognizer:openTap];
    // ---------------------
 
    [self moveRight];
    
    [self.superview addSubview:nodeSign];
    
}

-(void) clearModules {
    
    for (colorPallete* subview in self.superview.subviews) {
        if ([subview isKindOfClass:[colorPallete class]]) {
            [subview removeFromSuperview] ;
        }
    }
    
    for (imagePallete* subview in self.superview.subviews) {
        if ([subview isKindOfClass:[imagePallete class]]) {
            [subview removeFromSuperview] ;
        }
    }
    
    for (nodeTitleTextInput* subview in self.superview.subviews) {
        if ([subview isKindOfClass:[nodeTitleTextInput class]]) {
            [subview removeFromSuperview] ;
        }
    }
    
}

-(void)openTapping:(UIGestureRecognizer *)recognizer {
    
    // start animation for the drag
    
    CGPoint  touchPoint = [recognizer locationInView:self.superview] ;
    NSLog(@"%f",touchPoint.y );
    
    BOOL found = NO ;
    
    for (colorPallete* subview in self.superview.subviews) {
        if ([subview isKindOfClass:[colorPallete class]]) {
            found = YES ;
            NSLog(@"ed") ;
        }
    }
    
    for (imagePallete* subview in self.superview.subviews) {
        if ([subview isKindOfClass:[imagePallete class]]) {
            found = YES ;
        }
    }
    
    for (nodeTitleTextInput* subview in self.superview.subviews) {
        if ([subview isKindOfClass:[nodeTitleTextInput class]]) {
            found = YES ;
        }
    }
    
    if (found == NO) {
        
        if (touchPoint.y < ([UIScreen mainScreen].bounds.size.width/2 + (nodeSize/2)) ) {
            
            CGFloat start_x = recognizer.view.transform.a;
            CGFloat start_y = recognizer.view.transform.d;
            
            CGAffineTransform start = CGAffineTransformMakeScale(start_x, start_y);
            
            CGFloat end_x = recognizer.view.transform.a - 0.2;
            CGFloat end_y = recognizer.view.transform.d - 0.2;
            
            CGAffineTransform end = CGAffineTransformMakeScale(end_x, end_y);
            
            // end animation for the drag
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.4];
            [UIView setAnimationDelay:0];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
            recognizer.view.transform = end;
            [UIView commitAnimations];
            
            temp = recognizer.view ;
            
            // end animation for the drag
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.4];
            [UIView setAnimationDelay:0];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
            recognizer.view.transform = start;
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(afterAnimationS:finished:context:)] ;
            [UIView commitAnimations];
            
            
            
        }
    
    } else {
        
        [self clearModules];
        
    }
    

    
}

- (void) afterAnimationS:(NSString*)animationID finished:(NSNumber *)finished context:(void *)context {
    [delegate sayHello:temp];
}

-(void) createNewTaskNode {

    taskCounter = [self getNumberNodes] + 1;
    
    CGRect nodeFrame = CGRectMake(0, 0, nodeSize,nodeSizeHeight);
    
    taskNode *nodeSign = [[taskNode alloc] initWithFrame: nodeFrame];
    nodeSign.taskNodeID = taskCounter ;
    nodeSign.taskNodeIDOrder = taskCounter ;
    nodeSign.backgroundColor = [UIColor clearColor];
    nodeSign.autoresizesSubviews = NO ;
    nodeSign.autoresizingMask = UIViewAutoresizingNone ;
    
    double nowMillis = 1000.0 * [[NSDate date] timeIntervalSince1970];
    
    nodeSign.taskNodeID = nowMillis ;
    nodeSign.heading = @"The Daily List" ;
    nodeSign.theme = @"brown" ;
    nodeSign.background = @"c02.jpg" ;
    
    nodeSign.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2+30);
    

    nodeSign.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2+1040);
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelay:0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    nodeSign.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2+40);
    
    [UIView commitAnimations];
    

    
        // Add the tap behaviour
        // ---------------------
        [nodeSign setUserInteractionEnabled:YES];
        UITapGestureRecognizer *openTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openTapping:)];
        [openTap setNumberOfTapsRequired:1];
        [nodeSign addGestureRecognizer:openTap];
        // ---------------------
    
        [self moveRight];
        
        [self.superview addSubview:nodeSign];
 


    
    
    
        
        
        // Create a new managed object -----------------------------------------------------
        
        
        NSManagedObjectContext *context = [self managedObjectContext];
        NSManagedObject *newTask = [NSEntityDescription insertNewObjectForEntityForName:@"Node" inManagedObjectContext:context];
        
        [newTask setValue:@(nowMillis) forKey:@"id"];
        [newTask setValue:@"c02.jpg" forKey:@"background"];
        [newTask setValue:@"brown" forKey:@"theme"];
        [newTask setValue:@"The Daily List" forKey:@"title"];
        
        NSError *error = nil;
        
        if (![context save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }



}

-(void) makeTheCenterObjectCenterOnStage {
    
    [delegate setCenterObjectOnStage:self.centerObject] ;
    
}

- (void)moveRight {
    
    self.center = CGPointMake(self.center.x, self.center.y);
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelay:0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    
    self.center = CGPointMake(self.center.x+screenSize, self.center.y);
    
    [UIView commitAnimations];
    
}

-(void) moveLeft {
    
    CGRect frame = self.frame;
    frame.origin.x -= screenSize ;
    self.frame = frame;
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    // start animation for the drag
    
    CGFloat start_x = self.transform.a;
    CGFloat start_y = self.transform.d;
    
    CGAffineTransform start = CGAffineTransformMakeScale(start_x, start_y);
    
    CGFloat end_x = self.transform.a -0.2;
    CGFloat end_y = self.transform.d -0.2;
    
    CGAffineTransform end = CGAffineTransformMakeScale(end_x, end_y);
    
    [UIView beginAnimations:nil context:(__bridge_retained void *)self];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(growAnimationDidStop:finished:context:)];
    self.transform = end;
    [UIView commitAnimations];
    
    // end animation for the drag
    
    [UIView beginAnimations:nil context:(__bridge_retained void *)self];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(growAnimationDidStop:finished:context:)];
    self.transform = start;
    [UIView commitAnimations];
    
    [self createNewTaskNode] ;
    
}


@end
