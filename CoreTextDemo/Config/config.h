//
//  config.h
//  CoreTextDemo
//
//  Created by Terra MacBook on 16/8/2.
//  Copyright © 2016年 Jianbing Zhou. All rights reserved.
//

#ifndef config_h
#define config_h

#pragma mark - 头文件

#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "NSObject+JBKeyValue.h"

#pragma mark - 自定义blcok类型

typedef void(^ReturnValueCallback)(id returnValue);
typedef void(^ErrorCodeCallback)(id errorCode);
typedef void(^FailureCallback)();

#endif /* config_h */
