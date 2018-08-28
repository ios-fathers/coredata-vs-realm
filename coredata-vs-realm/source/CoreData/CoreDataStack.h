//
//  CoreDataStack.h
//  coredata-vs-realm
//
//  Copyright © 2018 iOS Fathers. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface CoreDataStack : NSObject
@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;
@end
