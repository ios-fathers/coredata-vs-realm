//
//  RMSwifter.h
//  coredata-vs-realm
//
//  Copyright © 2018 iOS Fathers. All rights reserved.
//

#import <Realm/Realm.h>
#import "RMProject.h"

static NSString * const kRMSwifterLevelBaby = @"baby";
static NSString * const kRMSwifterLevelJunior = @"junior";

@interface RMSwifter : RLMObject
@property NSInteger age;
@property NSString *name;
@property NSString *level;
@property NSString *bio;
@property RLMArray<RMProject *><RMProject> *failedProjects;
@end
