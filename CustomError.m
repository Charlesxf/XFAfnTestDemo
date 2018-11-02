//
//  CustomError.m
//  mobile
//
//  Created by 杨国强 on 15/6/3.
//  Copyright (c) 2015年 ygq. All rights reserved.
//

#import "CustomError.h"

@implementation CustomError {
    NSString* _localizedDescription;
}

- (id)initWithDomain:(NSString *)domain
                code:(NSInteger)code
            userInfo:(NSDictionary *)userInfo
localizedDescription:(NSString *)localizedDescription {
    self = [super initWithDomain:domain code:code userInfo:userInfo];
    [self setLocalizedDescription:localizedDescription];
    return self;
}

- (void)setLocalizedDescription:(NSString*)desc {
    _localizedDescription = desc;
}

- (NSString*)localizedDescription {
    return _localizedDescription;
}

@end
