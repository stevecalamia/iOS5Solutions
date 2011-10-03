//
//  NotifiedViewController.h
//  Notified
//
//  Created by joeconway on 9/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//



@interface NotifiedViewController : UIViewController <NSNetServiceBrowserDelegate, NSNetServiceDelegate>
{
    NSNetService *resolvingService;
    NSNetService *desktopServer;
    NSNetServiceBrowser *browser;
    __weak IBOutlet UILabel *statusLabel;
}
@end
