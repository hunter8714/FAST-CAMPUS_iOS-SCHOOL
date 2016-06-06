//
//  DataCenter.h
//  LoginPage
//
//  Created by Mijeong Jeon on 6/3/16.
//  Copyright © 2016 Mijeong Jeon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataCenter : NSObject

+ (instancetype)sharedInstance;
- (NSArray *)findUserInfo;
- (void)addUserInfoWithID:(NSString *)ID andEmail:(NSString *)email andPassword:(NSString *)password;

@end