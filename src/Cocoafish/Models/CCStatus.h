//
//  CCStatus.h
//  Cocoafish-ios-sdk
//
//  Created by Wei Kong on 2/6/11.
//  Copyright 2011 Cocoafish Inc. All rights reserved.
//

#import "CCObjectWithPhoto.h"

@class CCUser;
@interface CCStatus : CCObjectWithPhoto {

	NSString *_message;
    CCUser *_user;
}

@property (nonatomic, retain, readonly) NSString *message;
@property (nonatomic, retain, readonly) CCUser *user;

@end
