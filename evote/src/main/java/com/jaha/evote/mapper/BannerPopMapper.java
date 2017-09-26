/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 */
package com.jaha.evote.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.jaha.evote.domain.BannerPop;

/**
 * <pre>
 * Class Name : BannerPopMapper.java
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
@Mapper
public interface BannerPopMapper {

    /**
     * 배너/팝업 카운트 조회
     * 
     * @param searchParam
     * @return
     */
    public int selectBannerPopListCount(BannerPop searchParam);

    /**
     * 배너/팝업 목록 조회
     * 
     * @param searchParam
     * @return
     */
    public List<BannerPop> selectBannerPopList(BannerPop searchParam);

    /**
     * 배너/팝업 상세 조회
     * 
     * @param param
     * @return
     */
    public BannerPop selectBannerPop(Map<String, Object> param);

    /**
     * 메인 배너/팝업 목록 조회
     * 
     * @param param
     * @return
     */
    public List<BannerPop> selectMainBannerPopList(Map<String, Object> param);

    /**
     * 배너/팝업 등록
     * 
     * @param bannerPop
     * @return
     */
    public int insertBannerPop(BannerPop bannerPop);

    /**
     * 배너/팝업 수정
     * 
     * @param bannerPop
     * @return
     */
    public int updateBannerPop(BannerPop bannerPop);

}
