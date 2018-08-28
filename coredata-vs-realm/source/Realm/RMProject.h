//
//  RMProject.h
//  coredata-vs-realm
//
//  Copyright © 2018 iOS Fathers. All rights reserved.
//

#import <Realm/Realm.h>

@interface RMProject : RLMObject
@property NSInteger bugs;
@property NSString *name;
@end

RLM_ARRAY_TYPE(RMProject)
