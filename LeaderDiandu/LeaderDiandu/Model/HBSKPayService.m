//
//  HBSKPayService.m
//  MoJing-iPhone
//
//  Created by xijun on 15/9/17.
//  Copyright (c) 2015年 duan. All rights reserved.
//

#import "HBSKPayService.h"
#import <StoreKit/StoreKit.h>

#define KWBTierMonth1   @"kwbios_tier6"
#define KWBTierMonth3   @"kwbios_tier8"
#define KWBTierMonth6   @"kwbios_tier27"
#define KWBTierMonth12  @"kwbios_tier51"

@interface HBSKPayService () < SKPaymentTransactionObserver,SKProductsRequestDelegate >
{
    SKProductsRequest *productsRequest;
}
@end

@implementation HBSKPayService

+ (instancetype)defaultService
{
    static id instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        static dispatch_once_t predicate;
        dispatch_once(&predicate, ^{
            [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        });
    }
    return self;
}

- (void)requestTierByMonth:(NSInteger)months
{
    NSString *requestStr = nil;
    if (months == 1) {
        requestStr = KWBTierMonth1;
    } else if (months == 3) {
        requestStr = KWBTierMonth3;
    } else if (months == 6) {
        requestStr = KWBTierMonth6;
    } else if (months == 12) {
        requestStr = KWBTierMonth12;
    }
    [self requestPremium:requestStr];
}

-(void)cancelTier
{
    if (productsRequest) {
        [productsRequest cancel];
        productsRequest = nil;
    }
}

-(void)requestTier1{
    [self requestPremium:KWBTierMonth3];
}

-(void)requestPremium:(NSString*)productIdentifiers{
    if (!productsRequest) {
        if (self.payDelegate) {
            [self.payDelegate inAppPurchase_LoadProduct:@"开始连接AppStore获取产品"];
        }
        productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject: productIdentifiers]];
        productsRequest.delegate =self;
        [productsRequest start];
    }else{
        if (self.payDelegate) {
            [self.payDelegate inAppPurchase_LoadProductFail];
        }
    }
}
#pragma mark SKProductsRequestDelegate
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    NSArray *skProducts = response.products;
    if (skProducts&&skProducts.count>0) {
        if (self.payDelegate) {
            [self.payDelegate inAppPurchase_InPay];
        }
        SKProduct *product=[skProducts objectAtIndex:0];
        SKPayment *payment = [SKPayment paymentWithProduct:product];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
        if (self.payDelegate) {
            [self.payDelegate inAppPurchase_LoadProduct:[NSString stringWithFormat:@"获取到产品:%@",product.localizedTitle]];
        }
        NSLog(@"获取到产品 %@",product.localizedTitle);
    }else{
        if (self.payDelegate) {
            [self.payDelegate inAppPurchase_LoadProductFail];
        }
        NSLog(@"没有获取到产品信息");
        productsRequest=nil;
    }
}

#pragma mark SKPaymentTransactionObserver
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions NS_AVAILABLE_IOS(3_0){
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:
                NSLog(@"购买成功");
                if (self.payDelegate) {
                    [self.payDelegate inAppPurchase_PaySuccess];
                }
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                NSLog(@"购买失败 %@",transaction.error.localizedDescription);
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                if (self.payDelegate) {
                    [self.payDelegate inAppPurchase_PayRestored];
                }
                [self restoreTransaction:transaction];
            default:
                break;
        }
    }
}

-(void)completeTransaction: (SKPaymentTransaction *)transaction
{
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[[NSBundle mainBundle] appStoreReceiptURL]];
    NSError *error = nil;
//    NSString *productIdentifier = transaction.payment.productIdentifier;
    NSString *transactionID = transaction.transactionIdentifier;
    NSData *receiptData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:&error];
    if (receiptData&&!error) {
        NSLog(@"购买成功:%@",receiptData);
//        [self verifyPayReceipt:[self base64Encoding:receiptData]];
        if (self.payDelegate) {
            [self.payDelegate inAppPurchase_ConnectServer:[self base64Encoding:receiptData] transactionID:transactionID];
        }
    }else{
        if (self.payDelegate) {
            [self.payDelegate inAppPurchase_PayFail:@"没有获取到购买凭证"];
        }
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    productsRequest=nil;
}

