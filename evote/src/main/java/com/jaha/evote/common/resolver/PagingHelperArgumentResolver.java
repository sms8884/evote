/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 */
package com.jaha.evote.common.resolver;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.MethodParameter;
import org.springframework.web.bind.support.WebArgumentResolver;
import org.springframework.web.context.request.NativeWebRequest;
import org.springframework.web.context.request.RequestAttributes;

import com.jaha.evote.common.util.NumberUtils;
import com.jaha.evote.common.util.PagingHelper;

/**
 * <pre>
 * Class Name : PagingHelperArgumentResolver.java
 * Description : Description
 *  
 * Modification Information
 * 
 * Mod Date         Modifier    Description
 * -----------      --------    ---------------------------
 * 2016. 7. 22.     jjpark      Generation
 * </pre>
 *
 * @author jjpark
 * @since 2016. 7. 22.
 * @version 1.0
 */
public class PagingHelperArgumentResolver implements WebArgumentResolver {

    @Value("${common.paging.default.row}")
    private String pagingDefaultRow;

    @Value("${common.paging.default.col}")
    private String pagingDefaultCol;

    /*
     * (non-Javadoc)
     * @see org.springframework.web.bind.support.WebArgumentResolver#resolveArgument(org.springframework.core.MethodParameter, org.springframework.web.context.request.NativeWebRequest)
     */
    public Object resolveArgument(MethodParameter methodParameter, NativeWebRequest webRequest) throws Exception {
        Class<?> type = methodParameter.getParameterType();

        if (type != null && type.equals(com.jaha.evote.common.util.PagingHelper.class) && webRequest.getNativeRequest() != null && webRequest.getNativeRequest() instanceof HttpServletRequest) {

            PagingHelper helper = new PagingHelper((HttpServletRequest) webRequest.getNativeRequest(), NumberUtils.toInt(pagingDefaultRow, 10), NumberUtils.toInt(pagingDefaultCol, 10));

            webRequest.setAttribute("pagingHelper", helper, RequestAttributes.SCOPE_REQUEST);

            return helper;
        }

        return UNRESOLVED;
    }

}
