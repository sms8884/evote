/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 */
package com.jaha.evote.mapper;

import com.jaha.evote.domain.PushSendInfo;

/**
 * <pre>
 * Class Name : GcmMapper.java
 * Description : Description
 *  
 * Modification Information
 * 
 * Mod Date         Modifier    Description
 * -----------      --------    ---------------------------
 * 2016. 11. 28.     jjpark      Generation
 * </pre>
 *
 * @author jjpark
 * @since 2016. 11. 28.
 * @version 1.0
 */
public interface GcmMapper {

    /**
     * 푸시 발송 이력
     * 
     * @param pushSendHist
     * @return
     */
    public int insertPushSendHist(PushSendInfo pushSendInfo);

}
