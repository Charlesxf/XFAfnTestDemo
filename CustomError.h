//
//  CustomError.h
//  mobile
//
//  Created by 杨国强 on 15/6/3.
//  Copyright (c) 2015年 ygq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomError : NSError
- (id)initWithDomain:(NSString *)domain
                code:(NSInteger)code
            userInfo:(NSDictionary *)userInfo
localizedDescription:(NSString*)localizedDescription;
@end
