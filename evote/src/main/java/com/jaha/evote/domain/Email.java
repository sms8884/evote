/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 */
package com.jaha.evote.domain;

import java.io.Serializable;

/**
 * <pre>
 * Class Name : Email.java
 * Description : Description
 *  
 * Modification Information
 * 
 * Mod Date         Modifier    Description
 * -----------      --------    ---------------------------
 * 2016. 9. 20.     jjpark      Generation
 * </pre>
 *
 * @author jjpark
 * @since 2016. 9. 20.
 * @version 1.0
 */
public class Email implements Serializable {

    private static final long serialVersionUID = 5740282569974555937L;

    private String subject;
    private String content;
    private String regdate;
    private String reciver;
    private String sender;

    public String getReciver() {
        return reciver;
    }

    public void setReciver(String reciver) {
        this.reciver = reciver;
    }

    public String getSubject() {
        return subject;
    }

    public void setSubject(String subject) {
        this.subject = subject;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getRegdate() {
        return regdate;
    }

    public void setRegdate(String regdate) {
        this.regdate = regdate;
    }

    public String getSender() {
        return sender;
    }

    public void setSender(String sender) {
        this.sender = sender;
    }


}
