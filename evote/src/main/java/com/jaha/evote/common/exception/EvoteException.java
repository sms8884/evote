package com.jaha.evote.common.exception;

/**
 * <pre>
 * Class Name : EvoteException.java
 * Description : evote 공통 에러 처리
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
public class EvoteException extends RuntimeException {

    private static final long serialVersionUID = -1108804210005041758L;

    private String message;

    EvoteException() {
        super();
    }

    public EvoteException(String message) {
        super(message);
        this.message = message;
    }

    @Override
    public String getMessage() {
        return message;
    }

}
