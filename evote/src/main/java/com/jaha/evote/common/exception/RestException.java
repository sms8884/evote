/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 */
package com.jaha.evote.common.exception;

/**
 * <pre>
 * Class Name : RestException.java
 * Description : API 오류 처리
 *  
 * Modification Information
 * 
 * Mod Date         Modifier    Description
 * -----------      --------    ---------------------------
 * 2016. 7. 29.     jjpark      Generation
 * </pre>
 *
 * @author jjpark
 * @since 2016. 7. 29.
 * @version 1.0
 */
public class RestException extends RuntimeException {

    private static final long serialVersionUID = -2200674710165669771L;

    private String errorCode;
    private String errorMessage;

    RestException() {
        super();
    }

    public RestException(String errorCode, String errorMessage) {
        super(errorMessage);
        this.errorCode = errorCode;
        this.errorMessage = errorMessage;
    }

    @Override
    public String getMessage() {
        return errorMessage;
    }

    public String getErrorMessage() {
        return errorMessage;
    }

    public String getErrroCode() {
        return errorCode;
    }

}
