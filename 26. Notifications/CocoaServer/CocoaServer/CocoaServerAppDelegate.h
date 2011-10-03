//
//  CocoaServerAppDelegate.h
//  CocoaServer
//
//  Created by joeconway on 9/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CocoaServerAppDelegate : NSObject <NSApplicationDelegate, NSNetServiceDelegate, 
    NSTableViewDataSource, NSTableViewDelegate>
{
    NSNetService *service;
    NSMutableArray *registeredUsers;
}
@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTextField *statusField;
@property (weak) IBOutlet NSTableView *tableView;

@end
