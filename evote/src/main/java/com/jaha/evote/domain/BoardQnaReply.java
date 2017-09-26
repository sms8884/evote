/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 */
package com.jaha.evote.domain;

import java.io.Serializable;
import java.util.Date;

/**
 * <pre>
 * Class Name : BoardQnaReply.java
 * Description : QNA 게시물 답변
 *  
 * Modification Information
 * 
 * Mod Date         Modifier    Description
 * -----------      --------    ---------------------------
 * 2016. 10. 5.     jjpark      Generation
 * </pre>
 *
 * @author jjpark
 * @since 2016. 10. 5.
 * @version 1.0
 */
public class BoardQnaReply implements Serializable {

    private static final long serialVersionUID = -4694324094352276894L;

    private long postSeq;
    private String reply;
    private long regUser;
    private Date regDate;
    private long modUser;
    private Date modDate;

    public long getPostSeq() {
        return postSeq;
    }

    public void setPostSeq(long postSeq) {
        this.postSeq = postSeq;
    }

    public String getReply() {
        return reply;
    }

    public void setReply(String reply) {
        this.reply = reply;
    }

    public long getRegUser() {
        return regUser;
    }

    public void setRegUser(long regUser) {
        this.regUser = regUser;
    }

    public Date getRegDate() {
        return regDate;
    }

    public void setRegDate(Date regDate) {
        this.regDate = regDate;
    }

    public long getModUser() {
        return modUser;
    }

    public void setModUser(long modUser) {
        this.modUser = modUser;
    }

    public Date getModDate() {
        return modDate;
    }

    public void setModDate(Date modDate) {
        this.modDate = modDate;
    }

}
