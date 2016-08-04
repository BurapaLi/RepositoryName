//
//  ViewModel.m
//  CoreTextDemo
//
//  Created by Terra MacBook on 16/8/3.
//  Copyright © 2016年 Jianbing Zhou. All rights reserved.
//

#import "ViewModel.h"

@implementation ViewModel

//类似一个合并的set方法 方便传值
- (void)setCallbackWithReturnCallBack:(ReturnValueCallback)returnCallBack
                WithErrorCodeCallBack:(ErrorCodeCallback)errorCodeCallBack
                  WithFailureCallBack:(FailureCallback)failureCallBack {
    _returnValueCallback = returnCallBack;
    _errorCodeCallback = errorCodeCallBack;
    _failureCallback = failureCallBack;
}

@end
