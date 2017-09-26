/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 */
package com.jaha.evote.domain.type;

import java.io.Serializable;

/**
 * <pre>
 * Class Name : TermsType.java
 * Description : Description
 *  
 * Modification Information
 * 
 * Mod Date         Modifier    Description
 * -----------      --------    ---------------------------
 * 2016. 8. 23.     jjpark      Generation
 * </pre>
 *
 * @author jjpark
 * @since 2016. 8. 23.
 * @version 1.0
 */
public enum TermsType implements Serializable {

    /** 서비스 이용약관 */
    SERVICE,

    /** 개인정보취급(처리)방침 */
    PRIVACY1,

    /** 개인정보 수집•이용 동의(필수) */
    PRIVACY2,

    /** 개인정보 수집•이용 동의(선택) */
    PRIVACY3
}
