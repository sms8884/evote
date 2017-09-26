/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 */
package com.jaha.evote.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.jaha.evote.domain.Config;

/**
 * <pre>
 * Class Name : ConfigMapper.java
 * Description : Description
 *  
 * Modification Information
 * 
 * Mod Date         Modifier    Description
 * -----------      --------    ---------------------------
 * 2016. 10. 10.     jjpark      Generation
 * </pre>
 *
 * @author jjpark
 * @since 2016. 10. 10.
 * @version 1.0
 */
@Mapper
public interface ConfigMapper {

    /**
     * 푸시키 목록 수 조회
     * 
     * @param config
     * @return
     */
    public int selectPushKeyListCount(Config config);

    /**
     * 푸시키 목록 조회 - PUSH KEY 단일 조회
     * 
     * @param config
     * @return
     */
    public List<String> selectPushKeyList(Config config);

    /**
     * 푸시키 목록 조회 - CONFIG 정보 포함 조회
     * 
     * @param config
     * @return
     */
    public List<Map<String, Object>> selectPushKeyListWithConfigInfo(Config config);

    /**
     * 설정 카운트 조회 (유효성 체크)
     * 
     * @param config
     * @return
     */
    public int selectConfigCount(Config config);

    /**
     * 사용자 설정 목록 조회
     * 
     * @param userSeq
     * @return
     */
    public List<Config> selectMemberConfigList(long userSeq);

    /**
     * 사용자 설정 저장
     * 
     * @param config
     * @return
     */
    public int saveMemberConfig(Config config);

}
