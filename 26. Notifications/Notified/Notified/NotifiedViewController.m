//
//  NotifiedViewController.m
//  Notified
//
//  Created by joeconway on 9/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "NotifiedViewController.h"

@implementation NotifiedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
            // Search for all http servers on the local area network
        browser = [[NSNetServiceBrowser alloc] init];
        [browser setDelegate:self];
        [browser searchForServicesOfType:@"_http._tcp." inDomain:@""];
    }
    return self;
}

- (void)netService:(NSNetService *)sender didNotResolve:(NSDictionary *)errorDict
{
    // Couldn't figure out the address... 
    [statusLabel setText:@"Could not resolve service."];
    NSLog(@"%@", errorDict);

    resolvingService = nil;
}

- (void)netServiceDidResolveAddress:(NSNetService *)sender
{
    desktopServer = resolvingService;
    resolvingService = nil;
    [statusLabel setText:@"Resolved service..."];
}
- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser 
           didFindService:(NSNetService *)aNetService 
               moreComing:(BOOL)moreServicesComing
{
    // Looking for an HTTP service, but only one with the name CocoaHTTPServer
    if (!resolvingService && [[aNetService name] isEqualToString:@"CocoaHTTPServer"]) {
        resolvingService = aNetService;
        [resolvingService resolveWithTimeout:30];
        [resolvingService setDelegate:self];
        [statusLabel setText:@"Resolving CocoaHTTPServer..."];
    } else {
        NSLog(@"ignoring %@", aNetService);
    }
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

@end
