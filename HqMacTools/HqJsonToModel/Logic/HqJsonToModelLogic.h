//
//  HqJsonToModelLogic.h
//  HqMacTools
//
//  Created by hehuiqi on 2024/12/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HqJsonToModelLogic : NSObject

- (NSString *)formatJSONString:(id)json;
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
- (NSString *)makeSwiftModelWithName:(NSString *)name isToClass:(BOOL)isToClass dic:(NSDictionary *)dic;
- (NSString *)makeOCModelWithName:(NSString *)name dic:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
