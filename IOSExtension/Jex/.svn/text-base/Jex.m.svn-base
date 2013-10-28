//
//  Jex.m
//  CrazyDice
//
//  Created by Jiangy on 12-7-30.
//  Copyright (c) 2012年 35VI. All rights reserved.
//

#pragma mark -

#import "Jex.h"

#pragma mark - == Sqlite == -

@implementation Sqlite

- (id)init {
    if ((self = [super init])) {
        [self createDatebase];
		resetSQL = NO;
    }
    return self;
}

- (void)doneWithQuery:(NSString *)query {
	sqlite3_stmt * stmt;
	sqlite3_prepare(datebase, [query UTF8String], -1, &stmt, NULL);
	int dbResult = sqlite3_step(stmt);
	if (dbResult != SQLITE_DONE) {
		NSAssert1(0, @"Error in doneWithQuery: <%i>", dbResult);
	}
	sqlite3_finalize(stmt);
}

- (void)debugQuery:(NSString *)query {
	printf("%s\n", [query UTF8String]);
	char * errMsg;
	int dbResult = sqlite3_exec(datebase, [query UTF8String], NULL, NULL, &errMsg);	
	if (dbResult != SQLITE_OK) {
		[self closeDatebase];
		NSAssert2(0, @"Error in saveBattleData: <%i\t%s>", dbResult, errMsg);
	}
}

#pragma mark -

- (void)createDatebase {
	if (![NSFileManager fileExit:[APP resourceInDocument:kDataFile] isDirectory:NO]) {
		if ([self openDatebase]) {
            [self createTable:kTablePlayer];
            [self createTableByApp];
            
			[self closeDatebase];
		}
	}
	
	// MARK: appendTable: when upgrade app
    
    CCLOG(@"DB path: %@", [APP resourceInDocument:kDataFile]);
}

- (BOOL)openDatebase {
	NSString * dbPathName = [APP resourceInDocument:kDataFile];
	int dbResult = sqlite3_open([dbPathName UTF8String], &datebase);
	if (dbResult != SQLITE_OK) {
		sqlite3_close(datebase);
		NSAssert2(0, @"Failed to open database: <%i\t%@>", dbResult, dbPathName);
	}
	return YES;
}

- (void)closeDatebase {
	sqlite3_close(datebase);
}

- (BOOL)existTable:(NSString *)tableName {
	BOOL retResult = YES;
    
	NSString * query = [NSString stringWithFormat:@"SELECT * FROM sqlite_master WHERE type='table' AND name='%@'", tableName]; 
	sqlite3_stmt * stmt;
	sqlite3_prepare(datebase, [query UTF8String], -1, &stmt, NULL);
	if (sqlite3_step(stmt) != SQLITE_ROW) {
		retResult = NO;
	}
	sqlite3_finalize(stmt);
	
	return retResult;
}

- (void)createTable:(NSString *)tableName {
	NSString * createTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@", tableName]; 
	NSString * qurey = [self qureyOfCreateTable:tableName];
	char * errMsg;
	int dbResult = sqlite3_exec(datebase, [[createTable stringByAppendingString:qurey] UTF8String], NULL, NULL, &errMsg);
	if (dbResult != SQLITE_OK) {
		[self closeDatebase];
		NSAssert2(0, @"Error in createTable: <%i\t%s>", dbResult, errMsg);
	}
}

- (void)appendTable:(NSString *)tableName {
	if ([self openDatebase]) {
		[self createTable:tableName];
		[self closeDatebase];
	}
}

- (void)recreateTeable:(NSString *)tableName {
    if ([self openDatebase]) {
        if ([self existTable:tableName]) {
            NSString * query = [NSString stringWithFormat:@"DROP TABLE %@", tableName];
            [self doneWithQuery:query];
        }
        [self createTable:tableName];
        [self closeDatebase];
    }
}

- (void)dropTable:(NSString *)tableName {
	if ([self openDatebase]) {
        if ([self existTable:tableName]) {
            NSString * query = [NSString stringWithFormat:@"DROP TABLE %@", tableName];
            [self doneWithQuery:query];	
        }
        [self closeDatebase];
    }
}

