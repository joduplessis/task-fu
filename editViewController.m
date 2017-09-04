//
//  editViewController.m
//  TaskFu
//
//  Created by Johannes du Plessis on 2013/04/13.
//  Copyright (c) 2013 Johannes du Plessis. All rights reserved.
//

#import "editViewController.h"
#import "ViewController.h"

@interface editViewController ()

@end

@implementation editViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)deleteAction:(id)sender {
    
    
    
}

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (IBAction)saveAction:(id)sender {
    
    // Create a new managed object
     
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *newTask = [NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:context];
    
    [newTask setValue:self.heading.text forKey:@"title"];
    [newTask setValue:self.notes.text forKey:@"notes"];
    [newTask setValue:self.icon.text forKey:@"icon"];
    [newTask setValue:self.link.text forKey:@"link"];
    
    NSError *error = nil;
    
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    
    // moving views
    
    ViewController *viewBoard = [self.storyboard instantiateViewControllerWithIdentifier:@"viewBoard"];
    [self.navigationController pushViewController:viewBoard animated:YES];
     
     
    
}

@end
