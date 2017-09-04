//
//  imagePallete.m
//  TaskFu
//
//  Created by Johannes du Plessis on 2013/04/15.
//  Copyright (c) 2013 Johannes du Plessis. All rights reserved.
//

#import "imagePallete.h"
#import "taskNode.h"

@implementation imagePallete

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    
    for (UIView* subview in self.subviews) {
        if ([subview isKindOfClass:[UIScrollView class]]) {
            [subview removeFromSuperview] ;
        }
    }
    
    CGRect frame = CGRectMake(0, 0, self.superview.frame.size.width,150 );
    
    self.frame = frame;
    
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:frame];
    
    scroll.backgroundColor=[UIColor clearColor];
    scroll.pagingEnabled=YES;
    scroll.contentSize = CGSizeMake(20*70, 150);
    scroll.showsHorizontalScrollIndicator=NO;
    
    colors = [NSArray arrayWithObjects:@"c01.jpg",@"c02.jpg", @"c03.jpg",@"c04.jpg", @"c05.jpg", @"c06.jpg", @"c07.jpg",@"c08.jpg",@"c09.jpg",@"c10.jpg",@"c11.jpg",@"c12.jpg",@"c13.jpg",@"c14.jpg",@"c15.jpg",@"c16.jpg",@"c17.jpg",@"c18.jpg",@"c19.jpg",@"c20.jpg",nil];
    
    CGFloat x=0;
    
    for(int i=0;i<20;i++) {
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(x+0, 0, 70, 110)];
        image.contentMode = UIViewContentModeCenter ;
        UIImage *original = [UIImage imageNamed:[colors objectAtIndex:i]];
        UIImage *scaled = [UIImage imageWithCGImage:[original CGImage] scale:(original.scale*12) orientation:(original.imageOrientation)] ;
        
        UITapGestureRecognizer *setColorTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setColor:)];
        
        NSString *imageName = [colors objectAtIndex:i];
        
    
        
        
        // if iphone
        if ([UIScreen mainScreen].bounds.size.width<500) {
            if ( [imageName isEqualToString:self.current] ) {
                image.backgroundColor = [UIColor darkGrayColor];
                if (i>15) {
                    [scroll setContentOffset:CGPointMake(([UIScreen mainScreen].bounds.size.width-(20*70))*-1, 0) animated:YES] ;
                } else {
                    [scroll setContentOffset:CGPointMake(i*70, 0) animated:YES] ;
                }
            }
        } else {
            if ( [imageName isEqualToString:self.current] ) {
                image.backgroundColor = [UIColor darkGrayColor];
                if (i>9) {
                    [scroll setContentOffset:CGPointMake(([UIScreen mainScreen].bounds.size.width-(20*70))*-1, 0) animated:YES] ;
                } else {
                    [scroll setContentOffset:CGPointMake(0, 0) animated:YES] ;
                }
            }
        }
        
        
        [setColorTap setNumberOfTapsRequired:1];
        [image addGestureRecognizer:setColorTap];
        [image setImage:scaled];
        [image setTag:i];
        [image setUserInteractionEnabled:YES];
        
        [scroll addSubview:image];
        
        x+=70;
        
    }
    
    [self addSubview:scroll];
    [self moveit] ;
    
}

- (NSManagedObjectContext *)managedObjectContext {
    
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
    
}

-(void)moveit {
    
    // first we move the thing down
    
    for (UIView* subview in self.superview.subviews) {
        if ([subview isKindOfClass:[imagePallete class]]) {
            CGRect frame = subview.frame;
            frame.origin.y = self.superview.frame.size.height ;
            frame.size.width = self.superview.frame.size.width ;
            subview.frame = frame;
        }
    }
    
    [self setNeedsDisplay] ;
    
    // and then up
    
    for (UIView* subview in self.superview.subviews) {
        if ([subview isKindOfClass:[imagePallete class]]) {
            
            CGRect frame = subview.frame;
            
            frame.origin.y = frame.origin.y ;
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationDelay:0];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
            
            frame.origin.y = self.superview.frame.size.height - 110 ;
            subview.frame = frame;
            
            [UIView commitAnimations];
            
        }
    }
    
}

-(void)setColor:(UITapGestureRecognizer *)gesture {
    
    
    
    
    
    
    
    
    
    
    
    
    // start animation for the drag
    
    CGFloat start_x = gesture.view.transform.a;
    CGFloat start_y = gesture.view.transform.d;
    
    CGAffineTransform start = CGAffineTransformMakeScale(start_x, start_y);
    
    CGFloat end_x = gesture.view.transform.a - 0.5;
    CGFloat end_y = gesture.view.transform.d - 0.5;
    
    CGAffineTransform end = CGAffineTransformMakeScale(end_x, end_y);
    
    [UIView beginAnimations:nil context:(__bridge_retained void *)gesture.view];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(growAnimationDidStop:finished:context:)];
    gesture.view.transform = end;
    [UIView commitAnimations];
    
    // end animation for the drag
    
    [UIView beginAnimations:nil context:(__bridge_retained void *)gesture.view];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(growAnimationDidStop:finished:context:)];
    gesture.view.transform = start;
    [UIView commitAnimations];
    
    
    
    
    
    gesture.view.alpha = 0.1 ;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    gesture.view.alpha = 0.2 ;
    [UIView commitAnimations];
    
    gesture.view.alpha = 0.2 ;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    gesture.view.alpha = 1.0 ;
    [UIView commitAnimations];
    
    
    
    
    
    
    
    
    gesture.view.backgroundColor = [UIColor darkGrayColor];
    UIImageView *imageFile = (UIImageView *)gesture.view;
    NSString *imageName = [colors objectAtIndex:imageFile.tag];
    

    
    for (taskNode* subview in self.superview.subviews) {
        if ([subview isKindOfClass:[taskNode class]]) {
            if ( subview.taskNodeID == self.taskNodeID ) {
                
                NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
                NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Node"];
                NSArray *tasks = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
                
                for (NSManagedObject *info in tasks) {
                    double temp = [[info valueForKey:@"id"] doubleValue] ;
                    if (self.taskNodeID == temp) {
                        [info setValue:imageName forKey:@"background"];
                        subview.background = imageName ;
                    }
                }
                
                NSError *error = nil;
                
                if (![managedObjectContext save:&error]) {
                    NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
                }
                
                [subview setNeedsDisplay] ;
                
            }
        }
    }
    
    [self removeFromSuperview];
    
}

@end
