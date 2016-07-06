//
//  NSArray+HBExt.m
//  LediKWB
//
//  Created by ChunGuo on 15/12/24.
//  Copyright © 2016年 huxijun. All rights reserved.
//

#import "NSArray+HBExt.h"
#import "objc/runtime.h"
#import "objc/message.h"

static char jianPinyinKey;
static char allPinyinKey;

@implementation NSArray (FuzzyQuery)

/**
 *  初始化搜索数据（包含简拼与全拼）
 *
 *  @param model id类型
 *  @param searchUserName 需要处理的搜索名称
 */
- (void)initSearchData:(id)model searchUserName:(NSString*)searchUserName
{
    //及时释放初始化字符串，节省内存
    @autoreleasepool
    {
        //去除两端的空格
        NSString* userName = [searchUserName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if(userName && userName.length > 0)
        {
            //判断是否为中文的正则表达式
            NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"[\u4e00-\u9fa5]"];
            NSString* jianPinKey = @"";//简写拼音
            NSString* allPinKey = @"";//全写拼音
            //遍历名称
            for(int idx = 0; idx < userName.length;idx++)
            {
                NSString* name = [userName substringWithRange:NSMakeRange(idx, 1)];
                //此项非中文
                if(![predicate evaluateWithObject:name])
                {
                    jianPinKey = [jianPinKey stringByAppendingString:name];
                    allPinKey = [allPinKey stringByAppendingString:name];
                }
                else//中文（转换拼音）
                {
                    NSMutableString *ms = [[NSMutableString alloc] initWithString:name];
                    //第一步转换为带声调的拼音
                    if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO))
                    {
                        //去除声调
                        if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO))
                        {
                            allPinKey = [allPinKey stringByAppendingString:ms];
                            jianPinKey = [jianPinKey stringByAppendingString:[NSString stringWithFormat:@"%c",[ms characterAtIndex:0]]];
                        }
                    }
                }
            }
            //简拼存在即关联
            objc_setAssociatedObject(model, &jianPinyinKey, jianPinKey, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            //全拼存在即关联
            objc_setAssociatedObject(model, &allPinyinKey, allPinKey, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    };
    
}



- (NSMutableArray*)getSearchContentList:(NSString*)searchText searchNameSelector:(SEL)searchNameSelector selectSelector:(SEL)selectSelector, ...
{
    NSMutableArray* result = [[NSMutableArray alloc] init];
    if(self.count == 0 || searchText.length == 0)//个数为空或者搜索内容为空 返回空数组
    {
        NSLog(@"列表数据为空或者搜索字段为空");
        return result;
    }
    
    for(int index = 0; index < self.count; index++)
    {
        id model = [self objectAtIndex:index];//数组每一项内容
        NSString* searchUserName = nil;//搜索名字属性字段
        
        if(model && [model isKindOfClass:[NSString class]])//分为2种（1.数组中为字符串）
        {
            searchUserName = [self objectAtIndex:index];//获取名字
        }
        else if(model && [model respondsToSelector:searchNameSelector])//(2.其它类型)
        {
            searchUserName = objc_msgSend(model,searchNameSelector);//获取名字
        }
        
        //获取插入的2个关联的属性
        NSString* jianKeyName = objc_getAssociatedObject(model, &jianPinyinKey);
        NSString* allKeyName = objc_getAssociatedObject(model, &allPinyinKey);
        
        if(!jianKeyName || !allKeyName)
        {
            //model里面没有关联简拼，则进行数据处理
            [self initSearchData:model searchUserName:searchUserName];
            jianKeyName = objc_getAssociatedObject(model, &jianPinyinKey);
            allKeyName = objc_getAssociatedObject(model, &allPinyinKey);
        }
        
        //转为小写（大小写匹配）
        NSString* lowerSearchText = [searchText lowercaseString];
        searchUserName = searchUserName ? [searchUserName lowercaseString] : nil;
        jianKeyName = jianKeyName ? [jianKeyName lowercaseString] : nil;
        allKeyName = allKeyName ? [allKeyName lowercaseString] : nil;
        
        //此为模糊查询，搜索子串
        if((searchUserName && jianKeyName && allKeyName) &&
           ([searchUserName rangeOfString:lowerSearchText].location != NSNotFound
            || [jianKeyName rangeOfString:lowerSearchText].location != NSNotFound
            || [allKeyName rangeOfString:lowerSearchText].location != NSNotFound)
           )
        {
            //设置标识删除项为YES
            if(selectSelector && [model respondsToSelector:selectSelector])
            {
                objc_msgSend(model, selectSelector,YES);
            }
            [result addObject:model];
        }
        else
        {
            BOOL isFind = NO;//是否找到
            va_list args;//可变参数列表
            va_start(args, selectSelector);//查询selectSelector后得参数
            
            SEL selector;
            while((selector = va_arg(args, SEL)))//获取每一项参数
            {
                if(selector && [model respondsToSelector:selector])
                {
                    NSString* other = objc_msgSend(model, selector);
                    other = other ? [other lowercaseString] : nil;
                    if(other && [other rangeOfString:lowerSearchText].location != NSNotFound)
                    {
                        //找到
                        if(selectSelector && [model respondsToSelector:selectSelector])
                        {
                            objc_msgSend(model, selectSelector,YES);
                        }
                        [result addObject:model];
                        isFind = YES;
                        break;
                    }
                }
                else
                {
                    break;
                }
            }
            
            va_end(args);
            
            //没有找到
            if(!isFind)
            {
                if(selectSelector && [model respondsToSelector:selectSelector])
                {
                    objc_msgSend(model, selectSelector,NO);
                }
            }
            
        }
        
    }
    return result;
}

@end
