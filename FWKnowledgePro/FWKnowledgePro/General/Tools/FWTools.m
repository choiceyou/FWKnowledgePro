//
//  FWTools.m
//  FWKnowledgePro
//
//  Created by xfg on 2021/3/4.
//

#import "FWTools.h"

@implementation FWTools

+ (NSString *)htmlWithStr:(NSString *)str
{
    //    <html>
    //    <head>
    //    <title>放置文章标题</title>
    //    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" /> //这里是网页编码现在是gb2312
    //    <meta name="keywords" content="关键字" />
    //    <meta name="description" content="本页描述或关键字描述" />
    //    </head>
    //    <body>
    //    这里就是正文内容
    //    </body>
    //    </html>
    
    NSString *jsString = [NSString stringWithFormat:
                          @"<html>\n"
                          "<body>\n"
                          "<p><font size='20' face='arial' color='black'> %@ </font></p>"
                          "</body>\n"
                          "</html>",
                          str];
    
    return jsString;
}

@end
