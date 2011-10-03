//
//  BNRItemStore.m
//  Homepwner
//
//  Created by joeconway on 8/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "BNRItemStore.h"
#import "BNRItem.h"
#import "BNRImageStore.h"

@implementation BNRItemStore



+ (BNRItemStore *)defaultStore
{
    static BNRItemStore *defaultStore = nil;
    if(!defaultStore)
        defaultStore = [[super allocWithZone:nil] init];
        
    return defaultStore;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self defaultStore];
}

- (void)fetchItemsIfNecessary
{
    // If we don't currently have an allItems array, try to read one from disk
    if (!allItems) {
        NSString *path = [self itemArchivePath];
        allItems = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    }
    // If we tried to read one from disk but does not exist, then create a new one
    if (!allItems) {
        allItems = [[NSMutableArray alloc] init];
    }
}


- (NSString *)itemArchivePath
{
    // The returned path will be Sandbox/Documents/items.data
    // Both the saving and loading methods will call this method to get the same path,
    // preventing a typo in the path name of either method
    return pathInDocumentDirectory(@"items.data");
}

- (BOOL)saveChanges
{
    // returns success or failure
    return [NSKeyedArchiver archiveRootObject:allItems
                                       toFile:[self itemArchivePath]];
}

- (id)init 
{
    self = [super init];
    if(self) {
        
    }
    return self;
}

- (void)removeItem:(BNRItem *)p
{
    NSString *key = [p imageKey];
    [[BNRImageStore defaultImageStore] deleteImageForKey:key];
    
    [allItems removeObjectIdenticalTo:p];
}

- (NSArray *)allItems
{
    [self fetchItemsIfNecessary];
    return allItems;
}

- (void)moveItemAtIndex:(int)from
                toIndex:(int)to
{
    if (from == to) {
        return;
    }
    // Get pointer to object being moved so we can re-insert it
    BNRItem *p = [allItems objectAtIndex:from];

    // Remove p from array
    [allItems removeObjectAtIndex:from];

    // Insert p in array at new location
    [allItems insertObject:p atIndex:to];
}

- (BNRItem *)createItem
{
    [self fetchItemsIfNecessary];
    
    BNRItem *p = [[BNRItem alloc] init];

    [allItems addObject:p];
   
    return p;
}
@end
