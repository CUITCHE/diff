//
//  Read.m
//  diff
//
//  Created by He,Junqiu on 2018/3/12.
//  Copyright © 2018年 hejunqiu. All rights reserved.
//

#import "Tool.h"

NSString *_exec(NSString *cmd)
{
    FILE *fp = popen([cmd cStringUsingEncoding:NSUTF8StringEncoding], "r");
    if (fp != NULL) {
        char buf[1024];
        NSMutableString *result = [NSMutableString string];
        while (fgets(buf, 1024, fp) != NULL) {
            [result appendString:[NSString stringWithUTF8String:buf]];
        }
        pclose(fp);
        return result;
    }
    return nil;
}
