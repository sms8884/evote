/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 *
 * 2016. 7. 11.
 */
package com.jaha.evote.domain.common;

import java.io.Serializable;
import java.util.Date;

import com.jaha.evote.domain.type.FileGrpType;
import com.jaha.evote.domain.type.FileType;

/**
 * <pre>
 * Class Name : FileVO.java
 * Description : 파일정보
 *  
 * Modification Information
 * 
 * Mod Date         Modifier    Description
 * -----------      --------    ---------------------------
 * 2016. 7. 11.     jjpark      Generation
 * </pre>
 *
 * @author jjpark
 * @since 2016. 7. 11.
 * @version 1.0
 */
public class FileInfo implements Serializable {

    private static final long serialVersionUID = 6034393765681279055L;

    private long fileSeq;
    private FileGrpType fileGrpType;
    private long fileGrpSeq;
    private FileType fileType;
    private int fileOrd;
    private String fileNm;
    private String filePath;
    private String fileSrcNm;
    private String fileExt;
    private long fileSize;
    private String fileDesc;
    private String deleteYn;
    private Date regDate;
    private long regUser;
    private Date modDate;
    private long modUser;

    public long getFileSeq() {
        return fileSeq;
    }

    public void setFileSeq(long fileSeq) {
        this.fileSeq = fileSeq;
    }

    public FileGrpType getFileGrpType() {
        return fileGrpType;
    }

    public void setFileGrpType(FileGrpType fileGrpType) {
        this.fileGrpType = fileGrpType;
    }

    public long getFileGrpSeq() {
        return fileGrpSeq;
    }

    public void setFileGrpSeq(long fileGrpSeq) {
        this.fileGrpSeq = fileGrpSeq;
    }

    public FileType getFileType() {
        return fileType;
    }

    public void setFileType(FileType fileType) {
        this.fileType = fileType;
    }

    public int getFileOrd() {
        return fileOrd;
    }

    public void setFileOrd(int fileOrd) {
        this.fileOrd = fileOrd;
    }

    public String getFileNm() {
        return fileNm;
    }

    public void setFileNm(String fileNm) {
        this.fileNm = fileNm;
    }

    public String getFilePath() {
        return filePath;
    }

    public void setFilePath(String filePath) {
        this.filePath = filePath;
    }

    public String getFileSrcNm() {
        return fileSrcNm;
    }

    public void setFileSrcNm(String fileSrcNm) {
        this.fileSrcNm = fileSrcNm;
    }

    public String getFileExt() {
        return fileExt;
    }

    public void setFileExt(String fileExt) {
        this.fileExt = fileExt;
    }

    public long getFileSize() {
        return fileSize;
    }

    public void setFileSize(long fileSize) {
        this.fileSize = fileSize;
    }

    public String getFileDesc() {
        return fileDesc;
    }

    public void setFileDesc(String fileDesc) {
        this.fileDesc = fileDesc;
    }

    public String getDeleteYn() {
        return deleteYn;
    }

    public void setDeleteYn(String deleteYn) {
        this.deleteYn = deleteYn;
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



}
