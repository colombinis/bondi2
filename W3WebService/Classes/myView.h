//
//  myView.h
//  W3WebService
//
//  Created by Ravi Dixit on 4/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface myView : UIViewController <NSXMLParserDelegate > {

	IBOutlet UITextField *txt1,*output;
	NSMutableData *webData;
	NSXMLParser *xmlParser;
	NSString *finaldata;
	NSMutableString *nodeContent;
}
@property (nonatomic,retain) UITextField *txt1,*output;
-(IBAction)backGroundTap:(id)sender;
-(IBAction)invokeService;

@end
