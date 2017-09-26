/**
 * Copyright (c) 2016 by jahasmart.com. All rights reserved.
 */
package com.jaha.evote.domain;

import java.io.Serializable;

/**
 * <pre>
 * Class Name : ApiResponseHeader.java
 * Description : Description
 *  
 * Modification Information
 * 
 * Mod Date         Modifier    Description
 * -----------      --------    ---------------------------
 * 2016. 10. 4.     jjpark      Generation
 * </pre>
 *
 * @author jjpark
 * @since 2016. 10. 4.
 * @version 1.0
 */
public class ApiResponseHeader implements Serializable {

    private static final long serialVersionUID = -7536284729178794159L;

    /**
     * 오류 코드 "00" : 요청 성공, 이외의 경우 오류상태
     */
    private String resultCode = "00";

    /**
     * 오류 메시지
     */
    private String resultMessage = "SUCCESS";

    public ApiResponseHeader() {

    }

    public ApiResponseHeader(String resultCode, String resultMessage) {
        this.resultCode = resultCode;
        this.resultMessage = resultMessage;
    }

    public String getResultCode() {
        return resultCode;
    }

    public void setResultCode(String resultCode) {
        this.resultCode = resultCode;
    }

    public String getResultMessage() {
        return resultMessage;
    }

    public void setResultMessage(String resultMessage) {
        this.resultMessage = resultMessage;
    }

}
