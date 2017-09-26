package com.jaha.evote.service;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import com.jaha.evote.domain.RealmVO;
import com.jaha.evote.mapper.RealmMapper;

/**
 * <pre>
 * Class Name : RealmService.java
 * Description : 분야 서비스
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
@Service
public class RealmService extends BaseService {

    @Inject
    private RealmMapper realmMapper;

    ///////////////////////////////////////////////////////////////////////////
    // 미사용 항목 삭제
    // 
    //    // 미사용
    //    @Deprecated
    //    public List<RealmVO> selectRealmList(Map<String, Object> params) {
    //        params.put("siteCd", getSiteCd());
    //        return realmMapper.selectRealmList(params);
    //    }
    //    
    //    // 미사용
    //    @Deprecated
    //    public int selectRealmListCount(Map<String, Object> params) {
    //        params.put("siteCd", getSiteCd());
    //        return realmMapper.selectRealmListCount(params);
    //    }

    /**
     * 분야 전체 목록 조회
     * 
     * @param params
     * @return
     */
    public List<RealmVO> selectRealmListAll(Map<String, Object> params) {
        params.put("siteCd", getSiteCd());
        return realmMapper.selectRealmListAll(params);
    }

}
