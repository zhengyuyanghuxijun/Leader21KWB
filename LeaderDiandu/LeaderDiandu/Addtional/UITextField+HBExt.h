//
//  UITextField+HBExt.h
//  LediKWB
//
//  Created by ChunGuo on 15/12/24.
//  Copyright © 2016年 huxijun. All rights reserved.
//

@interface UITextField (LengthLimit)

/**
 *  限制输入长度
 *
 *  @param limitMax 限制的长度
 *  @param target   action所在的Target（比如***ViewController；不实现action的话，传nil即可）
 *  @param action   超出限制长度触发事件（不需要实现action的话，传nil即可）
 */
- (void)addLengthLimit:(int)limitMax target:(id)target action:(SEL)action;

@end
