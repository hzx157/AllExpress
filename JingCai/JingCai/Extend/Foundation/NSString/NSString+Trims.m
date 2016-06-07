//
//  NSString+Trims.m
//  iOS-Categories (https://github.com/shaojiankui/iOS-Categories)
//
//  Created by Jakey on 15/3/29.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//

#import "NSString+Trims.h"
#import "NSString+Contains.h"
@implementation NSString (Trims)
- (NSString *)stringByStrippingHTML {
    return [self stringByReplacingOccurrencesOfString:@"<[^>]+>" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, self.length)];
}


- (NSString *)stringByRemovingScriptsAndStrippingHTML {
    NSMutableString *mString = [self mutableCopy];
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<script[^>]*>[\\w\\W]*</script>" options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *matches = [regex matchesInString:mString options:NSMatchingReportProgress range:NSMakeRange(0, [mString length])];
    for (NSTextCheckingResult *match in [matches reverseObjectEnumerator]) {
        [mString replaceCharactersInRange:match.range withString:@""];
    }
    return [mString stringByStrippingHTML];
}


- (NSString *)trimmingWhitespace
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}
- (NSString *)trimmingWhitespaceAndNewlines
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
 #define NUMBERS @".0123456789"
+(BOOL)setShouldChangeCharactersInTextField:(UITextField *)textField range:(NSRange )range string:(NSString *)string block:(void (^)(NSString *futureString))block{
    
    NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
    
    
    //删除
    if([string isEqualToString:@""]|| string == nil){
        if(futureString.length>0){
            [futureString deleteCharactersInRange:NSMakeRange(futureString.length - 1, 1)];
        }
        block(futureString);
    }else{  //添加
       
        NSCharacterSet*cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
        NSString*filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [string isEqualToString:filtered];
        
        //是否包含中文、字母
        if([string isContainChinese]||!basicTest){
            [UIView show_fail_progress:@"不能包含非数字字符,你输入的是中文让程序员哥哥怎么知道你是多少钱啊"];
            return NO;
        }else if ([string isEqualToString:@"."]){
            NSRange range = [textField.text rangeOfString:@"."];
            if(range.location != NSNotFound){
                return NO;
            }
        }
        
        
        //判断小数点
        [futureString  insertString:string atIndex:range.location];
        NSInteger flag=0;
        const NSInteger limited = 2;//小数点后需要限制的个数
        for (NSInteger i = futureString.length-1; i>=0; i--) {
            if ([futureString characterAtIndex:i] == '.') {
                if (flag > limited) {
                    return NO;
                }
                break;
            }
            flag++;
        }
        
    }
    
    
    
#pragma mark-----------限制2000元----------
    
    if(futureString.length>0){
        
        
     
        NSArray *array = [futureString componentsSeparatedByString:@"."];
        NSString *string = array.firstObject;
        if([string integerValue]>2000){
            [UIView show_fail_progress:@"不能超过2000"];
            return NO;
        }
    }
  block(futureString);
    return YES;
    
}

//对价格重新处理
+(NSString *)replacementPriString:(NSString *)priString{
    
 
    if(priString.length>0){
        NSArray *array = [priString componentsSeparatedByString:@"."];
        
        if(array.count==2){ //有点
            
            NSString *string = array.lastObject;
            if(string.length == 0){
                
                priString = [priString stringByAppendingString:@"00"];
                
            }else if (string.length == 1){
                
                priString = [priString stringByAppendingString:@"0"];
            }
        }else{
            priString = [priString stringByAppendingString:@".00"];
        }
        
        
    }else{
        priString = @"00.00";
    }
    return priString;;
    
}
@end
