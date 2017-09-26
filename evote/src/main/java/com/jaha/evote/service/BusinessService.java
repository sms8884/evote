/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 *
 * 2016. 10. 25.
 */
package com.jaha.evote.service;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.jaha.evote.domain.common.FileInfo;
import com.jaha.evote.domain.type.FileGrpType;
import com.jaha.evote.domain.type.FileType;
import com.jaha.evote.mapper.BusinessMapper;
import com.jaha.evote.mapper.common.FileMapper;

/**
 * <pre>
 * Class Name : BusinessService.java
 * Description : Description
 *  
 * Modification Information
 * 
 * Mod Date     Modifier    		  Description
 * -----------      -----------       ---------------------
 * 2016. 10. 25.        MyoungSeop       Generation
 * </pre>
 *
 * @author AAA
 * @since 2016. 10. 25.
 * @version 1.0
 */
@Service
public class BusinessService extends BaseService {

    @Autowired
    BusinessMapper businessMapper;

    @Autowired
    FileMapper fileMapper;


    /**
     * 어드민> 사업현황 리스트 수
     * 
     * @param param
     * @return
     */
    public int getBusinessListCount(HashMap<String, Object> param) {

        logger.debug("BusinessService > businessList");
        param.put("site_cd", getSiteCd());
        return businessMapper.selectBusinessListCount(param);
    }

    /**
     * 어드민>사업현황 리스트
     * 
     * @param param
     * @return
     */
    public List<HashMap<String, Object>> getBusinessList(HashMap<String, Object> param) {
        logger.debug("BusinessService > businessList");
        return businessMapper.selectBusinessList(param);
    }

    /**
     * 어드민>사업현황 등록
     * 
     * @param param
     * @return
     */
    @SuppressWarnings("unchecked")
    @Transactional
    public int insertBusiness(HashMap<String, Object> param) {
        logger.debug("BusinessService > insertBusiness");
        // 등록자 정보 셋팅
        param.put("reg_user", getUserSeq());
        param.put("site_cd", getSiteCd());

        // 게시물 등록
        businessMapper.insertBusiness(param);

        List<FileInfo> imageList = (List<FileInfo>) param.get("imageList");
        List<FileInfo> attachList = (List<FileInfo>) param.get("attachList");


        long biz_seq = (long) param.get("biz_seq");

        if (biz_seq > 0) {

            // 이미지 파일 등록
            if (imageList != null && !imageList.isEmpty()) {
                for (FileInfo fileInfo : imageList) {
                    fileInfo.setFileGrpSeq(biz_seq);
                    fileInfo.setRegUser(getUserSeq());
                    fileMapper.insertFileInfo(fileInfo);
                }
            }

            // 첨부파일 등록
            if (attachList != null && !attachList.isEmpty()) {
                for (FileInfo fileInfo : attachList) {
                    fileInfo.setFileGrpSeq(biz_seq);
                    fileInfo.setRegUser(getUserSeq());
                    fileMapper.insertFileInfo(fileInfo);
                }
            }

        }
        return 0;
    }

    /**
     * 어드민 >사업현황 단건조회
     * 
     * @param biz_seq
     * @return
     */
    public HashMap<String, Object> selectBusiness(HashMap<String, Object> param) {
        logger.debug("BusinessService > selectBusiness");
        param.put("user_seq", getUserSeq());
        HashMap<String, Object> resultMap = businessMapper.selectBusiness(param);
        int tmpbiz_seq = (int) param.get("biz_seq");
        long biz_seq = tmpbiz_seq;
        List<FileInfo> imageList = fileMapper.selectFileInfoList(biz_seq, FileGrpType.BUSINESS, FileType.IMAGE);
        List<FileInfo> attachList = fileMapper.selectFileInfoList(biz_seq, FileGrpType.BUSINESS, FileType.ATTACH);

        resultMap.put("imageList", imageList);
        resultMap.put("attachList", attachList);
        return resultMap;
    }


    /**
     * 어드민>사업현황 업데이트
     * 
     * @param param
     * @return
     */

    @SuppressWarnings("unchecked")
    @Transactional
    public int updateBusiness(HashMap<String, Object> param) {
        logger.debug("BusinessService > updateBusiness");
        // 수정자 정보 셋팅
        param.put("mod_user", getUserSeq());

        // 사업현황 수정
        businessMapper.updateBusiness(param);

        List<FileInfo> imageList = (List<FileInfo>) param.get("imageList");
        List<FileInfo> attachList = (List<FileInfo>) param.get("attachList");
        long biz_seq = (long) param.get("biz_seq");


        // 이미지 파일 등록
        if (imageList != null && !imageList.isEmpty()) {
            for (FileInfo fileInfo : imageList) {
                fileInfo.setFileGrpSeq(biz_seq);
                fileInfo.setRegUser(getUserSeq());
                fileMapper.insertFileInfo(fileInfo);
            }
        }

        // 첨부파일 등록
        if (attachList != null && !attachList.isEmpty()) {
            for (FileInfo fileInfo : attachList) {
                fileInfo.setFileGrpSeq(biz_seq);
                fileInfo.setRegUser(getUserSeq());
                fileMapper.insertFileInfo(fileInfo);
            }
        }
        return 0;
    }

    /**
     * 사업현황 삭제
     * 
     * @param biz_seq
     * @return
     */
    @Transactional
    public int deleteBusiness(int biz_seq) {
        logger.debug("BusinessService > deleteBusiness");
        return businessMapper.deleteBusiness(biz_seq);
    }

    /**
     * 어드민>사업현황 최신4개리스트
     * 
     * @return
     */
    public List<HashMap<String, Object>> getBusinessListTop3() {
        logger.debug("BusinessService > businessList");
        return businessMapper.selectBusinessListTop3();
    }

    /**
     * 사용자 > 사업현황 공감 추가
     * 
     * @param biz_seq
     * @return
     */
    @Transactional
    public long insertSympathy(int biz_seq) {
        logger.debug("BusinessService > insertSympathy");
        HashMap<String, Object> param = new HashMap<String, Object>();
        param.put("biz_seq", biz_seq);
        param.put("user_seq", getUserSeq());
        businessMapper.insertSympathy(param);
        long sympathyCnt = (long) businessMapper.selectBusiness(param).get("sympathyCnt");
        return sympathyCnt;
    }

    /**
     * 사용자 > 사업현황 공감 삭제
     * 
     * @param biz_seq
     * @return
     */
    @Transactional
    public long deleteSympathy(int biz_seq) {
        logger.debug("BusinessService >deleteSympathy");
        HashMap<String, Object> param = new HashMap<String, Object>();
        param.put("biz_seq", biz_seq);
        param.put("user_seq", getUserSeq());
        businessMapper.deleteSympathy(param);
        long sympathyCnt = (long) businessMapper.selectBusiness(param).get("sympathyCnt");

        return sympathyCnt;
    }

}
