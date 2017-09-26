/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 */
package com.jaha.evote.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.jaha.evote.domain.PublicSubscription;

/**
 * <pre>
 * Class Name : PublicSubscriptionMapper.java
 * Description : 공모 매퍼
 *  
 * Modification Information
 * 
 * Mod Date         Modifier    Description
 * -----------      --------    ---------------------------
 * 2016. 8. 18.     jjpark      Generation
 * </pre>
 *
 * @author jjpark
 * @since 2016. 8. 18.
 * @version 1.0
 */
@Mapper
public interface PublicSubscriptionMapper {

    /**
     * 공모 조회
     * 
     * @param siteCd
     * @return
     */
    public List<PublicSubscription> selectCurrentPssrpList(String siteCd);

}
