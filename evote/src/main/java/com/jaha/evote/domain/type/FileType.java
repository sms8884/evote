/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 *
 * 2016. 7. 12.
 */
package com.jaha.evote.domain.type;

import java.io.Serializable;

/**
 * <pre>
 * Class Name : FileType.java
 * Description : 파일정보 > 파일타입
 *  
 * Modification Information
 * 
 * Mod Date         Modifier    Description
 * -----------      --------    ---------------------------
 * 2016. 7. 12.     jjpark      Generation
 * </pre>
 *
 * @author jjpark
 * @since 2016. 7. 12.
 * @version 1.0
 */
public enum FileType implements Serializable {

    /** 이미지 */
    IMAGE,

    /** 첨부파일 */
    ATTACH,

    /** 제안공모 > 신청분야 */
    REQ_REALM,

    /** 제안공모 > 신청방법 */
    REQ_METHOD,

    /** 제안공모 > 흐름도 이미지(PC웹) */
    IMG_WEB,

    /** 제안공모 > 흐름도 이미지(모바일) */
    IMG_MOB;

}
