//
//  HBSKPayService.h
//  MoJing-iPhone
//
//  Created by xijun on 15/9/17.
//  Copyright (c) 2015年 duan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HBSKPayServiceDelegate <NSObject>
/**
 *  获取商品信息
 *
 */
-(void)inAppPurchase_LoadProduct:(NSString*)msg;
/**
 *  获取商品信息失败
 *
 */
-(void)inAppPurchase_LoadProductFail;
/**
 *  开始支付
 *
 */
-(void)inAppPurchase_InPay;
/**
 *  支付成功
 *
 */
-(void)inAppPurchase_PaySuccess;
/**
 *  支付失败
 *
 */
-(void)inAppPurchase_PayFail:(NSString*)errorMsg;
/**
 *  支付恢复
 *
 */
-(void)inAppPurchase_PayRestored;
/**
 *  连接服务器
 *
 */
-(void)inAppPurchase_ConnectServer:(NSString*)payReceipt;
/**
 *  连接服务器成功
 *
 */
-(void)inAppPurchase_ConnectServerSuccess:(NSString*)errorMsg;
/**
 *  连接服务器失败
 *
 */
-(void)inAppPurchase_ConnectServerFail:(NSString*)errorMsg;

@end

@interface HBSKPayService : NSObject

@property(nonatomic,weak) id<HBSKPayServiceDelegate> payDelegate;

+ (instancetype)defaultService;

/**
 *  连接苹果服务器
 *
 *  @param modou 魔豆数
 */
-(void)requestTier:(NSInteger)modou;

/**
 *  连接正式苹果服务器
 *
 *  @param modou 魔豆数
 */
-(void)requestNewTier:(NSInteger)modou;

/**
 *  取消魔豆充值
 *
 */
-(void)cancelTier;

/**
 *  等级1
 *
 */
-(void)requestTier1;
/**
 *  等级2
 *
 */
-(void)requestTier2;

@end
