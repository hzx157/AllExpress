//
//  Common.m
//  WuFamily
//
//  Created by xiaowuxiaowu on 15/6/17.
//  Copyright (c) 2015年 xiaowuxiaowu. All rights reserved.
//

#import "Common.h"
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreText/CoreText.h>
#import "CommonCrypto/CommonDigest.h"
#import<CommonCrypto/CommonCryptor.h>
@implementation Common

+(NSString *) md5: (NSString *) inPutText
{
    const char *cStr = [inPutText UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), result);
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}


+(BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//二、通过区分字符串
+(BOOL)validateEmail:(NSString*)email
{
    if((0 != [email rangeOfString:@"@"].length) &&
       (0 != [email rangeOfString:@"."].length))
    {
        NSCharacterSet* tmpInvalidCharSet = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
        NSMutableCharacterSet* tmpInvalidMutableCharSet = [tmpInvalidCharSet mutableCopy];
        [tmpInvalidMutableCharSet removeCharactersInString:@"_-"];
        
        /*
         *使用compare option 来设定比较规则，如
         *NSCaseInsensitiveSearch是不区分大小写
         *NSLiteralSearch 进行完全比较,区分大小写
         *NSNumericSearch 只比较定符串的个数，而不比较字符串的字面值
         */
        NSRange range1 = [email rangeOfString:@"@"
                                      options:NSCaseInsensitiveSearch];
        
        //取得用户名部分
        NSString* userNameString = [email substringToIndex:range1.location];
        NSArray* userNameArray   = [userNameString componentsSeparatedByString:@"."];
        
        for(NSString* string in userNameArray)
        {
            NSRange rangeOfInavlidChars = [string rangeOfCharacterFromSet: tmpInvalidMutableCharSet];
            if(rangeOfInavlidChars.length != 0 || [string isEqualToString:@""])
                return NO;
        }
        
        //取得域名部分
        NSString *domainString = [email substringFromIndex:range1.location+1];
        NSArray *domainArray   = [domainString componentsSeparatedByString:@"."];
        
        for(NSString *string in domainArray)
        {
            NSRange rangeOfInavlidChars=[string rangeOfCharacterFromSet:tmpInvalidMutableCharSet];
            if(rangeOfInavlidChars.length !=0 || [string isEqualToString:@""])
                return NO;
        }
        
        return YES;
    }
    else {
        return NO;
    }
}



#pragma mark------身份证
-(BOOL) chk18PaperId:(NSString *) sPaperId

{
    
    //判断位数
    
    
    if ([sPaperId length] != 15 && [sPaperId length] != 18) {
        return NO;
    }
    NSString *carid = sPaperId;
    
    long lSumQT =0;
    
    //加权因子
    
    int R[] ={7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2 };
    
    //校验码
    
    unsigned char sChecker[11]={'1','0','X', '9', '8', '7', '6', '5', '4', '3', '2'};
    
    
    
    //将15位身份证号转换成18位
    
    NSMutableString *mString = [NSMutableString stringWithString:sPaperId];
    
    if ([sPaperId length] == 15) {
        
        [mString insertString:@"19" atIndex:6];
        
        long p = 0;
        
        const char *pid = [mString UTF8String];
        
        for (int i=0; i<=16; i++)
            
        {
            
            p += (pid[i]-48) * R[i];
            
        }
        
        int o = p%11;
        
        NSString *string_content = [NSString stringWithFormat:@"%c",sChecker[o]];
        
        [mString insertString:string_content atIndex:[mString length]];
        
        carid = mString;
        
    }
    
    //判断地区码
    
    NSString * sProvince = [carid substringToIndex:2];
    
    if (![self areaCode:sProvince]) {
        
        return NO;
        
    }
    
    //判断年月日是否有效
    
    
    
    //年份
    
    int strYear = [[self getStringWithRange:carid Value1:6 Value2:4] intValue];
    
    //月份
    
    int strMonth = [[self getStringWithRange:carid Value1:10 Value2:2] intValue];
    
    //日
    
    int strDay = [[self getStringWithRange:carid Value1:12 Value2:2] intValue];
    
    
    
    NSTimeZone *localZone = [NSTimeZone localTimeZone];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    [dateFormatter setTimeZone:localZone];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date=[dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-%d 12:01:01",strYear,strMonth,strDay]];
    
    if (date == nil) {
        
        return NO;
        
    }
    
    const char *PaperId  = [carid UTF8String];
    
    //检验长度
    
    if( 18 != strlen(PaperId)) return -1;
    
    
    
    //校验数字
    
    for (int i=0; i<18; i++)
        
    {
        
        if ( !isdigit(PaperId[i]) && !(('X' == PaperId[i] || 'x' == PaperId[i]) && 17 == i) )
            
        {
            
            return NO;
            
        }
        
    }
    
    //验证最末的校验码
    
    for (int i=0; i<=16; i++)
        
    {
        
        lSumQT += (PaperId[i]-48) * R[i];
        
    }
    
    if (sChecker[lSumQT%11] != PaperId[17] )
        
    {
        
        return NO;
        
    }
    
    return YES;
    
}

-(NSString *)getStringWithRange:(NSString *)str Value1:(int )value1 Value2:(NSInteger )value2

{
    
    return [str substringWithRange:NSMakeRange(value1,value2)];
    
}



/**
 
 * 功能:判断是否在地区码内
 
 * 参数:地区码
 
 */

-(BOOL)areaCode:(NSString *)code

{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    [dic setObject:@"北京" forKey:@"11"];
    
    [dic setObject:@"天津" forKey:@"12"];
    
    [dic setObject:@"河北" forKey:@"13"];
    
    [dic setObject:@"山西" forKey:@"14"];
    
    [dic setObject:@"内蒙古" forKey:@"15"];
    
    [dic setObject:@"辽宁" forKey:@"21"];
    
    [dic setObject:@"吉林" forKey:@"22"];
    
    [dic setObject:@"黑龙江" forKey:@"23"];
    
    [dic setObject:@"上海" forKey:@"31"];
    
    [dic setObject:@"江苏" forKey:@"32"];
    
    [dic setObject:@"浙江" forKey:@"33"];
    
    [dic setObject:@"安徽" forKey:@"34"];
    
    [dic setObject:@"福建" forKey:@"35"];
    
    [dic setObject:@"江西" forKey:@"36"];
    
    [dic setObject:@"山东" forKey:@"37"];
    
    [dic setObject:@"河南" forKey:@"41"];
    
    [dic setObject:@"湖北" forKey:@"42"];
    
    [dic setObject:@"湖南" forKey:@"43"];
    
    [dic setObject:@"广东" forKey:@"44"];
    
    [dic setObject:@"广西" forKey:@"45"];
    
    [dic setObject:@"海南" forKey:@"46"];
    
    [dic setObject:@"重庆" forKey:@"50"];
    
    [dic setObject:@"四川" forKey:@"51"];
    
    [dic setObject:@"贵州" forKey:@"52"];
    
    [dic setObject:@"云南" forKey:@"53"];
    
    [dic setObject:@"西藏" forKey:@"54"];
    
    [dic setObject:@"陕西" forKey:@"61"];
    
    [dic setObject:@"甘肃" forKey:@"62"];
    
    [dic setObject:@"青海" forKey:@"63"];
    
    [dic setObject:@"宁夏" forKey:@"64"];
    
    [dic setObject:@"新疆" forKey:@"65"];
    
    [dic setObject:@"台湾" forKey:@"71"];
    
    [dic setObject:@"香港" forKey:@"81"];
    
    [dic setObject:@"澳门" forKey:@"82"];
    
    [dic setObject:@"国外" forKey:@"91"];
    
    if ([dic objectForKey:code] == nil) {
        
        return NO;
        
    }
    
    return YES;
    
}


/////////////////////
+(AppDelegate*)shareAppDelegate
{
    AppDelegate* delegate = nil;
    delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    return delegate;
}

+(NSString*)getParseString:(NSObject*)obj
{
    if (obj == nil||obj==NULL) {
        return nil;
    }
    if([obj isKindOfClass:[NSNull class]])
    {
        return @"";
    }
    if ([obj isKindOfClass:[NSString class]]) {
        return (NSString*)obj;
    }
    else if([obj isKindOfClass:[NSNumber class]])
    {
        NSNumber* number = (NSNumber*)obj;
        return  [number stringValue];
    }
    return nil;
}
+(NSString*)getNULLString:(NSObject*)obj
{
    if (obj == nil||obj==NULL) {
        return @"";
    }
    if([obj isKindOfClass:[NSNull class]])
    {
        return @"";
    }
    if ([obj isKindOfClass:[NSString class]]) {
        return (NSString*)obj;
    }
    else if([obj isKindOfClass:[NSNumber class]])
    {
        NSNumber* number = (NSNumber*)obj;
        return  [number stringValue];
    }
    return nil;
}
//获取Documents文件目录
+(NSString*)GetDocumentFilePath{
    NSArray *paths=(NSArray*)NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
 
    NSString *documentsDirectory=[paths objectAtIndex:0]; //去处需要的路径
    // documentsDirectory=[documentsDirectory stringByAppendingPathComponent:_documentName];
    return  documentsDirectory;
}
//获取Documents文件目录
+(NSString*)GetDocumentFilePath:(NSString*)_documentName{
    NSArray *paths=(NSArray*)NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory=[paths objectAtIndex:0]; //去处需要的路径
    documentsDirectory=[documentsDirectory stringByAppendingPathComponent:_documentName];
    return  documentsDirectory;
    
    
}


//检查文件是否存在, 然后删除文件
+(void)DocumentFileExistsAtPathDeletFile:(NSString *)_path{
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:_path]) {
        NSError *error;
        [fileManager removeItemAtPath:_path error:&error];
    }
}
#pragma mark - ==========文件,路径======================
//判断路径或者文件是否存在
+(BOOL)isExistWithPath:(NSString *)path
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        return YES;
    }else{
        return NO;
    }
}


