/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 *
 * 2016. 7. 12.
 */
package com.jaha.evote.domain.type;

import java.io.Serializable;

/**
 * <pre>
 * Class Name : FileGrpType.java
 * Description : 파일정보 > 파일그룹코드
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
public enum FileGrpType implements Serializable {

    /** 투표 */
    VOTE,

    /** 제안 */
    PROPOSAL,

    /** 제안 검토 */
    PROP_AUDIT,

    /** 공지 */
    NOTICE,

    /** 게시판 */
    BOARD,

    /** 에디터 첨부파일 */
    EDITOR,

    /** 임시저장 */
    TEMP,

    /** 제안공모 */
    PSSRP,

    /** 위원공모 */
    CMIT,

    /** 위원공모 신청 */
    CMIT_REQ,

    /** 사업현황 */
    BUSINESS,

    /** 팝업 */
    POPUP,

    /** 배너 */
    BANNER,

    /** 기타 */
    ETC;

}
