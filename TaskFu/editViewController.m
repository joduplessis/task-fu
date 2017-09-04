//
//  editViewController.m
//  TaskFu
//
//  Created by Johannes du Plessis on 2013/04/17.
//  Copyright (c) 2013 Johannes du Plessis. All rights reserved.
//

#import "editViewController.h"
#import "titleViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "globalVariables.h"

@interface editViewController ()

@end

@implementation editViewController {
    NSArray *tableData ;
    NSArray *tableSubData ;
    NSArray *icons ;
}

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
    
    self.title = @"Edit Fu" ;
    
  
    icons = [NSArray arrayWithObjects:@"apple.png",@"bulb.png",@"calendar.png",@"camera.png",@"cellphone.png",@"chat.png",@"clip.png",@"clouds.png",@"coffee.png",@"document.png",@"fire.png",@"hanger.png",@"hat.png",@"heart.png",@"ipod.png",@"map.png",@"message.png",@"paintbrush.png",@"phone.png",@"plane.png",@"present.png",@"rain.png",@"receiver.png",@"rocket.png",@"shopping.png",@"star.png",@"sun.png",@"time.png",@"tree.png",@"tv.png",nil];
    
    
    [self loadTableData] ;

}

- (void) loadTableData {
    
    tableData = [NSArray arrayWithObjects:@"Title", @"Notes", @"Link", @"Icon", @"Date", nil];
    tableSubData = [NSArray arrayWithObjects:@"Title", @"Notes", @"Link", @"Icon", @"Date", nil];
    
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Task"];
    NSArray *tasks = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    for (NSManagedObject *info in tasks) {
        
        if ( [[info valueForKey:@"node"] doubleValue] == self.boardID ) {
            
            if ( [self.taskID isEqualToNumber:[info valueForKey:@"id"]] ) {
                
                tableData = [NSArray arrayWithObjects:[info valueForKey:@"title"], [info valueForKey:@"notes"], [info valueForKey:@"link"], [info valueForKey:@"icon"], [info valueForKey:@"time"], nil];
                
            }
            
        }
        
    }
    
}

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated] ;
    [self loadTableData] ;
    [self.tableControl reloadData] ;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    
    return [tableData count] ;

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section

{
    return @"Edit this task's details.";
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"cells" ;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier] ;
    
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier] ;
    }
    
    cell.textLabel.text = [tableSubData objectAtIndex:indexPath.row];
    UIFont *gothamBoldSmall = [UIFont fontWithName:@"Gotham-Bold" size:16];
    cell.textLabel.font = gothamBoldSmall;
    
    if ( [cell.textLabel.text isEqualToString:@"Icon"] ) {
        
        //cell.detailTextLabel.text = [tableData objectAtIndex:indexPath.row];
        
        NSString *iconColorcode = @"ed" ;
        NSString *iconName = [iconColorcode stringByAppendingString:[tableData objectAtIndex:indexPath.row]];
    
        cell.imageView.image = [UIImage imageNamed:iconName];
        cell.textLabel.text = [tableSubData objectAtIndex:indexPath.row];
        
        
    } else {
        
        cell.detailTextLabel.text = [tableData objectAtIndex:indexPath.row];
        
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12.0];
        
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    valueToEdit = [tableSubData objectAtIndex:indexPath.row];
    valueToEditPlaceholder = [tableData objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"cells" sender:self];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    titleViewController *mvc = [segue destinationViewController] ;
    mvc.taskID = self.taskID ;
    mvc.nodeID = self.boardID;
    mvc.message = [tableData objectAtIndex:0] ;
    mvc.valueToEdit = valueToEdit ;
    mvc.valueToEditPlaceholder = valueToEditPlaceholder ;
    
}

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex==0){
        
        [self rewireTasksAfterDelete] ;
    }
    
}

- (NSNumber*) getAttachedObjectID {
    
    NSNumber *object ;
    
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Task"];
    NSArray *tasks = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    for (NSManagedObject *info in tasks) {
        
        // Get values that are part of this board
        if ( [[info valueForKey:@"node"] doubleValue] == self.boardID ) {
            
            //Only get values where this object is the one
            if ([self.taskID isEqualToNumber:[info valueForKey:@"id"]]) {
                
                // Get the object this one is attached to
                object = [info valueForKey:@"id_attached"] ;
                
                // We also save the XY of the CURRENT OBJECT - not the the id_attached
                x = [[info valueForKey:@"x"] floatValue];
                y = [[info valueForKey:@"y"] floatValue];
                
            }
            
        }
        
    }
    
    return object ;
    
}

// Here we get the best candidate
// we also get the x & y of the deleted object
// we'll reposition the new one

