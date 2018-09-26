//
//  NetManager.m
//  NetManager
//
//  Created by 1 & 0 on 15/7/5.
//  Copyright (c) 2015年 1 & 0. All rights reserved.
//

#import "NetManager.h"
#import "NSData+Zlib.h"
#import "Base64Secret.h"
#import "NSString+StringCode.h"
#import "AFAppDotNetAPIClient.h"
#import "Encryption.h"
#import "CocoaSecurity.h"

@implementation NetManager

- (void)postDataWithUrlActionStr:(NSString *)actionStr withParamDictionary:(NSDictionary *)paramsDic withBlock:(void (^)(id))block {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        AFHTTPSessionManager *manager = [AFAppDotNetAPIClient sharedClient];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//        SSL安全策略
//        manager.securityPolicy = [self customSecurityPolicy];
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        /*1.获取json字符串
         2.zlib压缩
         3.base64编码
         4.url编码
         */
        NSString *dateNew = [self getCurrentTimestamp];
        
        
        //将paramsDic字典转成json字符串进行md5加密获取对应结果字符串
        //        NSDictionary *dicha = @{@"location":@"top"};
        //转json方法
        //        NSData *data=[NSJSONSerialization dataWithJSONObject:dicha options:NSJSONWritingPrettyPrinted error:nil];
        //        NSString *personListString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSString *paraString = [self DataTOjsonString:paramsDic];
        NSMutableString *paraMutableString = [NSMutableString stringWithString:paraString];
        NSString *paraString2 = [[paraMutableString stringByReplacingOccurrencesOfString:@"\n" withString:@""] copy];
        NSMutableString *paraMutableString2 = [NSMutableString stringWithString:paraString2];
        NSString *param = [[paraMutableString2 stringByReplacingOccurrencesOfString:@" " withString:@""] copy];
        NSString *sha256String = [self sha256WithString:param];
//        NSString *sha256String = [self md5WithString:param];
        NSDictionary *paramDic = @{@"timestamp":dateNew, @"action":actionStr, @"data":paramsDic,@"token":sha256String};//参数序列
        NSString *base64Str = [self paramCodeStr:paramDic];
        //base64Str是经过处理的字符串
        
        [manager POST:WMJRAPI parameters:@{@"msg":base64Str} progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            id obj = [self paramUnCodeStr:responseStr];
            
            if (obj) {
                block(obj);
                //                dispatch_async(dispatch_get_main_queue(), ^{
                //                    if ([obj[@"result"] isEqualToString:@"0"]) {
                //                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"缺少必传参数" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                //                        [alert show];
                //                        block(nil);
                //                    } else if ([obj[@"result"] isEqualToString:@"1"]) {
                //                        block(obj);
                //                    } else if ([obj[@"result"] isEqualToString:@"1000"]) {
                //                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"通用的已知业务错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                //                        [alert show];
                //                        block(obj);
                //                    } else if ([obj[@"result"] isEqualToString:@"1***"]) {
                //                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已知的业务错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                //                        [alert show];
                //                        block(nil);
                //                    } else if ([obj[@"result"] isEqualToString:@"2"]) {
                //                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"未知的后台程序错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                //                        [alert show];
                //                        block(nil);
                //                    } else if ([obj[@"result"] isEqualToString:@"2000"]) {
                //                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"通用的未知的后台程序错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                //                        [alert show];
                //                        block(nil);
                //                    } else {
                //                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"未知的后台程序错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                //                        [alert show];
                //                        block(nil);
                //                    }
                //                });
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"请检查网络"];
        }];
        
//        [manager POST:WMJRAPI parameters:@{@"msg":base64Str} success:^(NSURLSessionTask *operation, id responseObject) {
//            NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//            id obj = [self paramUnCodeStr:responseStr];
//            
//            if (obj) {
//                block(obj);
////                dispatch_async(dispatch_get_main_queue(), ^{
////                    if ([obj[@"result"] isEqualToString:@"0"]) {
////                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"缺少必传参数" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
////                        [alert show];
////                        block(nil);
////                    } else if ([obj[@"result"] isEqualToString:@"1"]) {
////                        block(obj);
////                    } else if ([obj[@"result"] isEqualToString:@"1000"]) {
////                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"通用的已知业务错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
////                        [alert show];
////                        block(obj);
////                    } else if ([obj[@"result"] isEqualToString:@"1***"]) {
////                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已知的业务错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
////                        [alert show];
////                        block(nil);
////                    } else if ([obj[@"result"] isEqualToString:@"2"]) {
////                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"未知的后台程序错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
////                        [alert show];
////                        block(nil);
////                    } else if ([obj[@"result"] isEqualToString:@"2000"]) {
////                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"通用的未知的后台程序错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
////                        [alert show];
////                        block(nil);
////                    } else {
////                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"未知的后台程序错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
////                        [alert show];
////                        block(nil);
////                    }
////                });
//            }
//        } failure:^(NSURLSessionTask *operation, NSError *error) {
//            [SVProgressHUD showErrorWithStatus:@"请检查网络"];
//        }];
    });
}

