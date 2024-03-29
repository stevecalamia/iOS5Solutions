//
//  BNRImageStore.m
//  Homepwner
//
//  Created by joeconway on 9/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "BNRImageStore.h"

@implementation BNRImageStore
+ (id)allocWithZone:(NSZone *)zone
{
    return [self defaultImageStore];
}

+ (BNRImageStore *)defaultImageStore
{
    static BNRImageStore *defaultImageStore = nil;
    if (!defaultImageStore) {
        // Create the singleton
        defaultImageStore = [[super allocWithZone:NULL] init];
    }
    return defaultImageStore;
}

- (id)init {
    self = [super init];
    if (self) {
        dictionary = [[NSMutableDictionary alloc] init];
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self 
               selector:@selector(clearCache:) 
                   name:UIApplicationDidReceiveMemoryWarningNotification 
                 object:nil];
    }
    return self;
}
- (void)clearCache:(NSNotification *)note
{
    NSLog(@"flushing %d images out of the cache", [dictionary count]);
    [dictionary removeAllObjects];
}
- (void)setImage:(UIImage *)i forKey:(NSString *)s
{
    [dictionary setObject:i forKey:s];
    
    // Create full path for image
    NSString *imagePath = pathInDocumentDirectory(s);
    
    // Turn image into JPEG data,
    NSData *d = UIImageJPEGRepresentation(i, 0.5);
    
    // Write it to full path
    [d writeToFile:imagePath atomically:YES];
}
- (UIImage *)imageForKey:(NSString *)s
{
    // If possible, get it from the dictionary
    UIImage *result = [dictionary objectForKey:s];
    
    if (!result) {
        // Create UIImage object from file
        result = [UIImage imageWithContentsOfFile:pathInDocumentDirectory(s)];
        
        // If we found an image on the file system, place it into the cache
        if (result)
            [dictionary setObject:result forKey:s];
        else
            NSLog(@"Error: unable to find %@", pathInDocumentDirectory(s));
    }
    return result;
}
- (void)deleteImageForKey:(NSString *)s
{
    if(!s)
        return;
    [dictionary removeObjectForKey:s];
    
    NSString *path = pathInDocumentDirectory(s);
    [[NSFileManager defaultManager] removeItemAtPath:path
                                               error:NULL];
}
@end
