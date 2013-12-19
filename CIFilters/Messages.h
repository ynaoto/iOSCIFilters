//
//  Messages.h
//
//  Created by Naoto Yoshioka on 2013/12/19.
//  Copyright (c) 2013年 Naoto Yoshioka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Messages : NSObject
+ (instancetype)theMessages;

// サブクラス内で使う文字列をプロパティとして定義し、Localizable.strings 内ではプロパティ名をキーとして値を記述します。

@end