-(void)failedTransaction: (SKPaymentTransaction *)transaction{
    NSString *errorMsg=nil;
    if (transaction.error.localizedDescription) {
        errorMsg=transaction.error.localizedDescription;
        //        [self postAlertWithText:transaction.error.localizedDescription];
    }
    else{
        errorMsg=@"购买失败";
        //        [self postAlertWithText:@"购买失败"];
    }
    if (self.payDelegate) {
        [self.payDelegate inAppPurchase_PayFail:errorMsg];
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    productsRequest=nil;
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[[NSBundle mainBundle] appStoreReceiptURL]];
    NSError *error = nil;
    NSString *transactionID = transaction.transactionIdentifier;
    NSData *receiptData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:&error];
    if (receiptData&&!error) {
        NSLog(@"购买成功:%@",receiptData);
        if (self.payDelegate) {
            [self.payDelegate inAppPurchase_ConnectServer:[self base64Encoding:receiptData] transactionID:transactionID];
        }
        //        [self vipPay:[self base64Encoding:receiptData]];
    }else{
        if (self.payDelegate) {
            [self.payDelegate inAppPurchase_PayFail:@"没有获取到购买凭证"];
        }
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    productsRequest=nil;
}

- (void)verifyPayReceipt:(NSString *)payReceipt
{
    NSURL *sandboxStoreURL = [[NSURL alloc] initWithString:@"https://sandbox.itunes.apple.com/verifyReceipt"];
    NSData *postData = [NSData dataWithBytes:[payReceipt UTF8String] length:[payReceipt length]];
    NSMutableURLRequest *connectionRequest = [NSMutableURLRequest requestWithURL:sandboxStoreURL];
    [connectionRequest setHTTPMethod:@"POST"];
    [connectionRequest setTimeoutInterval:20.0];
    [connectionRequest setCachePolicy:NSURLRequestUseProtocolCachePolicy];
    [connectionRequest setHTTPBody:postData];
    
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:connectionRequest returningResponse:nil error:&error];
    NSString *str = [[NSString alloc] initWithBytes:data.bytes length:[data length] encoding:NSUTF8StringEncoding];
    NSLog(@"%@", str);
}

static const char base64EncodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

- (NSString *)base64Encoding:(NSData*)convertData;
{
    if ([convertData length] == 0)
        return @"";
    
    char *characters = malloc((([convertData length] + 2) / 3) * 4);
    if (characters == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (i < [convertData length])
    {
        char buffer[3] = {0,0,0};
        short bufferLength = 0;
        while (bufferLength < 3 && i < [convertData length])
            buffer[bufferLength++] = ((char *)[convertData bytes])[i++];
        
        //  Encode the bytes in the buffer to four characters, including padding "=" characters if necessary.
        characters[length++] = base64EncodingTable[(buffer[0] & 0xFC) >> 2];
        characters[length++] = base64EncodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
        if (bufferLength > 1)
            characters[length++] = base64EncodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
        else characters[length++] = '=';
        if (bufferLength > 2)
            characters[length++] = base64EncodingTable[buffer[2] & 0x3F];
        else characters[length++] = '=';
    }
    
    return [[NSString alloc] initWithBytesNoCopy:characters length:length encoding:NSASCIIStringEncoding freeWhenDone:YES];
}

- (NSString *)encode:(const uint8_t *)input length:(NSInteger)length
{
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData *data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t *output = (uint8_t *)data.mutableBytes;
    
    for (NSInteger i = 0; i < length; i += 3) {
        NSInteger value = 0;
        for (NSInteger j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger index = (i / 3) * 4;
        output[index + 0] =                    table[(value >> 18) & 0x3F];
        output[index + 1] =                    table[(value >> 12) & 0x3F];
        output[index + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[index + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}
@end
