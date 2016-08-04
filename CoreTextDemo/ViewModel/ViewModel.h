//
//  ViewModel.h
//  CoreTextDemo
//
//  Created by Terra MacBook on 16/8/3.
//  Copyright © 2016年 Jianbing Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ViewModel : NSObject
@property (nonatomic,copy) ReturnValueCallback returnValueCallback;
@property (nonatomic,copy) ErrorCodeCallback errorCodeCallback;
@property (nonatomic,copy) FailureCallback failureCallback;

//类似一个合并的set方法 方便传值
- (void)setCallbackWithReturnCallBack:(ReturnValueCallback)returnCallBack
                WithErrorCodeCallBack:(ErrorCodeCallback)errorCodeCallBack
                  WithFailureCallBack:(FailureCallback)failureCallBack;
@end
