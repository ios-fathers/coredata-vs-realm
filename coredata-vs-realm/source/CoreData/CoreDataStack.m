//
//  CoreDataStack.m
//  coredata-vs-realm
//
//  Copyright © 2018 iOS Fathers. All rights reserved.
//

#import "CoreDataStack.h"

@interface CoreDataStack()
@property (nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, readwrite) NSManagedObjectContext *managedObjectContext;
@end

@implementation CoreDataStack

-(NSPersistentStoreCoordinator *) persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil)
        return _persistentStoreCoordinator;
    
    NSURL *storeDirectoryURL = [[[NSFileManager defaultManager] URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
    storeDirectoryURL = [storeDirectoryURL URLByAppendingPathComponent:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]];
    [[NSFileManager defaultManager] createDirectoryAtURL:storeDirectoryURL withIntermediateDirectories:YES attributes:nil error:nil];
    NSURL *storeURL = [storeDirectoryURL URLByAppendingPathComponent:@"data.sqlite"];

    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:0 error:&error])
    {
        NSLog(@"NSPersistentStoreCoordinator persistent store initialization error %@", error);
        _persistentStoreCoordinator = nil;
    }

    return _persistentStoreCoordinator;
}

-(NSManagedObjectModel *) managedObjectModel
{
    if (_managedObjectModel != nil)
        return _managedObjectModel;
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"data" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

-(NSManagedObjectContext *) managedObjectContext
{
    if (_managedObjectContext != nil)
        return _managedObjectContext;
    
    NSPersistentStoreCoordinator *coordinator = self.persistentStoreCoordinator;
    if (coordinator != nil)
    {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    
    return _managedObjectContext;
}

@end
