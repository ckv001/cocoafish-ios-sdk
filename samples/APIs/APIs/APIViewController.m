//
//  APIViewController.m
//  APIs
//
//  Created by Wei Kong on 3/21/11.
//  Copyright 2011 Cocoafish Inc. All rights reserved.
//

#import "APIViewController.h"
#import "APIsAppDelegate.h"

@interface APIViewController ()

-(NSString *)arrayDescription:(NSArray *)array;
@end

@implementation APIViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(NSString *)arrayDescription:(NSArray *)array
{
    return [NSString stringWithFormat:@"{\n%@\n}", [array componentsJoinedByString:@"\n"]];
}

#pragma CCRequestDelegate callback
-(void)ccrequest:(CCRequest *)request didSucceed:(CCResponse *)response
{
    NSArray *types = [NSArray arrayWithObjects:NSStringFromClass([CCPhoto class]), NSStringFromClass([CCUser class]), NSStringFromClass([CCCheckin class]), NSStringFromClass([CCStatus class]), NSStringFromClass([CCEvent class]), NSStringFromClass([CCCollection class]), NSStringFromClass([CCKeyValuePair class]), NSStringFromClass([CCMessage class]), NSStringFromClass([CCPlace class]), NSStringFromClass([CCChat class]), nil];
    
    for (NSString *type in types) {
        Class class = NSClassFromString(type);
        NSArray *array = [response getObjectsOfType:class];
        if (array != nil) {
            NSLog(@"Received array of type %@: %@", type, array);
        }
    }

    statusLabel.text = @"Success";
    body.text = [NSString stringWithFormat:@"%@\n%@", [response.meta description], [response.response description]];
    if ([response.meta.methodName isEqualToString:@"createPlace"]) {
        CCPlace *place = [[response getObjectsOfType:[CCPlace class]] objectAtIndex:0];
        ((APIsAppDelegate *)[UIApplication sharedApplication].delegate).testPlace = place;
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:place.objectId forKey:@"test_place_id"];
    } else if ([response.meta.methodName isEqualToString:@"createPhoto"] && ((APIsAppDelegate *)[UIApplication sharedApplication].delegate).testPhoto == nil) {
        CCPhoto *photo = [[response getObjectsOfType:[CCPhoto class]] objectAtIndex:0];
        ((APIsAppDelegate *)[UIApplication sharedApplication].delegate).testPhoto = photo;
    } else if ([response.meta.methodName isEqualToString:@"createEvent"] && ((APIsAppDelegate *)[UIApplication sharedApplication].delegate).testEvent == nil) {
        CCEvent *event = [[response getObjectsOfType:[CCEvent class]] objectAtIndex:0];
        ((APIsAppDelegate *)[UIApplication sharedApplication].delegate).testEvent = event;
    } else if ([response.meta.methodName isEqualToString:@"createMessage"] && ((APIsAppDelegate *)[UIApplication sharedApplication].delegate).testMessage == nil) {
        CCMessage *message = [[response getObjectsOfType:[CCMessage class]] objectAtIndex:0];
        ((APIsAppDelegate *)[UIApplication sharedApplication].delegate).testMessage = message;
    } else if ([response.meta.methodName isEqualToString:@"deletePlace"]) {
        ((APIsAppDelegate *)[UIApplication sharedApplication].delegate).testPlace = nil;
    } else if ([response.meta.methodName isEqualToString:@"deletePhoto"]) {
        ((APIsAppDelegate *)[UIApplication sharedApplication].delegate).testPhoto = nil;
    } else if ([response.meta.methodName isEqualToString:@"deleteEvent"]) {
        ((APIsAppDelegate *)[UIApplication sharedApplication].delegate).testEvent = nil;
    } else if ([response.meta.methodName isEqualToString:@"deleteMessageThread"]) {
        ((APIsAppDelegate *)[UIApplication sharedApplication].delegate).testMessage = nil;
    }
       
}

-(void)ccrequest:(CCRequest *)request didFailWithError:(NSError *)error
{
    statusLabel.text = @"Failed";
    body.text = [error localizedDescription];   
}
@end
