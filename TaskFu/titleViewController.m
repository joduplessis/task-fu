//
//  titleViewController.m
//  TaskFu
//
//  Created by Johannes du Plessis on 2013/04/18.
//  Copyright (c) 2013 Johannes du Plessis. All rights reserved.
//

#import "titleViewController.h"
#import "editViewController.h"

@interface titleViewController ()

@end

@implementation titleViewController {
    NSArray *icons ;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    NSLog(@"%@", self.message) ;
    
    
    
    //self.tableControl.frame.size = CGSizeMake(50, 50) ;
    
    self.mainTextField.delegate = self;
    
    icons = [NSArray arrayWithObjects:@"apple.png",@"bulb.png",@"calendar.png",@"camera.png",@"cellphone.png",@"chat.png",@"clip.png",@"clouds.png",@"coffee.png",@"document.png",@"fire.png",@"hanger.png",@"hat.png",@"heart.png",@"ipod.png",@"map.png",@"message.png",@"paintbrush.png",@"phone.png",@"plane.png",@"present.png",@"rain.png",@"receiver.png",@"rocket.png",@"shopping.png",@"star.png",@"sun.png",@"time.png",@"tree.png",@"tv.png",nil];
    
    [super viewDidLoad];
    
    if ( [self.valueToEdit isEqualToString:@"Title"] ) {
        self.saveButton.enabled = NO ;
        [self.mainTextField becomeFirstResponder];
        self.mainTextField.text = self.valueToEditPlaceholder ;
        self.tableControl.hidden = YES ;
        self.anytimeButton.hidden = YES ;
        self.dateControl.hidden = YES ;
    }
    
    if ( [self.valueToEdit isEqualToString:@"Notes"] ) {
        self.saveButton.enabled = NO ;
        self.dateControl.hidden = YES ;
        [self.mainTextField becomeFirstResponder];
        self.mainTextField.text = self.valueToEditPlaceholder ;
        self.tableControl.hidden = YES ;
        self.anytimeButton.hidden = YES ;
    }
    
    if ( [self.valueToEdit isEqualToString:@"Icon"] ) {
        self.saveButton.enabled = NO ;
        self.dateControl.hidden = YES ;
        self.mainTextField.hidden = YES ;
        self.tableControl.hidden = NO ;
        self.anytimeButton.hidden = YES ;
    }
    
    if ( [self.valueToEdit isEqualToString:@"Link"] ) {
        self.saveButton.enabled = NO ;
        self.dateControl.hidden = YES ;
        [self.mainTextField becomeFirstResponder];
        self.mainTextField.text = self.valueToEditPlaceholder ;
        self.tableControl.hidden = YES ;
        self.anytimeButton.hidden = YES ;
    }
    
    if ( [self.valueToEdit isEqualToString:@"Date"] ) {
        self.mainTextField.hidden = YES ;
        self.tableControl.hidden = YES ;
    }



}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

// Here we save the title, notes & link

