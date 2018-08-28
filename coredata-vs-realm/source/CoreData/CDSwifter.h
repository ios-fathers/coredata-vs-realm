//
//  CDSwifter.h
//  coredata-vs-realm
//
//  Copyright © 2018 iOS Fathers. All rights reserved.
//

#import <CoreData/CoreData.h>

static NSString * const kCDSwifterLevelBaby = @"baby";
static NSString * const kCDSwifterLevelJunior = @"junior";

@class CDProject;

@interface CDSwifter : NSManagedObject
@property (nonatomic) int16_t age;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *level;
@property (nonatomic, copy) NSString *bio;
@property (nonatomic, retain) NSSet<CDProject*> *failedProjects;
@end
