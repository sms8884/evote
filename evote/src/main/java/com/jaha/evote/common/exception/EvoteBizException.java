package com.jaha.evote.common.exception;

/**
 * <pre>
 * Class Name : EvoteBizException.java
 * Description : evote 비지니스 오류 처리
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
public class EvoteBizException extends RuntimeException {

    private static final long serialVersionUID = -1108804210005041758L;

    private String message;

    EvoteBizException() {
        super();
    }

    public EvoteBizException(String message) {
        super(message);
        this.message = message;
    }

    @Override
    public String getMessage() {
        return message;
    }

}
