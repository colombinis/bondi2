//
//  myView.m
//  W3WebService
//
//  Created by Ravi Dixit on 4/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "myView.h"


@implementation myView
@synthesize txt1,output;

#define startActivityIndicator  [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES]
#define stopActivityIndicator  [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
     NSLog(@"**************** initWithNibName **************** ");
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
		nodeContent = [[NSMutableString alloc]init];
       
        
    }
    return self;
}

//metodo que me devuelve un objeto de tipo IBAction (una acción desde el aspecto gráfico).
-(IBAction)invokeService
{
     NSLog(@"**************** invokeService **************** ");
	//si no hay nada en el objeto txt1
	if ([txt1.text length]==0) {
		//creamos un objeto de tipo UIAlertview con los parametros necesarios (un popup)
		UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"WebService" message:@"Supply Data in text field" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"ok",nil];
		[alert show];
		[alert release];
	}
    //si no... o sea.. si se escribió algo en el txt1
	else {
		 //saco el teclado de la pantalla.
		[txt1 resignFirstResponder];
        //creo un objeto de tipo NSString en el que seteo el siguiente String...
		NSString *soapFormat = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
								"<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
								"<soap:Body>\n"
								"<CelsiusToFahrenheit xmlns=\"http://www.w3schools.com/webservices/\">\n"
								"<Celsius>%@</Celsius>\n"
								"</CelsiusToFahrenheit>\n"
								"</soap:Body>\n"
								"</soap:Envelope>\n",txt1.text];
		
		//muestro por consola el siguiente string
		NSLog(@"The request format is %@",soapFormat);
		//creo un objeto de tipo NSURL, o sea, un objeto que contendrá un objeto que refereciará a una dirección web.
		NSURL *locationOfWebService = [NSURL URLWithString:@"http://www.w3schools.com/webservices/tempconvert.asmx"];
		//muestro por consola
		NSLog(@"web url = %@",locationOfWebService);
		//creo un objeto de tipo MSMutableRequest, donde alojaremos el REQUEST de la petición al webService
		NSMutableURLRequest *theRequest = [[NSMutableURLRequest alloc]initWithURL:locationOfWebService];
		// creo un objeto de tipo NSString guardo la cantidad de caracteres que tengo en el soapformat.
		NSString *msgLength = [NSString stringWithFormat:@"%d",[soapFormat length]];
		
        //AGREGO los values necesarios para formatear el objeto.
		[theRequest addValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
		[theRequest addValue:@"http://www.w3schools.com/webservices/CelsiusToFahrenheit" forHTTPHeaderField:@"SOAPAction"];
		[theRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
		[theRequest setHTTPMethod:@"POST"];
		//the below encoding is used to send data over the net
		[theRequest setHTTPBody:[soapFormat dataUsingEncoding:NSUTF8StringEncoding]];
		
		
		NSURLConnection *connect = [[NSURLConnection alloc]initWithRequest:theRequest delegate:self];
		
		if (connect) {
			webData = [[NSMutableData alloc]init];
            startActivityIndicator;
		}
		else {
			NSLog(@"No Connection established");
		}
		
		
	}

}

-(IBAction)backGroundTap:(id)sender
{
     NSLog(@"**************** backGroundTap **************** ");
	[txt1 resignFirstResponder];
}

//NSURLConnection delegate method

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
     NSLog(@"*** -(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response ***");
	[webData setLength: 0];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"*** -(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response ***");

	[webData appendData:data];
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"*** -(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data ***");

	NSLog(@"ERROR with theConenction");
	[connection release];
	[webData release];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"*** -(void)connectionDidFinishLoading:(NSURLConnection *)connection");

	NSLog(@"DONE. Received Bytes: %d", [webData length]);
	NSString *theXML = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
	NSLog(@"%@",theXML);
	
	xmlParser = [[NSXMLParser alloc]initWithData:webData];
	[xmlParser setDelegate: self];
	//[xmlParser setShouldResolveExternalEntities: YES];
	[xmlParser parse];
//	
	[connection release];
	//[webData release];
	//[resultTable reloadData];
    stopActivityIndicator;
}


//xml delegates

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    NSLog(@"*** - (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict ***");

	
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    NSLog(@"*** - (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string ***");

	[nodeContent appendString:[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    NSLog(@"*** - (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName ***");

	if ([elementName isEqualToString:@"CelsiusToFahrenheitResult"]) {
		
		finaldata = nodeContent;
		output.text = finaldata;
		
	}
	output.text = finaldata;
}
/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    NSLog(@"*** didReceiveMemoryWarning ***");

    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    NSLog(@"*** viewDidUnload ***");

    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[txt1 release];
	[output release];
    [super dealloc];
}


@end
