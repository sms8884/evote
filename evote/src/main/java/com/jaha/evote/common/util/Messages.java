/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 */
package com.jaha.evote.common.util;

import java.util.Locale;

import javax.annotation.PostConstruct;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Component;

/**
 * <pre>
 * Class Name : Messages.java
 * Description : Description
 *  
 * Modification Information
 * 
 * Mod Date         Modifier    Description
 * -----------      --------    ---------------------------
 * 2016. 8. 3.     jjpark      Generation
 * </pre>
 *
 * @author jjpark
 * @since 2016. 8. 3.
 * @version 1.0
 */
@Component
public class Messages {

    @Autowired
    private MessageSource messageSource;

    private MessageSourceAccessor accessor;

    @PostConstruct
    private void init() {
        accessor = new MessageSourceAccessor(messageSource, Locale.getDefault());
    }

    public String getMessage(String code) {
        return accessor.getMessage(code);
    }

    public String getMessage(String code, String... args) {
        return accessor.getMessage(code, args, Locale.getDefault());
    }

}
