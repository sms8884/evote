/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 */
package com.jaha.evote.mapper;

import java.util.HashMap;

import org.apache.ibatis.annotations.Mapper;

/**
 * <pre>
 * Class Name : SmsMapper.java
 * Description : SMS 매퍼
 *  
 * Modification Information
 * 
 * Mod Date         Modifier    Description
 * -----------      --------    ---------------------------
 * 2016. 9. 29.     jjpark      Generation
 * </pre>
 *
 * @author jjpark
 * @since 2016. 9. 29.
 * @version 1.0
 */
@Mapper
public interface SmsMapper {

    /**
     * SMS 전송
     * 
     * @param param
     */
    public void sendMsgNow(HashMap<String, Object> param);

    /**
     * 인증번호 검증
     * 
     * @param param
     * @return
     */
    public HashMap<String, Object> checkAuth(HashMap<String, Object> param);

    /**
     * 인증번호 검증(대상 전화번호 포함)
     * 
     * @param param
     * @return
     */
    public HashMap<String, String> checkAuthWithDestPhone(HashMap<String, Object> param);

    /**
     * 메시지 발송 이력 저장
     * 
     * @param cmid
     * @return
     */
    public int insertMessageSendHist(String cmid);

}
