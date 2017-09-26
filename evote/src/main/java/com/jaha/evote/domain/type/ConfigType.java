/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 */
package com.jaha.evote.domain.type;

import java.io.Serializable;

/**
 * <pre>
 * Class Name : ConfigType.java
 * Description : Description
 *  
 * Modification Information
 * 
 * Mod Date         Modifier    Description
 * -----------      --------    ---------------------------
 * 2016. 10. 12.     jjpark      Generation
 * </pre>
 *
 * @author jjpark
 * @since 2016. 10. 12.
 * @version 1.0
 */
public enum ConfigType implements Serializable {

    /* @formatter:off */
    CONFIG_GROUP_PUSH("PUSH", "푸시설정그룹")
    
    , CONFIG_PUSH_NEW("NEW", "새글알림")
    , CONFIG_PUSH_CMT("CMT", "댓글알림")
    , CONFIG_PUSH_VOTE("VOTE", "투표알림")
    
    ;
    /* @formatter:on */

    ConfigType(String code, String name) {
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
