package com.jaha.evote.common.exception;

/**
 * <pre>
 * Class Name : EvoteFileNotFoundException.java
 * Description : 파일 관련 오류 처리
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
public class EvoteFileNotFoundException extends RuntimeException {

    private static final long serialVersionUID = 1393803654239158891L;

    private String message;

    EvoteFileNotFoundException() {
        super();
    }

    public EvoteFileNotFoundException(String message) {
        super(message);
        this.message = message;
    }

    @Override
    public String getMessage() {
        return message;
    }

}