- (NSNumber *) getBestCandidate {
    
    NSNumber* candidate ;
    BOOL candidateHasBeenFound = NO ;
    
    
    
    
    
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Task"];
    NSArray *tasks = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    for (NSManagedObject *info in tasks) {
        
        // Get values that are part of this board
        if ( [[info valueForKey:@"node"] doubleValue] == self.boardID ) {
            
            
                    
                    //NSLog(@"%@ <<<< task",self.taskID) ;
                    //NSLog(@"%@ <<<< object",[info valueForKey:@"id"]) ;
                    //NSLog(@"%@ <<<< attached object",[info valueForKey:@"id_attached"]) ;

            
            
            
            if ([info valueForKey:@"id_attached"]!=nil) {
              
            //Only get values where this object is the attached focus
            if ([self.taskID isEqualToNumber:[info valueForKey:@"id_attached"]]) {
                
               
                
                // Don't use the object that is this one (obviously - jic)
                if (self.taskID != [info valueForKey:@"id"]) {
                    
                    if (candidateHasBeenFound==NO) {
                    
                        // This will pick the last one one in the list
                        candidate = [info valueForKey:@"id"] ;
                    
                        // Here we set the attached object that this object has (links back to home)
                        [info setValue:[self getAttachedObjectID] forKey:@"id_attached"];
                    
                        //Here we set the new XY
                        [info setValue:[NSNumber numberWithFloat:x] forKey:@"x"];
                        [info setValue:[NSNumber numberWithFloat:y] forKey:@"y"];
                        
                        candidateHasBeenFound = YES ;
                    
                    }
                
                }
                 
                 
                
            }
              
            }
            
        }
        
    }
    
    NSError *error = nil;
    
    if (![managedObjectContext save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
     
     
    
    if (candidate==nil) {
        candidate = [NSNumber numberWithInt:999] ;
    }
    
    return candidate ;
    
}

- (void) rewireTasksAfterDelete {
    
    // Here we find the new object to focus on 
    
    NSNumber *bestCandidate = [self getBestCandidate] ;
    
    if ([self.taskID integerValue] == [[self getPrimeObjectID] integerValue] ) {
        
        [self makeCandidatePrime:bestCandidate] ;
    }
    
    [self setAttachIDOfChildren:bestCandidate] ;
    
    [globalVariables setDeleted:[bestCandidate integerValue]];
    
    [self deleteActualTask:self.taskID] ;
    

}

- (void) makeCandidatePrime:(NSNumber*)object {
    
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Task"];
    NSArray *tasks = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    for (NSManagedObject *info in tasks) {
        double temp = [[info valueForKey:@"node"] doubleValue] ;
        if ( (self.boardID == temp) && ([object isEqualToNumber:[info valueForKey:@"id"]]) ) {
            [info setValue:[NSNumber numberWithInt:1] forKey:@"prime"];
        }
    }
    
    NSError *error = nil;
    
    if (![managedObjectContext save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    
}
                        
-(void) deleteActualTask:(NSNumber*)object {
    

    
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Task"];
    NSArray *tasks = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    NSLog(@"%@",self.taskID);
    
    for (NSManagedObject *info in tasks) {
        double temp = [[info valueForKey:@"node"] doubleValue] ;
        if (self.boardID == temp) {
            if ([object isEqualToNumber:[info valueForKey:@"id"]]) {
                [managedObjectContext deleteObject:info];
            }
        }
    }
    
    NSError *saveError = nil;
    
    [managedObjectContext save:&saveError];
    
    [[self navigationController] popViewControllerAnimated:YES];
    
}

-(void) setXYOfCandidate:(NSNumber*)candidate {
    
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Task"];
    NSArray *tasks = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    for (NSManagedObject *info in tasks) {
        double temp = [[info valueForKey:@"node"] doubleValue] ;
        if ( (self.boardID == temp) && ([candidate isEqualToNumber:[info valueForKey:@"id"]]) ) {
            [info setValue:[NSNumber numberWithFloat:x] forKey:@"x"];
            [info setValue:[NSNumber numberWithFloat:y] forKey:@"y"];
        }
    }
    
    NSError *error = nil;
    
    if (![managedObjectContext save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    
}

-(void) setAttachIDOfChildren:(NSNumber*)candidate {
    
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Task"];
    NSArray *tasks = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    for (NSManagedObject *info in tasks) {
        
        if ( [[info valueForKey:@"node"] doubleValue] == self.boardID ) {
            
            if ([info valueForKey:@"id_attached"]!=NULL) {
            if ([self.taskID isEqualToNumber:[info valueForKey:@"id_attached"]]) {
                    
                [info setValue:candidate forKey:@"id_attached"];
                
            }
            }
            
        }

    }
    
    NSError *error = nil;
    
    if (![managedObjectContext save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    
}

-(NSNumber*) getPrimeObjectID {
    
    NSNumber* candidate = nil ;
    
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Task"];
    NSArray *tasks = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    for (NSManagedObject *info in tasks) {
        if ( [[info valueForKey:@"node"] doubleValue] == self.boardID ) {
            if ([info valueForKey:@"prime"]==[NSNumber numberWithInt:1]) {
                candidate = [info valueForKey:@"id"] ;
            }
        }
    }
    
    return candidate ;

}

- (IBAction)deleteTask:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete Fu"
                                                    message:@"Are you sure?"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:@"Nope", nil];
    
    [alert show];
    
}

@end
