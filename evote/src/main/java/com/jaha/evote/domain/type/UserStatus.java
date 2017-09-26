/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 */
package com.jaha.evote.domain.type;

import java.io.Serializable;

/**
 * <pre>
 * Class Name : UserStatus.java
 * Description : Description
 *  
 * Modification Information
 * 
 * Mod Date         Modifier    Description
 * -----------      --------    ---------------------------
 * 2016. 7. 26.     jjpark      Generation
 * </pre>
 *
 * @author jjpark
 * @since 2016. 7. 26.
 * @version 1.0
 */
public enum UserStatus implements Serializable {

    /** 이용가능 */
    AVAILABLE,

    /** 이용정지 */
    SUSPENDED,

    /** 탈퇴 */
    WITHDRAWAL;

}
