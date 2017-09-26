/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 */
package com.jaha.evote.domain.type;

import java.io.Serializable;

/**
 * <pre>
 * Class Name : CodeType.java
 * Description : 코드 그룹 정의
 *  
 * Modification Information
 * 
 * Mod Date         Modifier    Description
 * -----------      --------    ---------------------------
 * 2016. 10. 7.     jjpark      Generation
 * </pre>
 *
 * @author jjpark
 * @since 2016. 10. 7.
 * @version 1.0
 */
public enum CodeType implements Serializable {

    /* @formatter:off */
    CODE_GROUP_GENDER("GENDER", "성별")
    , CODE_GROUP_NOTICE_CATEGORY("NOTICE_CTG", "공지구분")
    , CODE_GROUP_PROPOSAL_STATUS("PRPS_STAT", "제안상태")
    , CODE_GROUP_FILE_GROUP("FILE_GROUP", "파일그룹")
    , CODE_GROUP_FILE_TYPE("FILE_TYPE", "파일타입")
    , CODE_GROUP_VOTE_TRGT("VOTE_TRGT", "투표대상")
    , CODE_GROUP_SITE_CD("SITE_CD", "사이트 코드")
    , CODE_GROUP_USER_STAT("USER_STAT", "사용자 상태")
    , CODE_GROUP_USER_TYPE("USER_TYPE", "사용자 타입")
    , CODE_GROUP_ETC_FILE("ETC_FILE", "제안샘플파일")
    , CODE_GROUP_CMIT_CTG("CMIT_CTG", "위원회구분")
    , CODE_GROUP_QNA_CTG("QNA_CTG", "질문구분")
    , CODE_GROUP_GCM_TYPE("GCM_TYPE", "GCM타입")
    
    , ADDR_SGG_EP_CODE("1138000000", "은평구")
    
    , BOARD_NAME_QNA("qna", "문의하기 게시판명")
    
    ;
    /* @formatter:on */

    CodeType(String code, String name) {
        this.code = code;
        this.name = name;
    }

    private final String code;

    private final String name;

    public String getCode() {
        return code;
    }

    public String getName() {
        return name;
    }

    @Override
    public String toString() {
        return String.format("Code:%s, Name:%s", getCode(), getName());
    }
}
