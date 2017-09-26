/**
 * Copyright (c) 2016 by jahasmart.com. All rights reserved.
 */
package com.jaha.evote.domain;

import java.io.Serializable;

/**
 * <pre>
 * Class Name : ApiResponse.java
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
public class ApiResponse<T> implements Serializable {

    private static final long serialVersionUID = 7452241508069945004L;

    private ApiResponseHeader header;

    private T body;

    public ApiResponse() {
        header = new ApiResponseHeader();
    }

    public ApiResponse(T body) {
        header = new ApiResponseHeader();
        this.body = body;
    }

    public ApiResponse(String resultCode, String resultMessage) {
        header = new ApiResponseHeader(resultCode, resultMessage);
    }

    public ApiResponse(String resultCode, String resultMessage, T body) {
        header = new ApiResponseHeader(resultCode, resultMessage);
        this.body = body;
    }

    public ApiResponseHeader getHeader() {
        return header;
    }

    public void setHeader(ApiResponseHeader header) {
        this.header = header;
    }

    public T getBody() {
        return body;
    }

    public void setBody(T body) {
        this.body = body;
    }

}
