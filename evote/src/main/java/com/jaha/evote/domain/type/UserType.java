/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 */
package com.jaha.evote.domain.type;

import java.io.Serializable;

/**
 * <pre>
 * Class Name : UserType.java
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
public enum UserType implements Serializable {

    /** 관리자 */
    ADMIN,

    /** 이메일 회원(정회원) */
    EMAIL,

    /** 휴대번호 회원(비회원) */
    @Deprecated PHONE,

    /** 주민참여위원 */
    CMIT,

    /** 방문객 */
    @Deprecated VISITOR,

    /** 제안등록 방문객 */
    PROPOSAL,

    /** 투표 방문객 */
    VOTE,

    /** QNA 방문객 */
    QNA,

    /** 기타(?) */
    ETC;

}
