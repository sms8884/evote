package com.jaha.evote.common.exception;

/**
 * <pre>
 * Class Name : PageNotFoundException.java
 * Description : 페이지 없음 오류 처리
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
public class PageNotFoundException extends RuntimeException {

    private static final long serialVersionUID = 8326452410419577951L;

    private String message;

    public PageNotFoundException() {
        super();
    }

    public PageNotFoundException(String message) {
        super(message);
        this.message = message;
    }

    @Override
    public String getMessage() {
        return message;
    }

}
