//
//  CocoaServerAppDelegate.m
//  CocoaServer
//
//  Created by joeconway on 9/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CocoaServerAppDelegate.h"

@implementation CocoaServerAppDelegate

@synthesize window = _window;
@synthesize statusField = _statusField;
@synthesize tableView = _tableView;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    registeredUsers = [[NSMutableArray alloc] init];

    // Create a service object that will advertise the server's existence 
    // on the local network
    service = [[NSNetService alloc] initWithDomain:@"" 
                                              type:@"_http._tcp." 
                                              name:@"CocoaHTTPServer" 
                                              port:10000];
    [service setDelegate:self];
    [service publish];
}
- (void)netServiceDidPublish:(NSNetService *)sender
{
    // When the service succeeds in publishing...
    [[self statusField] setStringValue:@"Server is advertising"];
}

- (void)netServiceDidStop:(NSNetService *)sender
{
    // If the service stops for some reason...
    [[self statusField] setStringValue:@"Server is not advertising"];
}

- (void)netService:(NSNetService *)sender didNotPublish:(NSDictionary *)errorDict
{
    // If the service fails to publish, either immediately or in the future...
    [[self statusField] setStringValue:@"Server is not advertising"];
}
@end
