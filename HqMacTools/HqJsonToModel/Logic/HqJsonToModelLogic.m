//
//  HqJsonToModelLogic.m
//  HqMacTools
//
//  Created by hehuiqi on 2024/12/19.
//

#import "HqJsonToModelLogic.h"

@implementation HqJsonToModelLogic

- (NSString *)formatJSONString:(NSString *)json {
    NSDictionary *jsonDic = [self dictionaryWithJsonString:json];
    NSData *jd = [NSJSONSerialization dataWithJSONObject:jsonDic options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:jd encoding:NSUTF8StringEncoding];
}
- (BOOL)isInt:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }

    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

- (NSString *)makeSwiftModelWithName:(NSString *)name isToClass:(BOOL)isToClass dic:(NSDictionary *)dic {
    
    NSMutableString *modeContent = [[NSMutableString alloc] init];
    if (isToClass) {
        [modeContent appendFormat:@"class %@ { \n",name];
        [modeContent appendString:@"\n"];
        [modeContent appendString:@"\trequired init() {}\n"];
    } else {
        [modeContent appendFormat:@"struct %@ { \n",name];
        [modeContent appendString:@"\n"];
    }


    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
//        NSLog(@"[obj class]:%@",[obj class]);
        NSString *numStr = [NSString stringWithFormat:@"%@",obj];
        if ([numStr isEqualToString:@"false"] || [numStr isEqualToString:@"true"] ) {
            [modeContent appendFormat:@"\tvar %@:Bool = false \n",key];
        } else if ([obj isKindOfClass:NSNumber.class]) {
            if ([self isInt:numStr]) {
                [modeContent appendFormat:@"\tvar %@:Int = 0 \n",key];
            } else {
                [modeContent appendFormat:@"\tvar %@:Double = 0.0 \n",key];
            }
        } else  if ([obj isKindOfClass:NSString.class]){
            [modeContent appendFormat:@"\tvar %@:String = \"\" \n",key];
        } else  if ([obj isKindOfClass:NSArray.class]){
            [modeContent appendFormat:@"\tvar %@:[Any] = [] \n",key];
        }
        else  if ([obj isKindOfClass:NSDictionary.class]){
            [modeContent appendFormat:@"\tvar %@:[String:Any] = [:] \n",key];
        }
        else {
            [modeContent appendFormat:@"\tvar %@:String? = nil \n",key];
        }
        
    }];
    
    [modeContent appendString:@"\n"];
    [modeContent appendString:@"}\n"];
    
    NSLog(@"modeContent:\n%@",modeContent);

    return modeContent;
}

- (NSString *)makeOCModelWithName:(NSString *)name dic:(NSDictionary *)dic{
    
    NSMutableString *modeContent = [[NSMutableString alloc] init];
    [modeContent appendFormat:@"@interface %@ : NSObject\n",name];
    [modeContent appendString:@"\n"];

    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
//        NSLog(@"[obj class]:%@",[obj class]);
        NSString *numStr = [NSString stringWithFormat:@"%@",obj];
        if ([numStr isEqualToString:@"false"] || [numStr isEqualToString:@"true"] ) {
            [modeContent appendFormat:@"@property (nonatomic,assign) BOOL *%@;\n",key];
        } else if ([obj isKindOfClass:NSNumber.class]) {
            if ([self isInt:numStr]) {
                [modeContent appendFormat:@"@property (nonatomic,assign) NSInteger *%@;\n",key];
            } else {
                [modeContent appendFormat:@"@property (nonatomic,assign) CGFloat %@;\n",key];
            }
        } else  if ([obj isKindOfClass:NSString.class]){
            [modeContent appendFormat:@"@property (nonatomic,copy) NSString *%@;\n",key];
        } else  if ([obj isKindOfClass:NSArray.class]){
            [modeContent appendFormat:@"@property (nonatomic,strong) NSArray *%@;\n",key];
        }
        else  if ([obj isKindOfClass:NSDictionary.class]){
            [modeContent appendFormat:@"@property (nonatomic,strong) NSDictionary *%@;\n",key];
        }
        else {
            [modeContent appendFormat:@"@property (nonatomic,strong) id %@;\n",key];
        }
        
    }];
    
    [modeContent appendString:@"\n"];
    [modeContent appendString:@"@end\n"];
    
    [modeContent appendString:@"\n"];

    [modeContent appendFormat:@"@implementation %@\n",name];
    [modeContent appendString:@"\n"];
    [modeContent appendString:@"@end\n"];
    
    NSLog(@"modeContent:\n%@",modeContent);

    return modeContent;

}


@end
