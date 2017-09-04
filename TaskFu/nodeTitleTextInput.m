//
//  nodeTitleTextInput.m
//  TaskFu
//
//  Created by Johannes du Plessis on 2013/04/14.
//  Copyright (c) 2013 Johannes du Plessis. All rights reserved.
//

#import "nodeTitleTextInput.h"
#import "taskNode.h"

@implementation nodeTitleTextInput

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.landscapeAdd = 0 ;
    }
    return self;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [self resignFirstResponder];
    return YES;
    
}

- (void)drawRect:(CGRect)rect
{
    
    for (UIView* subview in self.subviews) {
        if ([subview isKindOfClass:[UIToolbar class]]) {
            [subview removeFromSuperview] ;
        }
    }
    
    UIToolbar *toolbar = [[UIToolbar alloc]init];
    
    toolbar.frame = CGRectMake(self.landscapeAdd, 0, self.superview.frame.size.width-self.landscapeAdd,44);
    
    UITextField *userNameTextfield = [[UITextField alloc]initWithFrame:CGRectMake(10, 10, self.superview.frame.size.width-150-self.landscapeAdd,34)];
    [userNameTextfield setAdjustsFontSizeToFitWidth:YES];
    [userNameTextfield becomeFirstResponder];
    userNameTextfield.backgroundColor = [UIColor whiteColor];
    userNameTextfield.borderStyle = UITextBorderStyleRoundedRect;
    userNameTextfield.delegate = self ;
    UIBarButtonItem *infoButton = [[UIBarButtonItem alloc]initWithTitle:@"Save"style:UIBarButtonItemStyleBordered target:self action:@selector(save_clicked:)];
    
    UIBarButtonItem *infoButtonCancel = [[UIBarButtonItem alloc]initWithTitle:@"Cancel"style:UIBarButtonItemStyleBordered target:self action:@selector(cancel_clicked:)];
    
    UIBarButtonItem *textFieldItem = [[UIBarButtonItem alloc] initWithCustomView:userNameTextfield];

    [toolbar setItems:[NSArray arrayWithObjects:textFieldItem, infoButton,infoButtonCancel,nil]];
    
    [self addSubview:toolbar];
}

- (IBAction)cancel_clicked:(id)sender{
    [self removeFromSuperview];
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
   self.textFieldText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    return YES;
    
}

- (NSManagedObjectContext *)managedObjectContext {
    
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
    
}

- (IBAction)save_clicked:(id)sender{
    
    for (taskNode* subview in self.superview.subviews) {
        if ([subview isKindOfClass:[taskNode class]]) {
            if ( subview.taskNodeID == self.taskNodeID ) {
                
                // update the object
                
                NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
                NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Node"];
                NSArray *tasks = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
                
                for (NSManagedObject *info in tasks) {
                    double temp = [[info valueForKey:@"id"] doubleValue] ;
                    if (self.taskNodeID == temp) {
                        [info setValue:self.textFieldText forKey:@"title"];
                        subview.heading = self.textFieldText ;
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
