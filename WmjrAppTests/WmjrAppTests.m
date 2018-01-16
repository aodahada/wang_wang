//
//  WmjrAppTests.m
//  WmjrAppTests
//
//  Created by Baimifan on 16/2/20.
//  Copyright © 2016年 Baimifan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NetManager.h"

//waitForExpectationsWithTimeout是等待时间，超过了就不再等待往下执行。
#define WAIT do {\
[self expectationForNotification:@"RSBaseTest" object:nil handler:nil];\
[self waitForExpectationsWithTimeout:30 handler:nil];\
} while (0);

#define NOTIFY \
[[NSNotificationCenter defaultCenter]postNotificationName:@"RSBaseTest" object:nil];

@interface WmjrAppTests : XCTestCase

@end

@implementation WmjrAppTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
//    NetManager *manager = [[NetManager alloc] init];
//    NSDictionary *paramDic = @{@"is_recommend":@"1", @"page":@"", @"size":@""};
//    [manager postDataWithUrlActionStr:@"Product/new_index" withParamDictionary:paramDic withBlock:^(id obj) {
//        if ([obj[@"result"] isEqualToString:@"1"]) {
//            
////            NSLog(@"成功了:%@",obj);
//            XCTAssertNotNil(obj, @"返回出错");
//            NOTIFY //继续执行
//            
//        } else {
//            NSLog(@"失败");
//        }
//    }];
//     WAIT  //暂停
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        
    }];
}

@end