/**
 *  SSL安全策略
 *
 *  @return AFSecurityPolicy
 */
- (AFSecurityPolicy*)customSecurityPolicy {
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"server" ofType:@"cer"];
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    [securityPolicy setAllowInvalidCertificates:YES];
    [securityPolicy setValidatesDomainName:NO];
    [securityPolicy setPinnedCertificates:@[certData]];
    
    return securityPolicy;
}

- (NSString *)paramCodeStr:(NSDictionary *)paramDic {
    NSString *paramJSONStr = [paramDic mj_JSONString];
    NSData *paramJSONData = [paramJSONStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData *compressData = [paramJSONData zlibDeflate];
    NSString *base64Str = [[[Base64Secret alloc] init] base64Encoding:compressData];
    
    return base64Str;
}


- (id)paramUnCodeStr:(NSString *)encodeStr {
    
    NSData *unComData = [Base64Secret dataWithBase64Encoding:encodeStr];
    NSData *uncompressData = [unComData zlibInflate];
    id string = [self jsonValueDecoded:uncompressData];
    
    return string;

}

#pragma mark - 转json字符串
-(NSString*)DataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

- (id)jsonValueDecoded:(NSData *)encode {

    NSError *error = nil;
    id value;
    @try {
        value = [NSJSONSerialization JSONObjectWithData:encode options:kNilOptions error:&error];
        if (error) {
            NSLog(@"jsonValueDecoded error:%@", error);
        }
        return value;
    } @catch (NSException *exception) {
        NSException *error = exception;
        NSLog(@"我的错误:%@",error);
        [[[UIAlertView alloc]initWithTitle:@"服务器出现错误" message:@"请退出app稍后重试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil]show];
        value = @{@"result":@"10000"};
    } @finally {
        return value;
    }
}

//获取当前的时间戳
- (NSString *)getCurrentTimestamp {
    NSDate *newDate = [NSDate date];
    NSTimeInterval times = newDate.timeIntervalSince1970 + 8 * 3600;
    NSString *timeString = [NSString stringWithFormat:@"%.lf", times];
    
    return timeString;
}

//获取json字符串
- (NSString *)dictionaryToJSON:(NSDictionary *)dic {
    NSError *paramError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:kNilOptions error:&paramError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

/**
 *  将n字符串sha加密
 *
 *  @param 要加密的字符串
 *
 *  @return sha字符串
 */
- (NSString *)sha256WithString:(NSString *)str
{
    CocoaSecurityResult *result = [CocoaSecurity sha256:str];
    return result.hexLower;
}

/**
 *  将n字符串md5加密
 *
 *  @param 要加密的字符串
 *
 *  @return sha字符串
 */
- (NSString *)md5WithString:(NSString *)str
{
    CocoaSecurityResult *result = [CocoaSecurity md5:str];
    return result.hexLower;
}


//编码url
- (NSString*)stringByURLEncodingStringParameter:(NSString *)urlStr
{
    NSString *resultStr = urlStr;
    
    CFStringRef originalString = (__bridge CFStringRef)urlStr;
    CFStringRef leaveUnescaped = CFSTR(" ");
    CFStringRef forceEscaped = CFSTR("!*'();:@&=+$,/?%#[]");
    
    CFStringRef escapedStr;
    escapedStr = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                         originalString,
                                                         leaveUnescaped,
                                                         forceEscaped,
                                                         kCFStringEncodingUTF8);
    
    if( escapedStr )
    {
        NSMutableString *mutableStr = [NSMutableString stringWithString:(__bridge NSString *)escapedStr];
        CFRelease(escapedStr);
        
        // replace spaces with plusses
        [mutableStr replaceOccurrencesOfString:@" "
                                    withString:@"%20"
                                       options:0
                                         range:NSMakeRange(0, [mutableStr length])];
        resultStr = mutableStr;
    }
    return resultStr;
}


@end
