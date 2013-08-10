//
//  HashSumViewController.m
//  HexBT
//
//  Created by Pan Ziyue on 10/8/13.
//  Copyright (c) 2013 Pan Ziyue. All rights reserved.
//

#import "HashSumViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import <QuartzCore/QuartzCore.h>

@interface HashSumViewController ()

@end

@implementation HashSumViewController

@synthesize textToHash, sha1Disp, md5Disp;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    textToHash.clipsToBounds=YES;
    textToHash.layer.cornerRadius=10.0f;
    sha1Disp.clipsToBounds=YES;
    sha1Disp.layer.cornerRadius=10.0f;
    md5Disp.clipsToBounds=YES;
    md5Disp.layer.cornerRadius=10.0f;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

-(void)dismissKeyboard {
    [textToHash resignFirstResponder];
}

-(IBAction)convert:(id)sender
{
    sha1Disp.text=[self sha1:textToHash.text];
    md5Disp.text=[self md5:textToHash.text];
    [textToHash resignFirstResponder];
}

-(IBAction)share:(id)sender
{
    if ([sha1Disp hasText]&&[md5Disp hasText]) {
        NSString *md5String=[@"MD5 Sum: " stringByAppendingString:md5Disp.text];
        NSString *sha1String=[@"\nSHA1 Sum: " stringByAppendingString:sha1Disp.text];
        NSString *combined=[md5String stringByAppendingString:sha1String];
        
        UIActivityViewController *actCtrl=[[UIActivityViewController alloc]initWithActivityItems:@[combined] applicationActivities:nil];
        [self presentViewController:actCtrl animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"You haven't generated a hash!" message:nil delegate:nil cancelButtonTitle:@"Back" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(NSString*)sha1:(NSString*)input
{
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

-(NSString*)md5:(NSString*)input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end