//
//  CaseSampleModel.h
//  GuiZhouRMMobile
//
//  Created by auto_ipad on 2013-01-17.
//
//
#import "UpDataModel.h"
#import "CaseSample.h"

@interface CaseSampleModel : UpDataModel

@property (nonatomic, retain) NSString * name;//被取证人姓名
@property (nonatomic, retain) NSString * legal_person;//法人代表
@property (nonatomic, retain) NSString * sex;//被取证人性别
@property (nonatomic, retain) NSString * age;//被取证人年龄
@property (nonatomic, retain) NSString * phone;//被取证人电话
@property (nonatomic, retain) NSString * postalcode;//被取证人邮编
@property (nonatomic, retain) NSString * address;//被取证人地址
@property (nonatomic, retain) NSString * date_sample_start;//取证开始时间
@property (nonatomic, retain) NSString * date_sample_end;//取证结束时间
@property (nonatomic, retain) NSString * place;//取证地点
@property (nonatomic, retain) NSString * remark;//备注
@property (nonatomic, retain) NSString * taking_names;//抽样取证员
@property (nonatomic, retain) NSString * taking_company;//取证单位及地址
@property (nonatomic, retain) NSString * taking_postalcode;//取证单位邮编
@property (nonatomic, retain) NSString * person_incharge;//现场负责人
@property (nonatomic, retain) NSString * taking_company_tel;//取证单位电话
@property (nonatomic, retain) NSString * send_date;//发布时间
@property (nonatomic, retain) NSString * case_sample_reason;//案由

- (id)initWithCaseSample:(CaseSample *)caseSample;
@end