//获取本定下载的音频文件
+(NSMutableArray *)getDocumentAllMusicFile{
    
    NSString *doucmentDirectory=[Common GetDocumentFilePath:@"Music"];//[[Common GetDocumentFilePath] stringByAppendingPathComponent:@"Music"];
    // NSLog(@"-----Loading bugs from %@ :",doucmentDirectory);
    NSError *error;
    NSArray *files=[[NSFileManager defaultManager] contentsOfDirectoryAtPath:doucmentDirectory error:&error];
    if (files==nil) {
        // NSLog(@"获取目录文件失败:%@",[error localizedDescription]);
        return  nil;
    }
    NSMutableArray *retval=[NSMutableArray arrayWithCapacity:files.count];
    for (NSString *file in files) {
        if ([file.pathExtension compare:@"mp3" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            NSString *fullPath = [doucmentDirectory stringByAppendingPathComponent:file];
            NSRange range=[file rangeOfString:@"."];
            NSInteger loctaion=range.location;
            NSString *fileName=[file substringToIndex:loctaion];
            // NSLog(@"full.Name:%@",fileName);
            
            NSDictionary *dic=[[NSDictionary alloc]initWithObjectsAndKeys:fullPath,@"filePath",fileName,@"fileName",nil];
            
            [retval addObject:dic];
        }
    }
    //NSLog(@"retuval.count:%d",[retval count]);
    return retval;
}

//获取本定下载的音频为解密文件
+(NSMutableArray *)getDocumentAllMusicMDFilePath{
    
    NSString *doucmentDirectory=[Common GetDocumentFilePath:@"Music"];//[[Common GetDocumentFilePath] stringByAppendingPathComponent:@"Music"];
  
    NSError *error;
    NSArray *files=[[NSFileManager defaultManager] contentsOfDirectoryAtPath:doucmentDirectory error:&error];
    if (files==nil) {
    
        return  nil;
    }
    NSMutableArray *retval=[NSMutableArray arrayWithCapacity:files.count];
    for (NSString *file in files) {
        if ([file.pathExtension compare:@"tmp3" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            NSString *fullPath = [doucmentDirectory stringByAppendingPathComponent:file];
            NSRange range=[file rangeOfString:@"."];
            NSInteger loctaion=range.location;
            NSString *fileName=[file substringToIndex:loctaion];
        
            
            NSDictionary *dic=[[NSDictionary alloc]initWithObjectsAndKeys:fullPath,@"filePath",fileName,@"fileName",nil];
            
            [retval addObject:dic];
        }
    }
   
    return retval;
}

//获取本定下载的视频文件
+(NSMutableArray *)getDocumentAllVideoFile{
    
    NSString *doucmentDirectory=[Common GetDocumentFilePath:@"Video"];//[[Common GetDocumentFilePath] stringByAppendingPathComponent:@"Video"];
    //NSLog(@"-----Loading bugs from %@ :",doucmentDirectory);
    NSError *error;
    NSArray *files=[[NSFileManager defaultManager] contentsOfDirectoryAtPath:doucmentDirectory error:&error];
    if (files==nil) {
        // NSLog(@"获取目录文件失败:%@",[error localizedDescription]);
        return  nil;
    }
    NSMutableArray *retval=[NSMutableArray arrayWithCapacity:files.count];
    for (NSString *file in files) {
        // NSLog(@"fileName:%@",file);
        
        if ([file.pathExtension compare:@"png" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            
            NSMutableDictionary *namedic=[[NSMutableDictionary alloc] init];
            NSString *fullPath = [doucmentDirectory stringByAppendingPathComponent:file];
            // NSLog(@"full.Path:%@",fullPath);
            NSRange range=[file rangeOfString:@"."];
            NSInteger loctaion=range.location;
            NSString *fileName=[file substringToIndex:loctaion];
            // NSLog(@"full.Name:%@",fileName);
            
            [namedic setObject:fullPath forKey:@"fullPath"];
            [namedic setObject:fileName forKey:@"fileName"];
            
            //[retval addObject:fullPath];
            [retval addObject:namedic];
        }
    }
    // NSLog(@"retuval.count:%d",[retval count]);
    return retval;
}

//获取本定下载的为解密视频文件
+(NSMutableArray *)getDocumentAllVideoMDFilePath{
    
    NSString *doucmentDirectory=[Common GetDocumentFilePath:@"Video"];//[[Common GetDocumentFilePath] stringByAppendingPathComponent:@"Video"];

    NSError *error;
    NSArray *files=[[NSFileManager defaultManager] contentsOfDirectoryAtPath:doucmentDirectory error:&error];
    if (files==nil) {
    
        return  nil;
    }
    NSMutableArray *retval=[NSMutableArray arrayWithCapacity:files.count];
    for (NSString *file in files) {
        // NSLog(@"fileName:%@",file);
        
        if ([file.pathExtension compare:@"tmp4" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            
            NSMutableDictionary *namedic=[[NSMutableDictionary alloc] init];
            NSString *fullPath = [doucmentDirectory stringByAppendingPathComponent:file];
      
            NSRange range=[file rangeOfString:@"."];
            NSInteger loctaion=range.location;
            NSString *fileName=[file substringToIndex:loctaion];
       
            
            [namedic setObject:fullPath forKey:@"fullPath"];
            [namedic setObject:fileName forKey:@"fileName"];
            
            //[retval addObject:fullPath];
            [retval addObject:namedic];
        }
    }

    return retval;
}


//获取本地的图片。
+(UIImage *)getDocumentImageFormPath:(NSString*)_path{
    
    UIImage* img = [UIImage imageWithContentsOfFile:_path];
    return img;
}

//获取本地视频的缩略图
+(UIImage *)getImage:(NSString *)videoURL
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:videoURL] options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(3.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    
    return thumb;
    
}

//创建文件并返回文件路径
+(NSString*)writeDocumentCreatePath:(NSString*)dir fileName:(NSString*)name

{
    //获取Documents文件夹目录
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [path objectAtIndex:0];
    //指定新建文件夹路径
    NSString *imageDocPath = [documentPath stringByAppendingPathComponent:dir];
    
    
    [[NSFileManager defaultManager] createDirectoryAtPath:imageDocPath withIntermediateDirectories:NO attributes:nil error:nil];
    //NSLog(@"create dir %d",ret);
    return [imageDocPath stringByAppendingPathComponent:name];
}


+(NSString*)getDocumentPath:(NSString*)dir :(NSString*)name
{
    //获取Documents文件夹目录
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [path objectAtIndex:0];
    //指定新建文件夹路径
    NSString *imageDocPath = [documentPath stringByAppendingPathComponent:dir];
    
    
  //  [[NSFileManager defaultManager] createDirectoryAtPath:imageDocPath withIntermediateDirectories:NO attributes:nil error:nil];
  
    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
 
    NSError *error;
    // Remove the filename and create the remaining path
  [fileManager createDirectoryAtPath:[imageDocPath stringByDeletingLastPathComponent]withIntermediateDirectories:YES attributes:nil error:&error];//stringByDeletingLastPathComponent是关键

    
    //NSLog(@"create dir %d",ret);
    return [imageDocPath stringByAppendingPathComponent:name];
}
+(NSString*)getTempPath:(NSString*)dir :(NSString*)name
{
    NSString* tempPath = NSTemporaryDirectory();
    NSString *imageDocPath = [tempPath stringByAppendingPathComponent:dir];
    [[NSFileManager defaultManager] createDirectoryAtPath:imageDocPath withIntermediateDirectories:NO attributes:nil error:nil];
    return [imageDocPath stringByAppendingPathComponent:name];
}

+(float)heightForText:(NSString *)value width:(float)width fontHeight:(float)height
{
    CGSize sizeToFit;
    if(IOS7){
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:height], NSParagraphStyleAttributeName:paragraphStyle.copy};
        
        sizeToFit = [value boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    }
    
    return sizeToFit.height;
    
}
+(CGSize)heightForText:(NSString *)value size:(CGSize )width font:(UIFont *)font
{
    CGSize sizeToFit;
    if(IOS7){
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
        
        sizeToFit = [value boundingRectWithSize:width options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    }
    
    return sizeToFit;
    
}
+(float)heightForText:(NSString *)value width:(float)width font:(UIFont *)font
{
    CGSize sizeToFit;
    if(IOS7){
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
        
        sizeToFit = [value boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    }
    
    return sizeToFit.height;
    
}
+(time_t)getTimeValueForKey:(NSString *)key defaultValue:(time_t)defaultValue {
    NSString *stringTime   = key;
    struct tm created;
    time_t now;
    time(&now);
    
    if (stringTime) {
        if (strptime([stringTime UTF8String], "%a %b %d %H:%M:%S %z %Y", &created) == NULL) {
            strptime([stringTime UTF8String], "%a, %d %b %Y %H:%M:%S %z", &created);
        }
        return mktime(&created);
    }
    return defaultValue;
}
+(BOOL)isLogin
{
    //	AppDelegate* delegate = [self shareAppDelegate];
    //	if(delegate.username.length > 0 && delegate.password.length > 0 &&delegate.token.length > 0)
    //	{
    //		return YES;
    //	}
    return NO;
}
// DES加密 ：用CCCrypt函数加密一下，然后用base64编码
+ (NSString *)encrypt:(NSString *)sText key:(NSString *)key
{
    NSData* encryptData = [sText dataUsingEncoding:NSUTF8StringEncoding];
    const void *dataIn = (const void *)[encryptData bytes];
    size_t dataInLength = [encryptData length];
    
    /*
     DES加密 ：用CCCrypt函数加密一下，然后用base64编码
     */
    
    size_t dataOutAvailable = (dataInLength + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
    uint8_t *dataOut = malloc( dataOutAvailable * sizeof(uint8_t));
    size_t dataOutMoved = 0;
    
    memset((void *)dataOut, 0x0, dataOutAvailable);//将已开辟内存空间buffer的首 1 个字节的值设为值 0
    
    NSString *initIv = @"12345678";
    const void *vkey = (const void *) [key UTF8String];
    const void *iv = (const void *) [initIv UTF8String];
    
    //CCCrypt函数 加密
    CCCrypt(kCCEncrypt,//  加密
            kCCAlgorithmDES,//  加密根据哪个标准（des，3des，aes。。。。）
            kCCOptionPKCS7Padding,//  选项分组密码算法(des:对每块分组加一次密  3DES：对每块分组加三个不同的密)
            vkey,  //密钥
            kCCKeySizeDES,//   DES 密钥的大小（kCCKeySizeDES=8）
            iv, //  可选的初始矢量
            dataIn, // 数据的存储单元
            dataInLength,// 数据的大小
            (void *)dataOut,// 用于返回数据
            dataOutAvailable,
            &dataOutMoved);
    
    //编码 base64
    NSData *data = [NSData dataWithBytes:(const void *)dataOut length:(NSUInteger)dataOutMoved];
    NSString *result = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];//[GTMBase64 stringByEncodingData:data];
    
    return result;
}


+ (UIColor *)getColor:(NSString *)hexColor
{
    unsigned int red,green,blue;
    NSRange range;
    range.length = 2;
    
    range.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
    
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
    
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green / 255.0f) blue:(float)(blue / 255.0f) alpha:1.0f];
}
+ (void)printfRect:(CGRect)rect
{
   
}
+(void)ShowDialogInfo:(NSString*)title info:(NSString*)info delegate:(id)delegate
{
    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:title message:info delegate:delegate cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
    
}


// 删除沙盒里的文件
+(void)deleteFile:(NSString*)fileName{
    NSFileManager* fileManager=[NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    
    //文件名
    NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
    if (!blHave) {
        NSLog(@"no  have");
        return ;
    }else {
        NSLog(@" have");
        BOOL blDele= [fileManager removeItemAtPath:uniquePath error:nil];
        if (blDele) {
            NSLog(@"dele success");
        }else {
            NSLog(@"dele fail");
        }
        
    }
}



#pragma mark - 手机号判断
// 正则判断手机号码地址格式
+(BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[1278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+(NSString *)compareCurrentTime:(NSDate*) compareDate
{
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分前",temp];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小前",temp];
    }
    
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }
    
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld月前",temp];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld年前",temp];
    }
    
    return  result;
}

