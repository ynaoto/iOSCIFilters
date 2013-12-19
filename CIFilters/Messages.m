//
//  Messages.m
//
//  Created by Naoto Yoshioka on 2013/12/19.
//  Copyright (c) 2013年 Naoto Yoshioka. All rights reserved.
//

#import "Messages.h"
#import <objc/runtime.h>

@implementation Messages

static bool internalUse = NO;

+ (id)alloc
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    if (!internalUse) {
        [self doesNotRecognizeSelector:_cmd];
        return nil;
    }
    
    return [super allocWithZone:zone];
}

- (id)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (id)initMessages
{
    if (!internalUse) {
        [self doesNotRecognizeSelector:_cmd];
        return nil;
    }
    
    self = [super init];
    if (self) {
        NSBundle *mainBundle = [NSBundle mainBundle];
        
        unsigned int outCount;
        objc_property_t *properties = class_copyPropertyList(self.class, &outCount);
        for (unsigned int i = 0; i < outCount; i++) {
            objc_property_t p = properties[i];
            const char *s = property_getName(p);
            NSString *key = [NSString stringWithUTF8String:s];
            NSString *fallbackValue = [NSString stringWithFormat:@"###%@###", key];
            NSString *value = [mainBundle localizedStringForKey:key value:fallbackValue table:nil];
//            NSString *value = NSLocalizedString(key, @"comment"); // genstrings が使えるメリットはあるけど、今回は手動でやります。
            [self setValue:value forKey:key];
        }
        free(properties);
    }
    return self;
}

+ (instancetype)theMessages
{
    static Messages *theMessages = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        internalUse = YES;
        theMessages = [[super alloc] initMessages];
        internalUse = NO;
    });
    return theMessages;
}

@end
