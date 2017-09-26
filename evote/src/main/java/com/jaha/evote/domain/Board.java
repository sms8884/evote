/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 */
package com.jaha.evote.domain;

import java.io.Serializable;
import java.util.Date;

import com.jaha.evote.domain.type.BoardType;
import com.jaha.evote.domain.type.RoleType;

/**
 * <pre>
 * Class Name : Board.java
 * Description : 게시판
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
public class Board implements Serializable {

    private static final long serialVersionUID = 4937598626545212044L;

    private long boardSeq;
    private String boardName;
    private BoardType boardType;
    private String boardTitle;
    private String attachUseYn;
    private String imageUseYn;
    private int maxAttachCount;
    private int maxImageCount;
    private String replyUseYn;
    private String commentUseYn;
    private String topUseYn;
    private String cateUseYn;
    private String pushUseYn;
    private String secUseYn;
    private String editorUseYn;
    private RoleType writeRole;
    private Date regDate;
    private long regUser;
    private Date modDate;
    private long modUser;

    public long getBoardSeq() {
        return boardSeq;
    }

    public void setBoardSeq(long boardSeq) {
        this.boardSeq = boardSeq;
    }

    public String getBoardName() {
        return boardName;
    }

    public void setBoardName(String boardName) {
        this.boardName = boardName;
    }

    public BoardType getBoardType() {
        return boardType;
    }

    public void setBoardType(BoardType boardType) {
        this.boardType = boardType;
    }

    public String getBoardTitle() {
        return boardTitle;
    }

    public void setBoardTitle(String boardTitle) {
        this.boardTitle = boardTitle;
    }

    public String getAttachUseYn() {
        return attachUseYn;
    }

    public void setAttachUseYn(String attachUseYn) {
        this.attachUseYn = attachUseYn;
    }

    public String getImageUseYn() {
        return imageUseYn;
    }

    public void setImageUseYn(String imageUseYn) {
        this.imageUseYn = imageUseYn;
    }

    public int getMaxAttachCount() {
        return maxAttachCount;
    }

    public void setMaxAttachCount(int maxAttachCount) {
        this.maxAttachCount = maxAttachCount;
    }

    public int getMaxImageCount() {
        return maxImageCount;
    }

    public void setMaxImageCount(int maxImageCount) {
        this.maxImageCount = maxImageCount;
    }

    public String getReplyUseYn() {
        return replyUseYn;
    }

    public void setReplyUseYn(String replyUseYn) {
        this.replyUseYn = replyUseYn;
    }

    public String getCommentUseYn() {
        return commentUseYn;
    }

    public void setCommentUseYn(String commentUseYn) {
        this.commentUseYn = commentUseYn;
    }

    public String getTopUseYn() {
        return topUseYn;
    }

    public void setTopUseYn(String topUseYn) {
        this.topUseYn = topUseYn;
    }

    public String getCateUseYn() {
        return cateUseYn;
    }

    public void setCateUseYn(String cateUseYn) {
        this.cateUseYn = cateUseYn;
    }

    public String getPushUseYn() {
        return pushUseYn;
    }

    public void setPushUseYn(String pushUseYn) {
        this.pushUseYn = pushUseYn;
    }

    public String getSecUseYn() {
        return secUseYn;
    }

    public void setSecUseYn(String secUseYn) {
        this.secUseYn = secUseYn;
    }

    public RoleType getWriteRole() {
        return writeRole;
    }

    public void setWriteRole(RoleType writeRole) {
        this.writeRole = writeRole;
    }

    public Date getRegDate() {
        return regDate;
    }

    public void setRegDate(Date regDate) {
        this.regDate = regDate;
    }

    public long getRegUser() {
        return regUser;
    }

    public void setRegUser(long regUser) {
        this.regUser = regUser;
    }

    public Date getModDate() {
        return modDate;
    }

    public void setModDate(Date modDate) {
        this.modDate = modDate;
    }

    public long getModUser() {
        return modUser;
    }

    public void setModUser(long modUser) {
        this.modUser = modUser;
    }

    public String getEditorUseYn() {
        return editorUseYn;
    }

    public void setEditorUseYn(String editorUseYn) {
        this.editorUseYn = editorUseYn;
    }

}