- (void)clearTable:(NSString *)tableName {
	if ([self openDatebase]) {
		NSString * query = [NSString stringWithFormat:@"DELETE FROM %@", tableName];
        [self doneWithQuery:query];
		[self closeDatebase];
	}
}

- (BOOL)isNullTable:(NSString *)tableName {
	BOOL retResult = YES;
	if ([self openDatebase]) {
		NSString * query = [NSString stringWithFormat:@"SELECT * FROM %@", tableName];
		sqlite3_stmt * stmt;
		sqlite3_prepare(datebase, [query UTF8String], -1, &stmt, NULL);
		if (sqlite3_step(stmt) == SQLITE_ROW) {
			retResult = NO;
		}
		sqlite3_finalize(stmt);
		[self closeDatebase];
	}
	return retResult;
}

#pragma mark -

- (void)createTableByApp {
    // NOTE: create table owned by App. Overwrite me
}

- (NSString *)qureyOfCreateTable:(NSString *)tableName {
    if ([tableName isEqualToString:kTablePlayer]) {
		return @"(ID NUMERIC PRIMARY KEY AUTOINCREMENT, name TEXT, usicOn NUMERIC, soundOn NUMERIC)";
	}
    return nil;
}

- (void)loadData {
    // NOTE: load data. Overwrite me
}

- (void)saveData {
    // NOTE: save data. Overwrite me    
}

- (void)resetData {
	// NOTE: reset data. Overwrite me
}

@end

#pragma mark - == GPS == -

@implementation GPS

@synthesize requestFinish, requestFail;
@synthesize coordinate, fullAddress, streetNumber, route, city, province, postalCode, country;

SYNTHESIZE_SINGLETON_FOR_CLASS(GPS);

+ (BOOL)isEnabel {
    return [CLLocationManager locationServicesEnabled];
}

- (id)init {
    if ((self = [super init])) {
        location = [[CLLocationManager alloc] init];
        location.delegate = self;
        location.distanceFilter = 100;
        location.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        
        getCityNext = 0;
        requestFinish = NO;
        requestFail = NO;
        refreshTime = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
#ifdef LOCATION_WITH_MAP
        jexMapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 480, 320)];
        jexMapView.mapType = MKMapTypeStandard;
        jexMapView.showsUserLocation = YES;
        jexMapView.delegate = self;
#endif
    }
    return self;
}

- (void)dealloc {
    RELEASE(refreshTime);
    RELEASE(fullAddress);
    RELEASE(streetNumber);
    RELEASE(route);
    RELEASE(city);
    RELEASE(province);
    RELEASE(postalCode);
    RELEASE(country);
#ifdef LOCATION_WITH_MAP
    RELEASE(jexMapView);
#endif
    [super dealloc];
}

- (void)refresh:(BOOL)getCity {
    if (location && ([refreshTime timeIntervalSinceNow] <= 0
                     || (FLOAT_EQUAL(coordinate.latitude, 0) && FLOAT_EQUAL(coordinate.longitude, 0)))) {
        getCityNext = (getCity ? 1 : 0);
        requestFinish = NO;
        requestFail = NO;
        
        [location startUpdatingLocation];
    }
}

- (void)requestForCity {
#ifdef GPS_LOCAL
    NSString * urlString = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&sensor=true",
                            coordinate.latitude, coordinate.longitude];
    NSURL * requestURL = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest * geocodingRequest=[NSURLRequest requestWithURL:requestURL
                                                     cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                 timeoutInterval:60.0];
    
    // NOTE: create connection and start downloading data
    NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:geocodingRequest delegate:self];
    if (connection) {
        receivedData = [[NSMutableData data] retain];
        getCityNext = 2;
    } else {
        CCLOG(@"Request for city fail");
    }
#else
    getCityNext = 2;
    requestFinish = YES;
#endif
}

/*!
 @function
 @abstract   忽略“省”，“市”
 @return     void
 */
- (void)ignoreProvinceName {
    if ([province hasSuffix:@"省"] || [province hasSuffix:@"市"]) {
        province = [[province substringWithRange:NSMakeRange(0, [province length] - 1)] copy];
    }
}