//模糊效果
+(UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur {
    CIImage *inputImage = [CIImage imageWithCGImage:image.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"
                                  keysAndValues:kCIInputImageKey, inputImage,
                        @"inputRadius", @(blur), nil];
    
    CIImage *outputImage = filter.outputImage;
    CIContext *context = [CIContext contextWithOptions:nil]; // save it to self.context
    CGImageRef outImage = [context createCGImage:outputImage fromRect:[inputImage extent]];
    return [UIImage imageWithCGImage:outImage];
}

#pragma mark - 将View 转image
+ (UIImage *)imageFromView:(UIView *)theView
{
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

//添加敏感度
+(UIButton *)ButtonAndImageBtnRect:(CGRect)frame imageRect:(CGRect)ImageFrame Image:(NSString *)image
{
    UIImageView *leftbut=[[UIImageView alloc]init];
    leftbut.frame =ImageFrame;
    
    leftbut.image = [UIImage imageNamed:image];
    
    UIButton *leftbut1=[UIButton buttonWithType:UIButtonTypeCustom];
    leftbut1.frame =frame;
    leftbut1.tag = 200;
    
    [leftbut1 addSubview:leftbut];
    return leftbut1;
}

+(void)getPhoneNuber:(NSString *)phone view:(UIView *)view{
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phone];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [view addSubview:callWebview];
    
    
    
}
+ (NSArray *)getSeparatedLinesFromLabel:(UILabel *)label
{
    NSString *text = [label text];
    UIFont   *font = [label font];
    CGRect    rect = [label frame];
    
    CTFontRef myFont = CTFontCreateWithName((__bridge CFStringRef)([font fontName]), [font pointSize], NULL);
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)myFont range:NSMakeRange(0, attStr.length)];
    
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attStr);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,rect.size.width,100000));
    
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);
    NSMutableArray *linesArray = [[NSMutableArray alloc]init];
    
    for (id line in lines)
    {
        CTLineRef lineRef = (__bridge CTLineRef )line;
        CFRange lineRange = CTLineGetStringRange(lineRef);
        NSRange range = NSMakeRange(lineRange.location, lineRange.length);
        
        NSString *lineString = [text substringWithRange:range];
        [linesArray addObject:lineString];
    }
    return (NSArray *)linesArray;
}


+(NSString *)getWeekday
{
    NSDate *date = [NSDate date];
    NSDateComponents *componets = [[NSCalendar autoupdatingCurrentCalendar] components:NSCalendarUnitWeekday fromDate:date];
    NSString *weekday = [Common getWeekdayWithNumber:[componets weekday]];
    return weekday;
}

//1代表星期日、如此类推
+(NSString *)getWeekdayWithNumber:(NSInteger)number
{
    switch (number) {
        case 1:
            return @"星期日";
            break;
        case 2:
            return @"星期一";
            break;
        case 3:
            return @"星期二";
            break;
        case 4:
            return @"星期三";
            break;
        case 5:
            return @"星期四";
            break;
        case 6:
            return @"星期五";
            break;
        case 7:
            return @"星期六";
            break;
        default:
            return @"";
            break;
    }

}


@end
