/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 */
package com.jaha.evote.mapper.common;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.jaha.evote.domain.common.FileInfo;
import com.jaha.evote.domain.type.FileGrpType;
import com.jaha.evote.domain.type.FileType;

/**
 * <pre>
 * Class Name : FileMapper.java
 * Description : 파일 매퍼
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
@Mapper
public interface FileMapper {

    /**
     * 파일 정보 조회
     * 
     * @param fileSeq
     * @return
     */
    public FileInfo selectFileInfo(long fileSeq);

    /**
     * 파일 목록 조회
     * 
     * @param fileGrpSeq
     * @return
     */
    public List<FileInfo> selectFileInfoList(@Param("fileGrpSeq") long fileGrpSeq, @Param("fileGrpType") FileGrpType fileGrpType, @Param("fileType") FileType fileType);

    /**
     * 파일 정보 등록
     * 
     * @param fileVO
     * @return
     */
    public int insertFileInfo(FileInfo fileVO);

    /**
     * 파일 정보 삭제
     * 
     * @param fileVO
     * @return
     */
    public int deleteFileInfo(FileInfo fileVO);

    /**
     * 파일 그룹 삭제
     * 
     * @param fileVO
     * @return
     */
    public int deleteFileGroup(FileInfo fileVO);

}
