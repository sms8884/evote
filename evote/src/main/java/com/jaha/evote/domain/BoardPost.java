/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 */
package com.jaha.evote.domain;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

import com.jaha.evote.domain.common.FileInfo;

/**
 * <pre>
 * Class Name : BoardPost.java
 * Description : 게시판 게시물
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
public class BoardPost extends AbstractSearch implements Serializable {

    private static final long serialVersionUID = 3733991572807279837L;

    private long postSeq;
    private long boardSeq;
    private String boardName;
    private String categoryCd;
    private String categoryNm;
    private String siteCd;
    private long parentSeq;
    private int level;
    private String title;
    private String cont;
    private int readCnt;
    private String pushSendYn;
    private Date pushSendDate;
    private String dpYn;
    private String delYn;
    private String topYn;
    private String hideYn;
    private String secYn;
    private String password;
    private String append1; // 추가항목1
    private String append2; // 추가항목2
    private String append3; // 추가항목3
    private String append4; // 추가항목4
    private String append5; // 추가항목5
    private Date replyDate; // 답변저장일
    private Date regDate;
    private long regUser;
    private EncryptedString regUserNm;
    private String regUserNickname;
    private Date modDate;
    private long modUser;

    private List<FileInfo> imageList;
    private List<FileInfo> attachList;

    private FileInfo thumbnail;

    private String adminYn; // 관리자여부
    private String ownerYn; // 글작성자여부

    private String pushYn;  // 푸시 즉시발송 여부

    public long getPostSeq() {
        return postSeq;
    }

    public void setPostSeq(long postSeq) {
        this.postSeq = postSeq;
    }

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

    public String getCategoryCd() {
        return categoryCd;
    }

    public void setCategoryCd(String categoryCd) {
        this.categoryCd = categoryCd;
    }

    public String getCategoryNm() {
        return categoryNm;
    }

    public void setCategoryNm(String categoryNm) {
        this.categoryNm = categoryNm;
    }

    public String getSiteCd() {
        return siteCd;
    }

    public void setSiteCd(String siteCd) {
        this.siteCd = siteCd;
    }

    public long getParentSeq() {
        return parentSeq;
    }

    public void setParentSeq(long parentSeq) {
        this.parentSeq = parentSeq;
    }

    public int getLevel() {
        return level;
    }

    public void setLevel(int level) {
        this.level = level;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getCont() {
        return cont;
    }

    public void setCont(String cont) {
        this.cont = cont;
    }

    public int getReadCnt() {
        return readCnt;
    }

    public void setReadCnt(int readCnt) {
        this.readCnt = readCnt;
    }

    public String getPushSendYn() {
        return pushSendYn;
    }

    public void setPushSendYn(String pushSendYn) {
        this.pushSendYn = pushSendYn;
    }

    public Date getPushSendDate() {
        return pushSendDate;
    }

    public void setPushSendDate(Date pushSendDate) {
        this.pushSendDate = pushSendDate;
    }

    public String getDpYn() {
        return dpYn;
    }

    public void setDpYn(String dpYn) {
        this.dpYn = dpYn;
    }

    public String getDelYn() {
        return delYn;
    }

    public void setDelYn(String delYn) {
        this.delYn = delYn;
    }

    public String getTopYn() {
        return topYn;
    }

    public void setTopYn(String topYn) {
        this.topYn = topYn;
    }

    public String getHideYn() {
        return hideYn;
    }

    public void setHideYn(String hideYn) {
        this.hideYn = hideYn;
    }

    public String getSecYn() {
        return secYn;
    }

    public void setSecYn(String secYn) {
        this.secYn = secYn;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getAppend1() {
        return append1;
    }

    public void setAppend1(String append1) {
        this.append1 = append1;
    }

    public String getAppend2() {
        return append2;
    }

    public void setAppend2(String append2) {
        this.append2 = append2;
    }

    public String getAppend3() {
        return append3;
    }

    public void setAppend3(String append3) {
        this.append3 = append3;
    }

    public String getAppend4() {
        return append4;
    }

    public void setAppend4(String append4) {
        this.append4 = append4;
    }

    public String getAppend5() {
        return append5;
    }

    public void setAppend5(String append5) {
        this.append5 = append5;
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

    public List<FileInfo> getImageList() {
        return imageList;
    }

    public void setImageList(List<FileInfo> imageList) {
        this.imageList = imageList;
    }

    public List<FileInfo> getAttachList() {
        return attachList;
    }

    public void setAttachList(List<FileInfo> attachList) {
        this.attachList = attachList;
    }

    public FileInfo getThumbnail() {
        return thumbnail;
    }

    public void setThumbnail(FileInfo thumbnail) {
        this.thumbnail = thumbnail;
    }

    public String getAdminYn() {
        return adminYn;
    }

    public void setAdminYn(String adminYn) {
        this.adminYn = adminYn;
    }

    public String getOwnerYn() {
        return ownerYn;
    }

    public void setOwnerYn(String ownerYn) {
        this.ownerYn = ownerYn;
    }

    public String getPushYn() {
        return pushYn;
    }

    public void setPushYn(String pushYn) {
        this.pushYn = pushYn;
    }

    public Date getReplyDate() {
        return replyDate;
    }

    public void setReplyDate(Date replyDate) {
        this.replyDate = replyDate;
    }

    public String getRegUserNickname() {
        return regUserNickname;
    }

    public void setRegUserNickname(String regUserNickname) {
        this.regUserNickname = regUserNickname;
    }

    public EncryptedString getRegUserNm() {
        return regUserNm;
    }

    public void setRegUserNm(EncryptedString regUserNm) {
        this.regUserNm = regUserNm;
    }

}
