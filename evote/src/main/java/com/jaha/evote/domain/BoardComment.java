/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 */
package com.jaha.evote.domain;

import java.io.Serializable;
import java.util.Date;

/**
 * <pre>
 * Class Name : BoardComment.java
 * Description : 게시물 댓글
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
public class BoardComment implements Serializable {

    private static final long serialVersionUID = -2878211555870658869L;

    private long cmtSeq;
    private long postSeq;
    private String comment;
    private long regUser;
    private Date regDate;
    private long modUser;
    private Date modDate;

    public long getCmtSeq() {
        return cmtSeq;
    }

    public void setCmtSeq(long cmtSeq) {
        this.cmtSeq = cmtSeq;
    }

    public long getPostSeq() {
        return postSeq;
    }

    public void setPostSeq(long postSeq) {
        this.postSeq = postSeq;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
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
