/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 */
package com.jaha.evote.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.googlecode.ehcache.annotations.TriggersRemove;
import com.jaha.evote.common.util.NumberUtils;
import com.jaha.evote.domain.BannerPop;
import com.jaha.evote.domain.SearchList;
import com.jaha.evote.domain.common.FileInfo;
import com.jaha.evote.domain.type.FileGrpType;
import com.jaha.evote.domain.type.FileType;
import com.jaha.evote.mapper.BannerPopMapper;
import com.jaha.evote.mapper.common.FileMapper;

/**
 * <pre>
 * Class Name : BannerPopService.java
 * Description : Description
 *  
 * Modification Information
 * 
 * Mod Date         Modifier    Description
 * -----------      --------    ---------------------------
 * 2016. 10. 28.     jjpark      Generation
 * </pre>
 *
 * @author jjpark
 * @since 2016. 10. 28.
 * @version 1.0
 */
@Service
public class BannerPopService extends BaseService {

    @Autowired
    private BannerPopMapper bannerPopMapper;

    @Autowired
    private FileMapper fileMapper;

    /**
     * 배너/팝업 조회
     * 
     * @param searchParam
     * @return
     */
    public SearchList<BannerPop> selectBannerPopList(BannerPop searchParam) {

        searchParam.setSiteCd(getSiteCd());

        int count = bannerPopMapper.selectBannerPopListCount(searchParam);

        List<BannerPop> list = bannerPopMapper.selectBannerPopList(searchParam);

        return new SearchList<BannerPop>(list, count);
    }

    /**
     * 배너/팝업 상세조회
     * 
     * @param mgmtType
     * @param bpSeq
     * @return
     */
    public BannerPop selectBannerPop(String mgmtType, long bpSeq) {

        if (mgmtType != null) {

            FileGrpType fileGrpType = null;

            Map<String, Object> param = new HashMap<>();
            param.put("siteCd", getSiteCd());
            param.put("type", mgmtType.toUpperCase());
            param.put("bpSeq", bpSeq);

            if ("POPUP".equalsIgnoreCase(mgmtType)) {
                fileGrpType = FileGrpType.POPUP;
            } else if ("BANNER".equalsIgnoreCase(mgmtType)) {
                fileGrpType = FileGrpType.BANNER;
            }

            BannerPop bannerPop = bannerPopMapper.selectBannerPop(param);

            if (bannerPop != null) {
                // 모바일 이미지
                bannerPop.setMobImageList(fileMapper.selectFileInfoList(bpSeq, fileGrpType, FileType.IMG_MOB));
                // 웹 이미지
                bannerPop.setWebImageList(fileMapper.selectFileInfoList(bpSeq, fileGrpType, FileType.IMG_WEB));
            }

            return bannerPop;
        }

        return null;
    }

    /**
     * 배너/팝업 등록
     * 
     * @param bannerPop
     * @return
     */
    @Transactional
    @TriggersRemove(cacheName = "indexCache", removeAll = true)
    public int insertBannerPop(BannerPop bannerPop) {

        bannerPop.setSiteCd(getSiteCd());
        bannerPop.setRegUser(getUserSeq());

        int result = bannerPopMapper.insertBannerPop(bannerPop);

        if (result > 0) {
            // 모바일 이미지 파일 등록
            if (bannerPop.getMobImageList() != null && !bannerPop.getMobImageList().isEmpty()) {
                for (FileInfo fileInfo : bannerPop.getMobImageList()) {
                    fileInfo.setFileGrpSeq(bannerPop.getBpSeq());
                    fileInfo.setRegUser(getUserSeq());
                    fileMapper.insertFileInfo(fileInfo);
                }
            }
            // 웹 이미지 파일 등록
            if (bannerPop.getWebImageList() != null && !bannerPop.getWebImageList().isEmpty()) {
                for (FileInfo fileInfo : bannerPop.getWebImageList()) {
                    fileInfo.setFileGrpSeq(bannerPop.getBpSeq());
                    fileInfo.setRegUser(getUserSeq());
                    fileMapper.insertFileInfo(fileInfo);
                }
            }
        }

        return result;
    }

    /**
     * 배너/팝업 수정
     * 
     * @param bannerPop
     * @param deleteFile
     * @return
     */
    @Transactional
    @TriggersRemove(cacheName = "indexCache", removeAll = true)
    public int updateBannerPop(BannerPop bannerPop, String deleteFile) {

        bannerPop.setSiteCd(getSiteCd());
        bannerPop.setRegUser(getUserSeq());

        int result = bannerPopMapper.updateBannerPop(bannerPop);

        if (result > 0) {

            // 파일 삭제
            if (StringUtils.isNotEmpty(deleteFile)) {

                String[] deleteFiles = deleteFile.split("[|]");
                FileInfo fileInfo = null;
                long tmpFileSeq = 0L;

                for (String delFileSeq : deleteFiles) {
                    tmpFileSeq = NumberUtils.toLong(delFileSeq, 0L);
                    fileInfo = new FileInfo();
                    fileInfo.setFileSeq(NumberUtils.toLong(delFileSeq, 0L));
                    fileInfo.setModUser(getUserSeq());
                    if (tmpFileSeq > 0) {
                        fileMapper.deleteFileInfo(fileInfo);
                    }
                }

            }

            // 모바일 이미지 파일 등록
            if (bannerPop.getMobImageList() != null && !bannerPop.getMobImageList().isEmpty()) {
                for (FileInfo fileInfo : bannerPop.getMobImageList()) {
                    fileInfo.setFileGrpSeq(bannerPop.getBpSeq());
                    fileInfo.setRegUser(getUserSeq());
                    fileMapper.insertFileInfo(fileInfo);
                }
            }

            // 웹 이미지 파일 등록
            if (bannerPop.getWebImageList() != null && !bannerPop.getWebImageList().isEmpty()) {
                for (FileInfo fileInfo : bannerPop.getWebImageList()) {
                    fileInfo.setFileGrpSeq(bannerPop.getBpSeq());
                    fileInfo.setRegUser(getUserSeq());
                    fileMapper.insertFileInfo(fileInfo);
                }
            }
        }

        return result;

    }

    /**
     * 메인화면 배너 목록 조회
     * 
     * @param fileGrpType
     * @return
     */
    public List<BannerPop> selectMainBannerList(FileGrpType fileGrpType) {

        Map<String, Object> param = new HashMap<>();
        param.put("siteCd", getSiteCd());
        param.put("type", fileGrpType);

        List<BannerPop> list = bannerPopMapper.selectMainBannerPopList(param);

        if (list != null && !list.isEmpty()) {
            for (BannerPop bannerPop : list) {
                // 모바일 이미지
                bannerPop.setMobImageList(fileMapper.selectFileInfoList(bannerPop.getBpSeq(), fileGrpType, FileType.IMG_MOB));
                // 웹 이미지
                bannerPop.setWebImageList(fileMapper.selectFileInfoList(bannerPop.getBpSeq(), fileGrpType, FileType.IMG_WEB));
            }
            return list;
        }

        return null;
    }

}
