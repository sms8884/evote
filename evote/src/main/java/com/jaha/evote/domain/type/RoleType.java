/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 */
package com.jaha.evote.domain.type;

import java.io.Serializable;

/**
 * <pre>
 * Class Name : RoleType.java
 * Description : Description
 *  
 * Modification Information
 * 
 * Mod Date         Modifier    Description
 * -----------      --------    ---------------------------
 * 2016. 10. 19.     jjpark      Generation
 * </pre>
 *
 * @author jjpark
 * @since 2016. 10. 19.
 * @version 1.0
 */
public enum RoleType implements Serializable {

    /** 시스템관리자 */
    SYSTEM,

    /** 관리자 */
    ADMIN,

    /** 사용자 */
    USER,

    /** 게스트 */
    GUEST
}