- (IBAction)hitReturn:(id)sender {
    
    NSString *value = self.mainTextField.text ;
    
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Task"];
    NSArray *tasks = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    if ( [self.valueToEdit isEqualToString:@"Title"] ) {
        for (NSManagedObject *info in tasks) {
            double temp = [[info valueForKey:@"node"] doubleValue] ;
            if ( (self.nodeID == temp) && ([self.taskID isEqualToNumber:[info valueForKey:@"id"]]) ) {
                [info setValue:value forKey:@"title"];
            }
        }
    }
    
    if ( [self.valueToEdit isEqualToString:@"Notes"] ) {
        for (NSManagedObject *info in tasks) {
            double temp = [[info valueForKey:@"node"] doubleValue] ;
            if ( (self.nodeID == temp) && ([self.taskID isEqualToNumber:[info valueForKey:@"id"]]) ) {
                [info setValue:value forKey:@"notes"];
            }
        }
    }
    
    if ( [self.valueToEdit isEqualToString:@"Link"] ) {
        for (NSManagedObject *info in tasks) {
            double temp = [[info valueForKey:@"node"] doubleValue] ;
            if ( (self.nodeID == temp) && ([self.taskID isEqualToNumber:[info valueForKey:@"id"]]) ) {
                [info setValue:value forKey:@"link"];
            }
        }
    }
    
    NSError *error = nil;
    
    if (![managedObjectContext save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
       
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)anytime:(id)sender {
    

    NSString *prettyVersion = @"Anytime";
    
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Task"];
    NSArray *tasks = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    NSNumber *alert = [NSNumber numberWithInt:0] ;
    
    for (NSManagedObject *info in tasks) {
        double temp = [[info valueForKey:@"node"] doubleValue] ;
        if ( (self.nodeID == temp) && ([self.taskID isEqualToNumber:[info valueForKey:@"id"]]) ) {
            [info setValue:prettyVersion forKey:@"time"];
            [info setValue:alert forKey:@"seenalert"];
        }
    }
    
    NSError *error = nil;
    
    if (![managedObjectContext save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    
    [self.navigationController popViewControllerAnimated:YES];

    
    
    
}

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

// Save the date

- (IBAction)saveButtonAction:(id)sender {
    

    NSDate *myDate = self.dateControl.date;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"cccc, MMM d, hh:mm aa y"];
    NSString *prettyVersion = [dateFormat stringFromDate:myDate];
    
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Task"];
    NSArray *tasks = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    NSNumber *alert = [NSNumber numberWithInt:0] ;
    
    for (NSManagedObject *info in tasks) {
        double temp = [[info valueForKey:@"node"] doubleValue] ;
        if ( (self.nodeID == temp) && ([self.taskID isEqualToNumber:[info valueForKey:@"id"]]) ) {
            [info setValue:prettyVersion forKey:@"time"];
            [info setValue:alert forKey:@"seenalert"];
        }
    }
    
    NSError *error = nil;
    
    if (![managedObjectContext save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    

    
    // process date 
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"cccc, MMM d, hh:mm aa y";
    
    NSDate *dateFromString = [[NSDate alloc] init];
    dateFromString = [formatter dateFromString:prettyVersion];
    
    NSDate *todayDeadline = [NSDate date] ;
    NSDate *thenDeadline = dateFromString ;
    NSComparisonResult result = [todayDeadline compare:thenDeadline];
    
    // part of the copied code
    
    NSDate *currentDate = thenDeadline;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setSecond:1];
    NSCalendar *calendars = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *tdate = [calendars dateByAddingComponents:comps toDate:currentDate options:0];
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    
    NSDate *pickerDate = tdate;
    NSDateComponents *dateComponents = [calendar components:( NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit )
                                                   fromDate:pickerDate];
    NSDateComponents *timeComponents = [calendar components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit )
                                                   fromDate:pickerDate];
    
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    [dateComps setDay:[dateComponents day]];
    [dateComps setMonth:[dateComponents month]];
    [dateComps setYear:[dateComponents year]];
    [dateComps setHour:[timeComponents hour]];
    [dateComps setMinute:[timeComponents minute]];
    [dateComps setSecond:[timeComponents second]];
    NSDate *itemDate = [calendar dateFromComponents:dateComps];
    
    // create the notification
    
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif == nil)
        return;
    
    localNotif.fireDate = itemDate;
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    localNotif.alertBody = self.message;
    localNotif.alertAction = @"View";
    localNotif.soundName = UILocalNotificationDefaultSoundName;

    localNotif.applicationIconBadgeNumber = [self getDateArrayIndex:currentDate] ;
    
    NSDictionary *infoDict = [NSDictionary dictionaryWithObject:@"someValue" forKey:@"someKey"];
    localNotif.userInfo = infoDict;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (int) getDateArrayIndex:(NSDate*)date {
    
    // Here we cycle through all the tasks and compare dates
    
    int taskCounter = 0 ;
    int hitCounter = 0;
    int counter = 0;
    
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Task"];
    NSArray *tasks = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    NSMutableArray *allDates = [NSMutableArray array] ;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"cccc, MMM d, hh:mm aa y";
    
    for (NSManagedObject *info in tasks) {
        
        NSNumber *seenalert = [info valueForKey:@"seenalert"] ;
        NSString *date = [info valueForKey:@"time"] ;
        
        if (![date isEqual: @"Anytime"]) {
            
            // Here we convert our date string to a date object

            NSDate *dateFromString = [[NSDate alloc] init];
            dateFromString = [formatter dateFromString:date];
            
            if ( (seenalert==[NSNumber numberWithInt:0]) || (seenalert==nil)) {
                
                [allDates addObject:dateFromString];
                counter++ ;
                
            }
            
        }
        
    }
    
    // now we sort our array
    
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"self" ascending:YES];
    NSArray *descriptors = [NSArray arrayWithObject: descriptor];
    NSArray *reverseOrder = [allDates sortedArrayUsingDescriptors:descriptors];
    
    for (id object in reverseOrder) {
        
        NSLog(@"%@",[formatter stringFromDate:object]);
        
        if ([object timeIntervalSinceDate:date] == 0) {
            hitCounter = taskCounter ;
            NSLog(@"%i",hitCounter+1);
        }
        
        taskCounter++; 
        
    }
    

    
    return hitCounter + 1;

    
    
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


// icon stuff

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [icons count] ;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    return @"Choose a new icon.";

}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"cells" ;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier] ;
    
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier] ;
    }
    
    NSString *file = [icons objectAtIndex:indexPath.row] ;
    NSString *iconColorcode = @"ed" ;
    NSString *iconName = [iconColorcode stringByAppendingString:file];

    cell.imageView.image = [UIImage imageNamed:iconName];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *file = [icons objectAtIndex:indexPath.row];
    
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Task"];
    NSArray *tasks = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    for (NSManagedObject *info in tasks) {
        double temp = [[info valueForKey:@"node"] doubleValue] ;
        if ( (self.nodeID == temp) && ([self.taskID isEqualToNumber:[info valueForKey:@"id"]]) ) {
            NSNumber *temp = [info valueForKey:@"id_attached"];
            NSLog(@"%@", temp) ;
            [info setValue:file forKey:@"icon"];
            
        }
    }
    
    NSError *error = nil;
    
    if (![managedObjectContext save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    
    if ( [self.valueToEdit isEqualToString:@"Title"] ) {
        
        
        
        if ([self.mainTextField.text length] > 20) {
            self.mainTextField.text = [self.mainTextField.text substringToIndex:20];
            return NO;
        }
        
        return YES;
        
        
    } else {
        
        return YES;
    }
    

    
    
    
    
}

@end
