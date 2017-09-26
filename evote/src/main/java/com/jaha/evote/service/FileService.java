/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 *
 * 2016. 7. 12.
 */
package com.jaha.evote.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.jaha.evote.common.exception.EvoteFileNotFoundException;
import com.jaha.evote.domain.AdminUser;
import com.jaha.evote.domain.common.FileInfo;
import com.jaha.evote.domain.type.FileGrpType;
import com.jaha.evote.domain.type.FileType;
import com.jaha.evote.mapper.common.FileMapper;

/**
 * <pre>
 * Class Name : FileService.java
 * Description : 파일 서비스
 *  
 * Modification Information
 * 
 * Mod Date         Modifier    Description
 * -----------      --------    ---------------------------
 * 2016. 7. 12.     jjpark      Generation
 * </pre>
 *
 * @author jjpark
 * @since 2016. 7. 12.
 * @version 1.0
 */
@Service
public class FileService extends BaseService {

    @Autowired
    private FileMapper fileMapper;

    /**
     * 파일 정보 조회
     * 
     * @param fileSeq
     * @return
     */
    public FileInfo selectFileInfo(long fileSeq) {

        FileInfo fileInfo = fileMapper.selectFileInfo(fileSeq);

        if (fileInfo == null) {
            logger.debug("### 파일정보 없음 ::: fileSeq [{}]", fileSeq);
            throw new EvoteFileNotFoundException("### 파일정보 없음 ::: fileSeq[" + fileSeq + "]");
        }

        // 제안서 첨부파일 권한 체크
        if (!checkProposalFile(fileInfo)) {
            logger.debug("### 파일 권한 오류");
            throw new EvoteFileNotFoundException("### 파일 권한 오류");
        }

        return fileInfo;
    }

    /**
     * 파일 목록 조회(파일 그룹 전체 조회)
     * 
     * @param fileGrpSeq
     * @param fileGrpType
     * @return
     */
    public List<FileInfo> selectFileInfoList(long fileGrpSeq, FileGrpType fileGrpType) {
        return selectFileInfoList(fileGrpSeq, fileGrpType, null);
    }

    /**
     * 파일 목록 조회
     * 
     * @param fileGrpSeq
     * @param fileGrpType
     * @return
     */
    public List<FileInfo> selectFileInfoList(long fileGrpSeq, FileGrpType fileGrpType, FileType fileType) {

        List<FileInfo> fileList = fileMapper.selectFileInfoList(fileGrpSeq, fileGrpType, fileType);

        if (fileList != null && fileList.isEmpty()) {
            for (FileInfo fileInfo : fileList) {
                // 제안서 첨부파일 권한 체크
                if (!checkProposalFile(fileInfo)) {
                    logger.debug("### 파일 권한 오류");
                    throw new EvoteFileNotFoundException("### 파일 권한 오류");
                }
            }
        }

        return fileList;
    }

    /**
     * 파일 정보 등록
     * 
     * @param fileInfo
     */
    @Transactional
    public void insertFileInfo(FileInfo fileInfo) {
        if (fileInfo != null) {
            fileInfo.setRegUser(getUserSeq());
            fileMapper.insertFileInfo(fileInfo);
        }
    }

    /**
     * 단일 파일삭제(삭제 플래그만 변경)
     * 
     * @param fileSeq
     * @return
     */
    @Transactional
    public int deleteFileInfo(long fileSeq) {
        FileInfo fileInfo = new FileInfo();
        fileInfo.setFileSeq(fileSeq);
        fileInfo.setModUser(getUserSeq());
        return fileMapper.deleteFileInfo(fileInfo);
    }

    /**
     * 파일그룹삭제(삭제 플래그만 변경)
     * 
     * @param fileGrpSeq
     * @param fileGrpType
     * @return
     */
    @Transactional
    public int deleteFileGroup(long fileGrpSeq, FileGrpType fileGrpType) {
        FileInfo fileInfo = new FileInfo();
        fileInfo.setFileGrpSeq(fileGrpSeq);
        fileInfo.setFileGrpType(fileGrpType);
        fileInfo.setModUser(getUserSeq());
        return fileMapper.deleteFileGroup(fileInfo);
    }

    /**
     * 파일그룹삭제(삭제 플래그만 변경)
     * 
     * @param fileGrpSeq
     * @param fileGrpType
     * @return
     */
    @Transactional
    public int deleteFileGroup(long fileGrpSeq, FileGrpType fileGrpType, FileType fileType) {
        FileInfo fileInfo = new FileInfo();
        fileInfo.setFileGrpSeq(fileGrpSeq);
        fileInfo.setFileGrpType(fileGrpType);
        fileInfo.setFileType(fileType);
        fileInfo.setModUser(getUserSeq());
        return fileMapper.deleteFileGroup(fileInfo);
    }

    /**
     * 관리자 여부
     * 
     * @return
     */
    private boolean isAdmin() {
        AdminUser adminUser = getLoginAdminUser();
        if (adminUser != null) {
            return true;
        }
        return false;
    }

    /**
     * 제안서 첨부파일 권한 체크
     * 
     * @param fileInfo
     * @return
     */
    private boolean checkProposalFile(FileInfo fileInfo) {
        if (fileInfo != null && fileInfo.getFileGrpType().equals(FileGrpType.PROPOSAL)) {
            if (!isAdmin() && fileInfo.getRegUser() != getUserSeq()) {
                return false;
            }
        }
        return true;
    }
}