- (NSString *)provinceAndCity {
    return [NSString stringWithFormat:@"%@ %@", province, city];
}

#pragma mark -

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    CCLOG(@"GPS Location: {%f, %f}", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
#ifdef LOCATION_WITH_MAP
    jexMapView.showsUserLocation = YES;
#else
    coordinate = newLocation.coordinate;
    if ([CURRENT_DEVICE isSimulator]) {
        coordinate.latitude = 23.129163;
        coordinate.longitude = 113.264435;
    }
    if (getCityNext > 0) {
        if (getCityNext == 1) {
            [self requestForCity];
        }
    } else {
        requestFinish = YES;
    }
    [location stopUpdatingLocation];
    RELEASE(refreshTime);
    refreshTime = [[NSDate alloc] initWithTimeIntervalSinceNow:REFRESH_INTERVAL];
#endif
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
	CCLOG(@"Failed to find location!");
    requestFail = YES;
    requestFinish = YES;
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    CCLOG(@"Map Location: {%f, %f}", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
    coordinate = userLocation.location.coordinate;
    if ([CURRENT_DEVICE isSimulator]) {
        coordinate.latitude = 23.129163;
        coordinate.longitude = 113.264435;
    }
    if (getCityNext > 0) {
        if (getCityNext == 1) {
            [self requestForCity];
        }
    } else {
        requestFinish = YES;
    }
    [location stopUpdatingLocation];
    RELEASE(refreshTime);
    refreshTime = [[NSDate alloc] initWithTimeIntervalSinceNow:REFRESH_INTERVAL];
    jexMapView.showsUserLocation = NO;
}

- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error {
    CCLOG(@"Failed to locate user!");
    requestFail = YES;
    requestFinish = YES;
    jexMapView.showsUserLocation = NO;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    CCLOG(@"Connection failed! Error - %@ %@",
          [error localizedDescription], [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    RELEASE(connection);
    RELEASE(receivedData);
    requestFail = YES;
    requestFinish = YES;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSDictionary * resultDict = [JSON_READ deserializeAsDictionary:receivedData error:nil];
	NSString * status = [resultDict valueForKey:@"status"];
	if ([status isEqualToString:@"OK"]) {
		// NOTE: get first element as array
		NSArray * firstResultAddress = [[[resultDict objectForKey:@"results"] objectAtIndex:0] objectForKey:@"address_components"];
		streetNumber = [Jex addressComponent:@"street_number" inAddressArray:firstResultAddress ofType:@"long_name"];
		route = [Jex addressComponent:@"route" inAddressArray:firstResultAddress ofType:@"long_name"];
		city = [Jex addressComponent:@"locality" inAddressArray:firstResultAddress ofType:@"long_name"];
		province = [Jex addressComponent:@"administrative_area_level_1" inAddressArray:firstResultAddress ofType:@"short_name"];
		postalCode = [Jex addressComponent:@"postal_code" inAddressArray:firstResultAddress ofType:@"short_name"];
		country = [Jex addressComponent:@"country" inAddressArray:firstResultAddress ofType:@"long_name"];
        
	} else {
		CCLOG(@"Connection failed: %@", status);
        requestFail = YES;
	}
    requestFinish = YES;
}

@end

#pragma mark - == IAP == -

@implementation IAP

@synthesize completeTrans, failedTrans, restoreTrans;
@synthesize delegate, verifyRecepitMode;
@dynamic paymentObserver;

SYNTHESIZE_SINGLETON_FOR_CLASS(IAP);

- (id)init {
	if ((self = [super init])) {
        completeTrans = [[NSMutableArray alloc] init];
        failedTrans = [[NSMutableArray alloc] init];
        restoreTrans = [[NSMutableArray alloc] init];
        [self setPaymentObserver:self];
	}
	return self;
}

- (void)dealloc {
    RELEASE(completeTrans);
    RELEASE(failedTrans);
    RELEASE(restoreTrans);
    
    [super dealloc];
}

- (id <SKPaymentTransactionObserver>)paymentObserver {
    return paymentObserver;
}
- (void)setPaymentObserver:(id <SKPaymentTransactionObserver>)observer {
    if (paymentObserver) {
        [[SKPaymentQueue defaultQueue] removeTransactionObserver:paymentObserver];
    }
    RELEASE(paymentObserver);
    paymentObserver = [observer retain];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:paymentObserver];
}

#pragma mark - == SKPaymentTransactionObserver == -

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
	for (SKPaymentTransaction * transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    }
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    CCLOG(@"Purchase Successful");
	[self recordTransaction:transaction withStatus:0];
    [self provideContent:transaction.payment.productIdentifier];
    switch (verifyRecepitMode) {
        case kIAPVerifyRecepitModeNone:
            [delegate didCompleteTransaction:transaction.payment.productIdentifier];
            break;
        case kIAPVerifyRecepitModeDevice:
            [self verifyReceipt:transaction];
            break;
        case kIAPVerifyRecepitModeServer:
            [delegate verifyReceipt:transaction];
            break;
        default:
            break;
    }
	[[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    CCLOG(@"Restore Transaction");
    [self recordTransaction:transaction withStatus:1];
    [self provideContent:transaction.originalTransaction.payment.productIdentifier];
	[delegate didRestoreTransaction:transaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    CCLOG(@"Failed Transaction");
	[self recordTransaction:transaction withStatus:2];
	[delegate didFailedTransaction:transaction.payment.productIdentifier];
	[[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

#pragma mark -

- (void)recordTransaction:(SKPaymentTransaction *)transaction withStatus:(int)status {
	switch (status) {
        case 0:
            [completeTrans addObject:transaction];
            break;
        case 1:
            [restoreTrans addObject:transaction];
            break;
        case 2:
            [failedTrans addObject:transaction];
            break;
            
        default:
            break;
    }
}

- (void)provideContent:(NSString *)productIdentifier {
    
}

#pragma mark -

- (void)requestProductData:(NSString *)proIdentifier {
    if ([SKPaymentQueue canMakePayments]) {
        productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:proIdentifier]];
		productsRequest.delegate = self;
		[productsRequest start];
    }
}

- (void)requestProductsData:(NSArray *)proIdentifiers {
	NSSet * sets = [NSSet setWithArray:proIdentifiers];
    productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:sets];
    productsRequest.delegate = self;
    [productsRequest start];
}

#pragma mark - == SKProductsRequestDelegate == -

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    NSArray * products = response.products;
	[delegate didReceivedProducts:products];
	[productsRequest release];
}

- (void)addPayment:(NSString *)productIdentifier {
    if ([SKPaymentQueue canMakePayments]) {        
        SKPayment * payment = [SKPayment paymentWithProductIdentifier:productIdentifier];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
}

- (void)verifyReceipt:(SKPaymentTransaction *)transaction {
	networkQueue = [ASINetworkQueue queue];
	[networkQueue retain];
	NSURL * verifyURL = [NSURL URLWithString:IAP_URL];
	ASIHTTPRequest * vryRequest = [[ASIHTTPRequest alloc] initWithURL:verifyURL];
	[vryRequest setRequestMethod: @"POST"];
	[vryRequest setDelegate:self];
	[vryRequest setDidFinishSelector:@selector(didFinishVerify:)];
	[vryRequest addRequestHeader:@"Content-Type" value:@"application/json"];
	
	NSString * recepit = [GTMBase64 stringByEncodingData:transaction.transactionReceipt];
	NSDictionary * data = [NSDictionary dictionaryWithObjectsAndKeys:recepit, @"receipt-data", nil];
	[vryRequest appendPostData:[data JSONData]];
	[networkQueue addOperation:vryRequest];
	[networkQueue go];
}

- (void)didFinishVerify:(ASIHTTPRequest *)request {
	NSString * response = [request responseString];
	NSDictionary * jsonData = [NSDictionary dictionaryWithJSONData:[response JSONData]];
	NSString * status = [jsonData objectForKey:@"status"];
	if ([status intValue] == 0) {
		NSDictionary * receipt = [jsonData objectForKey:@"receipt"];
        NSString * productIdentifier = [receipt objectForKey:@"product_id"];
		[delegate didCompleteTransactionAndVerifySucceed:productIdentifier];
	} else {
		NSString * exception = [jsonData objectForKey:@"exception"];
		[delegate didCompleteTransactionAndVerifyFailed:exception];
	}
}

@end

#pragma mark - == Update == -

@interface Update (Jex)
- (NSString *)updateResourcePath:(NSString *)resName;
@end

@implementation Update

@synthesize localPath, fileName, pathCCB, pathFace, pathNormal, pathPlist, pathPNG, pathZip;
@dynamic urlPath, delegate;

SYNTHESIZE_SINGLETON_FOR_CLASS(Update);

- (id)init {
    if ((self = [super init])) {
        [self setDefault];
    }
    return self;
}

- (void)dealloc {
    RELEASE(urlPath);
    RELEASE(localPath);
    RELEASE(fileName);
    RELEASE(pathCCB);
    RELEASE(pathFace);
    RELEASE(pathNormal);
    RELEASE(pathPlist);
    RELEASE(pathPNG);
    RELEASE(pathZip);
    RELEASE(queue);
    
    [super dealloc];
}

- (id<ASIHTTPRequestDelegate,ASIProgressDelegate>)delegate {
    return delegate;
}
- (void)setDelegate:(id<ASIHTTPRequestDelegate,ASIProgressDelegate>)dstDelegate {
    delegate = dstDelegate;
    queue = [[ASINetworkQueue alloc] init];
    [queue setDelegate:delegate];
    [queue setDownloadProgressDelegate:delegate];
    [queue setShowAccurateProgress:YES];
    [queue setRequestDidFinishSelector:@selector(requestFinished:)];
    [queue setRequestDidFailSelector:@selector(requestFailed:)];
    [queue setShouldCancelAllRequestsOnFailure:YES];
    [queue setMaxConcurrentOperationCount:1];
    [queue go];
}

- (void)setDelegate:(id<ASIHTTPRequestDelegate,ASIProgressDelegate>)dstDelegate withProgress:(UIProgressView *)progress; {
    [self setDelegate:dstDelegate];
    [queue setDownloadProgressDelegate:progress];
}

- (NSString *)urlPath {
    return urlPath;
}
- (void)setUrlPath:(NSString *)dstURL {
    if (dstURL && ![[dstURL trim] isEqualToString:urlPath]) {
        RELEASE(urlPath)
        urlPath = [[dstURL trim] retain];
        [self setFileName:[urlPath lastPathComponent]];
    }
}

- (void)setDefault {
    [self setLocalPath:[UIDevice documentPath]];
    NSString * appPath = [APP documentPath];
    [self setPathNormal:[NSString stringWithFormat:@"%@/normal", appPath]];
    [self setPathFace:[NSString stringWithFormat:@"%@/face", appPath]];
    [self setPathCCB:[NSString stringWithFormat:@"%@/ccb", localPath]];
    [self setPathPNG:pathCCB];
    [self setPathPlist:pathNormal];
    [self setPathZip:pathNormal];
    
    [self createPath];
}

- (void)createPath {
    NSFileManager * fm = [NSFileManager defaultManager];
    BOOL isDirectory = YES;
    if (![fm fileExistsAtPath:pathNormal isDirectory:&isDirectory]) {
        [fm createDirectoryAtPath:pathNormal withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if (![fm fileExistsAtPath:pathFace isDirectory:&isDirectory]) {
        [fm createDirectoryAtPath:pathFace withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if (![fm fileExistsAtPath:pathCCB isDirectory:&isDirectory]) {
        [fm createDirectoryAtPath:pathCCB withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if (![fm fileExistsAtPath:pathPlist isDirectory:&isDirectory]) {
        [fm createDirectoryAtPath:pathPlist withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if (![fm fileExistsAtPath:pathPNG isDirectory:&isDirectory]) {
        [fm createDirectoryAtPath:pathPNG withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if (![fm fileExistsAtPath:pathZip isDirectory:&isDirectory]) {
        [fm createDirectoryAtPath:pathZip withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

- (void)clearUpdate {
    [NSFileManager clearPath:pathPlist];
    [NSFileManager clearPath:pathNormal];
}

- (void)downloadFile:(NSString *)dstURL {
    [self setUrlPath:dstURL];
    NSString * dstPath = [self updateResourcePath:fileName];
    [self downloadFile:dstURL toPath:dstPath];
}

- (void)downloadFile:(NSString *)dstURL toPath:(NSString *)dstPath {
    [self setUrlPath:dstURL];
    NSURL * fileUrl = [NSURL URLWithString:urlPath];
    if (fileUrl) {
        NSString * fullPath = [NSString stringWithFormat:@"%@/%@", dstPath, fileName];
        if (!queue.delegate || !queue.downloadProgressDelegate) {
            [self setDelegate:nil withProgress:nil];
        }
        ASIHTTPRequest * request = [[[ASIHTTPRequest alloc] initWithURL:fileUrl] autorelease];
        [request setDelegate:queue.delegate];
        [request setDownloadDestinationPath:fullPath];
        [queue addOperation:request];
        CCLOG(@"Download %@ to %@", dstURL, fullPath);
    }
}

- (void)uploadFile:(NSString *)filePath forKey:(NSString *)fileKey toURL:(NSString *)dstURL withParameters:(NSDictionary *)params {
    if ([NSFileManager fileExit:filePath isDirectory:NO]) {
        ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:dstURL]];
        [request setFile:filePath forKey:fileKey];
        for (NSString * key in params) {
            [request setPostValue:[params objectForKey:key] forKey:key];
        }
        [request setDelegate:delegate];
        [request startAsynchronous];
    }
}

- (NSInteger)downloadRest {
    if ([queue requestsCount] == 0) {
        [queue reset];
    }
    return [queue requestsCount];
}

- (NSString *)updateResourceFullPath:(NSString *)resName {
    NSString * dstPath = [self updateResourcePath:resName];
    return [NSString stringWithFormat:@"%@/%@", dstPath, resName];
}

- (NSString *)updateResourcePath:(NSString *)resName {
    NSString * dstPath = pathNormal;
    if ([resName hasPrefix:@"DIY@35_"] || [resName hasPrefix:@"PIC@35_"]) {
        dstPath = pathFace;
    } else if ([resName hasSuffix:@"plist"] || [resName hasPrefix:@"Ani-"]) {
        dstPath = pathPlist;
    } else if ([resName hasSuffix:@"zip"]) {
        dstPath = pathZip;
    } else if ([resName hasSuffix:@"ccbi"]) {
        dstPath = pathCCB;
    } else if ([resName hasSuffix:@"png"]) {
        dstPath = pathPNG;
    } else if ([resName hasSuffix:@"ipa"]) {
        dstPath = [APP documentPath];
    }
    return dstPath;
}

@end

#pragma mark - == Jex == -

@implementation Jex

+ (NSInteger)randomBetween:(NSInteger)from And:(NSInteger)to {
	static BOOL haveSeeds;
	if (!haveSeeds) {
		srand((unsigned) time(NULL));
		haveSeeds = YES;
	}
	NSInteger randonNum = from + rand() % (to - from);
	return randonNum;
}

+ (CGFloat)distanceBetweenPoint:(CGPoint)pFrom andPoint:(CGPoint)pTo {
	CGFloat dx = pTo.x - pFrom.x;
	CGFloat dy = pTo.y - pFrom.y;
	return sqrt(dx * dx + dy * dy);
}

+ (CGFloat)angleBetweenPoint:(CGPoint)pFrom andPoint:(CGPoint)pTo {
	CGFloat dw = pTo.x - pFrom.x;
	CGFloat dh = pTo.y - pFrom.y;
	CGFloat angle;
	if (dw == 0) {
		if (dh > 0) {
			angle = 90;
		} else if (dh < 0) {
			angle = 270;
		} else {
			angle = 0;
		}
	} else {
		float randians = atan(dh / dw);
		angle = RADIANS_TO_DEGREES(randians);
		angle += (dw < 0 ? 180 : 0);
		angle += (dh < 0 ? 360 : 0);
	}
	
	return (int)angle % 360;
}

+ (CGFloat)angleFromLineWithFromPoint:(CGPoint)lFromPFrom andToPoint:(CGPoint)lFromPTo 
				  toLineWithFromPoint:(CGPoint)lToPFrom andToPoint:(CGPoint)lToPTo {
	CGFloat angleFrom = [self angleBetweenPoint:lFromPFrom andPoint:lFromPTo];
	CGFloat angleTo = [self angleBetweenPoint:lToPFrom andPoint:lToPTo];
	return (int)(180 + (angleTo - angleFrom) + 360) % 360;
}

+ (CGPoint)rectCenter:(CGRect)rect {
	CGPoint center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
	return center;
}

+ (CGFloat)quadrantOfAngle:(CGFloat)angle {
	return angle / 90;
}

/*!
 @abstract  Finds an address component of a specific type inside the given address components array
 */
+ (NSString *)addressComponent:(NSString *)component inAddressArray:(NSArray *)array ofType:(NSString *)type {
	int index = [array indexOfObjectPassingTest:^(id obj, NSUInteger idx, BOOL *stop) {
        return [(NSString *)([[obj objectForKey:@"types"] objectAtIndex:0]) isEqualToString:component];
	}];
	if (index == NSNotFound) {
        return nil;
    }
	return [[[array objectAtIndex:index] valueForKey:type] copy];
}

+ (BOOL)isMobileNumber:(NSString *)mobileNum {
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,147,150,151,157,158,159,182,183,187,188
     * 联通：130,131,132,145,152,155,156,185,186
     * 电信：133,1349,153,180,181,189
     */
    NSString * MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[01235-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,147,150,151,157,158,159,182,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|47|5[017-9]|8[2378])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,145,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|45|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,181,189
     22         */
    NSString * CT = @"^1((33|53|8[019])[0-9]|349)\\d{7}$";
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
        || ([regextestcu evaluateWithObject:mobileNum] == YES)) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)validateEmail:(NSString *)email {
    if((0 != [email rangeOfString:@"@"].length) && (0 != [email rangeOfString:@"."].length)) {
        NSCharacterSet * tmpInvalidCharSet = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
        NSMutableCharacterSet * tmpInvalidMutableCharSet = [[tmpInvalidCharSet mutableCopy] autorelease];
        [tmpInvalidMutableCharSet removeCharactersInString:@"_-"];
        
        //使用compare option 来设定比较规则，如
        //NSCaseInsensitiveSearch是不区分大小写
        //NSLiteralSearch 进行完全比较,区分大小写
        //NSNumericSearch 只比较定符串的个数，而不比较字符串的字面值
        NSRange range1 = [email rangeOfString:@"@" options:NSCaseInsensitiveSearch];
        
        //取得用户名部分
        NSString * userNameString = [email substringToIndex:range1.location];
        NSArray * userNameArray   = [userNameString componentsSeparatedByString:@"."];
        
        for(NSString * string in userNameArray) {
            NSRange rangeOfInavlidChars = [string rangeOfCharacterFromSet:tmpInvalidMutableCharSet];
            if(rangeOfInavlidChars.length != 0 || [string isEqualToString:@""]) {
                return NO;
            }
        }
        
        NSString * domainString = [email substringFromIndex:range1.location + 1];
        NSArray * domainArray   = [domainString componentsSeparatedByString:@"."];
        
        for(NSString * string in domainArray) {
            NSRange rangeOfInavlidChars=[string rangeOfCharacterFromSet:tmpInvalidMutableCharSet];
            if(rangeOfInavlidChars.length !=0 || [string isEqualToString:@""])
                return NO;
        }
        
        return YES;
        
    } else {
        return NO;
    }
}

+ (void)logToFile:(NSString *)log {
    NSString * content = [NSString stringWithFormat:@"%@>> %@", [NSDate localeDate], log];
    [NSFileManager appendContent:content toFile:[APP resourceInDocument:@"log.txt"]];
}

@end
