/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 */
package com.jaha.evote.domain;

import java.io.Serializable;

import com.jaha.evote.domain.type.GcmType;

/**
 * <pre>
 * Class Name : GcmInfo.java
 * Description : Description
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
public class GcmInfo implements Serializable {

    private static final long serialVersionUID = -1703832342485897737L;

    private GcmType gcmType;
    private String pushMessage;
    private String[] args;

    public GcmType getGcmType() {
        return gcmType;
    }

    public void setGcmType(GcmType gcmType) {
        this.gcmType = gcmType;
    }

    public String getPushMessage() {
        return pushMessage;
    }

    public void setPushMessage(String pushMessage) {
        this.pushMessage = pushMessage;
    }

    public String[] getArgs() {
        return args;
    }

    public void setArgs(String[] args) {
        this.args = args;
    }

}
