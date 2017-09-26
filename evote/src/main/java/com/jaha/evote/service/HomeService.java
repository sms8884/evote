/**
 * Copyright (c) 2016 JAHA SMART CORP., LTD ALL RIGHT RESERVED
 */
package com.jaha.evote.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.googlecode.ehcache.annotations.Cacheable;
import com.jaha.evote.domain.BannerPop;
import com.jaha.evote.domain.BoardPost;
import com.jaha.evote.domain.Proposal;
import com.jaha.evote.domain.type.FileGrpType;
import com.jaha.evote.mapper.BusinessMapper;
import com.jaha.evote.mapper.ProposalMapper;

/**
 * <pre>
 * Class Name : HomeService.java
 * Description : 메인 서비스
 *  
 * Modification Information
 * 
 * Mod Date         Modifier    Description
 * -----------      --------    ---------------------------
 * 2016. 11. 1.     jjpark      Generation
 * </pre>
 *
 * @author jjpark
 * @since 2016. 11. 1.
 * @version 1.0
 */
@Service
public class HomeService extends BaseService {

    @Autowired
    private BoardService boardService;

    @Autowired
    private ProposalMapper proposalMapper;

    @Autowired
    private BannerPopService bannerPopService;

    @Autowired
    private BusinessMapper businessMapper;

    @Value("${board.name.notice}")
    private String defaultNoticeBoardName;

    /**
     * 메인 컨텐츠 조회
     * 
     * @return
     */
    @Cacheable(cacheName = "indexCache")
    public Map<String, Object> selectMainContents() {

        // 메인 > 공지사항
        List<BoardPost> noticeList = boardService.selectRecentBoardPostList(defaultNoticeBoardName, 5);

        // 메인 > 위원회 활동
        List<BoardPost> cmitList = boardService.selectRecentBoardPostList("cmit", 3);

        // 메인 > 정책제안 함께 생각하기
        List<Proposal> proposalList = proposalMapper.selectMainProposalList(getSiteCd());

        // 메인 > 팝업 목록
        List<BannerPop> popupList = bannerPopService.selectMainBannerList(FileGrpType.POPUP);

        // 메인 > 배너 목록
        List<BannerPop> bannerList = bannerPopService.selectMainBannerList(FileGrpType.BANNER);

        // 참여예산 사업현황 목록
        List<?> bizList = businessMapper.selectBusinessListTop3();

        Map<String, Object> map = new HashMap<>();
        map.put("noticeList", noticeList);
        map.put("cmitList", cmitList);
        map.put("proposalList", proposalList);
        map.put("popupList", popupList);
        map.put("bannerList", bannerList);
        map.put("bizList", bizList);

        return map;
    }

}
