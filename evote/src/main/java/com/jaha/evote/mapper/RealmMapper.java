/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 */
package com.jaha.evote.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.jaha.evote.domain.RealmVO;

/**
 * <pre>
 * Class Name : RealmlMapper.java
 * Description : 분야 매퍼
 *  
 * Modification Information
 * 
 * Mod Date         Modifier    Description
 * -----------      --------    ---------------------------
 * 2016. 7. 14.     shavrani      Generation
 * </pre>
 *
 * @author shavrani
 * @since 2016. 7. 14.
 * @version 1.0
 */
@Mapper
public interface RealmMapper {

    ///////////////////////////////////////////////////////////////////////////
    // 
    // 미사용 항목 삭제
    //
    //    /**
    //     * 분야 조회
    //     * 
    //     * @param params
    //     * @return
    //     */
    //    @Deprecated
    //    public List<RealmVO> selectRealmList(Map<String, Object> params);
    //
    //    /**
    //     * 분야 카운트
    //     * 
    //     * @param params
    //     * @return
    //     */
    //    @Deprecated
    //    public int selectRealmListCount(Map<String, Object> params);

    /**
     * 분야 전체 목록
     * 
     * @param params
     * @return
     */
    public List<RealmVO> selectRealmListAll(Map<String, Object> params);

}
